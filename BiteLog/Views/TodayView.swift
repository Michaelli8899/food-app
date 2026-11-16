import SwiftUI
import SwiftData

struct TodayView: View {
    @Environment(\.modelContext) private var context
    @Environment(AppModel.self) private var app
    @Query(sort: \FoodEntry.date, order: .reverse) private var entries: [FoodEntry]
    @State private var showingAdd = false

    var body: some View {
        let records = entries.map(\.record)
        let state = app.state(forRecords: records)
        let todays = entries.filter { Calendar.current.isDateInToday($0.date) }

        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    weekCard(days: app.engine.daysLogged(inWeekOf: Date(), records: records), state: state)

                    if !againEntries.isEmpty {
                        againRow
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Today").font(.title3.bold())
                        if todays.isEmpty {
                            emptyState
                        } else {
                            ForEach(todays) { entry in
                                NavigationLink(value: entry) {
                                    EntryRow(entry: entry)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding()
                .padding(.bottom, 80)
            }
            .navigationTitle(greeting)
            .navigationDestination(for: FoodEntry.self) { EntryDetailView(entry: $0) }
            .overlay(alignment: .bottom) { addButton }
            .sheet(isPresented: $showingAdd) { AddEntryView() }
        }
    }

    // MARK: Pieces

    private func weekCard(days: [Bool], state: GameState) -> some View {
        Card {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("This week").font(.headline)
                    Spacer()
                    Text("Lv \(state.level.level) · \(state.level.title)")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
                HStack(spacing: 0) {
                    ForEach(0..<7, id: \.self) { i in
                        let logged = i < days.count && days[i]
                        VStack(spacing: 4) {
                            Circle()
                                .fill(logged ? Color.accentColor : Color(.tertiarySystemFill))
                                .frame(width: 26, height: 26)
                                .overlay {
                                    if logged { Image(systemName: "checkmark").font(.caption.bold()).foregroundStyle(.white) }
                                }
                            Text(["M", "T", "W", "T", "F", "S", "S"][i]).font(.caption2).foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                if let quest = state.currentQuests.first(where: { !$0.isComplete }) {
                    Divider()
                    HStack {
                        Text(quest.emoji)
                        Text(quest.title).font(.subheadline)
                        Spacer()
                        Text("\(quest.clampedProgress)/\(quest.target)")
                            .font(.subheadline.monospacedDigit())
                            .foregroundStyle(.secondary)
                    }
                    ProgressView(value: Double(quest.clampedProgress), total: Double(quest.target))
                } else if !state.currentQuests.isEmpty {
                    Divider()
                    Label("All quests done this week. Legend!", systemImage: "checkmark.seal.fill")
                        .font(.subheadline)
                        .foregroundStyle(Color.accentColor)
                }
            }
        }
    }

    /// Frequent dishes from the last 30 days, for one-tap re-logging.
    private var againEntries: [FoodEntry] {
        let cutoff = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
        var counts: [String: (entry: FoodEntry, count: Int)] = [:]
        for entry in entries where entry.date >= cutoff {
            guard let key = LogRecord.key(entry.title) else { continue }
            if let existing = counts[key] {
                counts[key] = (existing.entry, existing.count + 1) // keep most recent (entries are newest-first)
            } else {
                counts[key] = (entry, 1)
            }
        }
        return counts.values
            .sorted { $0.count != $1.count ? $0.count > $1.count : $0.entry.date > $1.entry.date }
            .prefix(8)
            .map { $0.entry }
    }

    private var againRow: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Again?").font(.headline)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(againEntries) { entry in
                        Chip(label: "\(entry.placeholderEmoji) \(entry.title)", isSelected: false) {
                            relog(entry)
                        }
                    }
                }
            }
        }
    }

    private var emptyState: some View {
        Card {
            VStack(spacing: 8) {
                Text("🍽️").font(.system(size: 44))
                Text("Nothing logged yet today").font(.headline)
                Text("Snap your next bite. A photo is all it takes.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
    }

    private var addButton: some View {
        Button {
            showingAdd = true
        } label: {
            Label("Log a bite", systemImage: "plus")
                .font(.headline)
                .padding(.horizontal, 28)
                .padding(.vertical, 16)
                .background(Color.accentColor, in: Capsule())
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.2), radius: 8, y: 4)
        }
        .padding(.bottom, 16)
    }

    private var greeting: String {
        switch Calendar.current.component(.hour, from: Date()) {
        case 5..<12: "Good morning"
        case 12..<17: "Good afternoon"
        default: "Good evening"
        }
    }

    private func relog(_ source: FoodEntry) {
        app.commit(in: context) {
            let entry = FoodEntry(date: Date())
            entry.copyTags(from: source)
            context.insert(entry)
        }
    }
}
