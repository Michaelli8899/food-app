import Foundation
import Observation
import SwiftData

/// App-wide state: the game engine, quest shuffles, and pending celebrations.
@Observable
final class AppModel {
    let engine: GameEngine
    var pendingRewards: [RewardEvent] = []
    var xpToast: Int?

    private(set) var rerolls: [String: Int]
    private let defaults: UserDefaults
    private static let rerollKey = "questRerolls"

    init(engine: GameEngine = GameEngine(), defaults: UserDefaults = .standard) {
        self.engine = engine
        self.defaults = defaults
        self.rerolls = defaults.dictionary(forKey: Self.rerollKey) as? [String: Int] ?? [:]
    }

    // MARK: Game state

    func state(for entries: [FoodEntry], now: Date = Date()) -> GameState {
        state(forRecords: entries.map(\.record), now: now)
    }

    func state(forRecords records: [LogRecord], now: Date = Date()) -> GameState {
        let rerolls = self.rerolls
        return engine.state(for: records, now: now) { [engine] week in
            rerolls[Self.weekKey(week, engine: engine)] ?? 0
        }
    }

    /// Wrap any change to entries so we can celebrate what it unlocked.
    @MainActor
    func commit(in context: ModelContext, _ change: () -> Void) {
        let before = state(forRecords: fetchRecords(context))
        change()
        try? context.save()
        let after = state(forRecords: fetchRecords(context))

        let events = engine.events(from: before, to: after)
        let gained = after.xp - before.xp
        // Small delay so a closing sheet finishes animating before the next one opens.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            if !events.isEmpty {
                self.pendingRewards = events
            } else if gained > 0 {
                self.xpToast = gained
            }
        }
    }

    private func fetchRecords(_ context: ModelContext) -> [LogRecord] {
        let entries = (try? context.fetch(FetchDescriptor<FoodEntry>())) ?? []
        return entries.map(\.record)
    }

    // MARK: Quest shuffle (once per week, only before any quest is complete)

    func canShuffleQuests(state: GameState, now: Date = Date()) -> Bool {
        (rerolls[Self.weekKey(now, engine: engine)] ?? 0) == 0 && !state.currentQuests.contains(where: \.isComplete)
    }

    func shuffleQuests(now: Date = Date()) {
        rerolls[Self.weekKey(now, engine: engine)] = 1
        defaults.set(rerolls, forKey: Self.rerollKey)
    }

    func resetAll() {
        rerolls = [:]
        defaults.removeObject(forKey: Self.rerollKey)
    }

    private static func weekKey(_ date: Date, engine: GameEngine) -> String {
        let start = engine.weekStart(for: date)
        let c = engine.calendar.dateComponents([.year, .month, .day], from: start)
        return String(format: "%04d-%02d-%02d", c.year ?? 0, c.month ?? 0, c.day ?? 0)
    }
}
