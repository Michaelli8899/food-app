import Foundation

// Pure game logic. No SwiftUI / SwiftData here so it is easy to unit test.
// All progress (XP, stamps, badges, quests) is *derived* from the list of
// logged meals, so editing or deleting an entry always keeps things consistent.

// MARK: - Input

struct LogRecord: Identifiable, Hashable {
    var id: UUID = UUID()
    var date: Date
    var title: String = ""
    var hasPhoto: Bool = false
    var source: FoodSource? = nil
    var cuisines: [Cuisine] = []
    var foodTypes: Set<FoodType> = []
    var meal: MealType = .lunch
    var rating: Rating? = nil
    var placeName: String = ""

    var dishKey: String? { LogRecord.key(title) }
    var placeKey: String? { LogRecord.key(placeName) }
    var collectibleCuisines: [Cuisine] { cuisines.filter(\.isCollectible) }

    var isFullyTagged: Bool { source != nil && !cuisines.isEmpty && !foodTypes.isEmpty }

    static func key(_ text: String) -> String? {
        let k = text.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return k.isEmpty ? nil : k
    }
}

// MARK: - XP

enum XPRules {
    static let logEntry = 10
    static let sourceTag = 2
    static let cuisineTag = 3
    static let foodTypesTag = 3
    static let ratingTag = 2
    static let homeCookedBonus = 5
    static let newDish = 15
    static let newPlace = 20
    static let newCuisine = 50
    static let questComplete = 100
    /// Only the first N entries per day earn logging XP (prevents spam-logging).
    static let dailyEntryCap = 6

    static func entryXP(for r: LogRecord) -> Int {
        var xp = logEntry
        if r.source != nil { xp += sourceTag }
        if !r.cuisines.isEmpty { xp += cuisineTag }
        if !r.foodTypes.isEmpty { xp += foodTypesTag }
        if r.rating != nil { xp += ratingTag }
        if r.source == .home { xp += homeCookedBonus }
        return xp
    }
}

// MARK: - Levels

struct LevelInfo: Hashable {
    let level: Int
    let title: String
    let xpIntoLevel: Int
    let xpNeeded: Int

    var progress: Double { xpNeeded == 0 ? 1 : Double(xpIntoLevel) / Double(xpNeeded) }

    /// Total XP needed to *reach* a level. L1 = 0, L2 = 50, L3 = 150, L4 = 300, L5 = 500…
    static func xpRequired(forLevel level: Int) -> Int { 25 * (level - 1) * level }

    static func from(xp: Int) -> LevelInfo {
        var level = 1
        while xp >= xpRequired(forLevel: level + 1) { level += 1 }
        let start = xpRequired(forLevel: level)
        let next = xpRequired(forLevel: level + 1)
        return LevelInfo(level: level, title: levelTitle(for: level), xpIntoLevel: xp - start, xpNeeded: next - start)
    }

    static func levelTitle(for level: Int) -> String {
        switch level {
        case ..<3: "Snack Rookie"
        case 3..<5: "Taste Tester"
        case 5..<8: "Flavor Scout"
        case 8..<12: "Spice Adventurer"
        case 12..<17: "Gourmet"
        default: "Culinary Legend"
        }
    }
}

// MARK: - Passport stamps

enum StampTier: Int, Comparable, CaseIterable {
    case bronze = 1, silver, gold

    static func < (lhs: StampTier, rhs: StampTier) -> Bool { lhs.rawValue < rhs.rawValue }

    var label: String {
        switch self {
        case .bronze: "Bronze"
        case .silver: "Silver"
        case .gold: "Gold"
        }
    }

    static let dishesForSilver = 5
}

struct CuisineStamp: Hashable {
    let cuisine: Cuisine
    let firstDate: Date
    let firstDish: String
    var dishes: Set<String> = []
    var entryCount = 0
    var cookedAtHome = false

    /// Bronze: tried it. Silver: 5 different dishes. Gold: 5 dishes + cooked it at home.
    var tier: StampTier {
        if dishes.count >= StampTier.dishesForSilver { return cookedAtHome ? .gold : .silver }
        return .bronze
    }

    mutating func record(_ r: LogRecord) {
        entryCount += 1
        if let d = r.dishKey { dishes.insert(d) }
        if r.source == .home { cookedAtHome = true }
    }
}

// MARK: - Lifetime stats

struct LifetimeStats: Hashable {
    var entries = 0
    var photos = 0
    var homeCooked = 0
    var rated = 0
    var brunches = 0
    var lateNight = 0
    var spicy = 0
    var seafood = 0
    var plantBased = 0
    var placeVisits: [String: Int] = [:]
    var dishCounts: [String: Int] = [:]
    var cuisines: Set<Cuisine> = []
    var months: Set<String> = []
    var maxLeftoverRun = 0
    var midnightRamen = false

    var distinctPlaces: Int { placeVisits.count }
    var maxPlaceVisits: Int { placeVisits.values.max() ?? 0 }
    var maxDishCount: Int { dishCounts.values.max() ?? 0 }
    var regions: Set<Region> { Set(cuisines.map(\.region)) }

    mutating func record(_ r: LogRecord, calendar: Calendar) {
        entries += 1
        if r.hasPhoto { photos += 1 }
        if r.source == .home { homeCooked += 1 }
        if r.rating != nil { rated += 1 }
        if r.meal == .brunch { brunches += 1 }
        if r.meal == .lateNight { lateNight += 1 }
        if r.foodTypes.contains(.spicy) { spicy += 1 }
        if r.foodTypes.contains(.seafood) { seafood += 1 }
        if r.foodTypes.contains(.plantBased) { plantBased += 1 }
        if let p = r.placeKey { placeVisits[p, default: 0] += 1 }
        if let d = r.dishKey { dishCounts[d, default: 0] += 1 }
        cuisines.formUnion(r.collectibleCuisines)
        let ym = calendar.dateComponents([.year, .month], from: r.date)
        months.insert("\(ym.year ?? 0)-\(ym.month ?? 0)")
        let hour = calendar.component(.hour, from: r.date)
        if (r.dishKey ?? "").contains("ramen") && (hour >= 22 || hour < 4) { midnightRamen = true }
    }
}

// MARK: - Badges

struct BadgeDefinition: Identifiable {
    let id: String
    let emoji: String
    let name: String
    let detail: String
    var hidden = false
    let isEarned: (LifetimeStats) -> Bool
}

enum Badges {
    static let all: [BadgeDefinition] = [
        BadgeDefinition(id: "firstBite", emoji: "🍴", name: "First Bite", detail: "Log your first meal") { $0.entries >= 1 },
        BadgeDefinition(id: "shutterbug", emoji: "📸", name: "Shutterbug", detail: "Log 25 meals with photos") { $0.photos >= 25 },
        BadgeDefinition(id: "globetrotter1", emoji: "🧳", name: "Globetrotter I", detail: "Collect 5 cuisines") { $0.cuisines.count >= 5 },
        BadgeDefinition(id: "globetrotter2", emoji: "✈️", name: "Globetrotter II", detail: "Collect 15 cuisines") { $0.cuisines.count >= 15 },
        BadgeDefinition(id: "globetrotter3", emoji: "🌏", name: "Globetrotter III", detail: "Collect 30 cuisines") { $0.cuisines.count >= 30 },
        BadgeDefinition(id: "worldTour", emoji: "🗺️", name: "World Tour", detail: "A cuisine from every region") { $0.regions.isSuperset(of: Region.passportRegions) },
        BadgeDefinition(id: "homeChef1", emoji: "🍳", name: "Home Chef I", detail: "Cook 10 meals at home") { $0.homeCooked >= 10 },
        BadgeDefinition(id: "homeChef2", emoji: "👩‍🍳", name: "Home Chef II", detail: "Cook 50 meals at home") { $0.homeCooked >= 50 },
        BadgeDefinition(id: "homeChef3", emoji: "🔪", name: "Home Chef III", detail: "Cook 150 meals at home") { $0.homeCooked >= 150 },
        BadgeDefinition(id: "regular", emoji: "🪑", name: "Regular", detail: "Visit the same place 5 times") { $0.maxPlaceVisits >= 5 },
        BadgeDefinition(id: "gemHunter", emoji: "💎", name: "Hidden Gem Hunter", detail: "Eat at 10 different places") { $0.distinctPlaces >= 10 },
        BadgeDefinition(id: "brunchClub", emoji: "🥂", name: "Brunch Club", detail: "Log 5 brunches") { $0.brunches >= 5 },
        BadgeDefinition(id: "nightOwl", emoji: "🦉", name: "Night Owl", detail: "Log 5 late-night bites") { $0.lateNight >= 5 },
        BadgeDefinition(id: "feelTheHeat", emoji: "🔥", name: "Feel the Heat", detail: "Eat 10 spicy dishes") { $0.spicy >= 10 },
        BadgeDefinition(id: "seaLegs", emoji: "⚓", name: "Sea Legs", detail: "Eat 10 seafood dishes") { $0.seafood >= 10 },
        BadgeDefinition(id: "plantPower", emoji: "🌿", name: "Plant Power", detail: "Log 50 plant-based meals") { $0.plantBased >= 50 },
        BadgeDefinition(id: "critic", emoji: "🧐", name: "Critic", detail: "Rate 50 dishes") { $0.rated >= 50 },
        BadgeDefinition(id: "comfortClassic", emoji: "🧸", name: "Comfort Classic", detail: "Eat the same dish 10 times") { $0.maxDishCount >= 10 },
        BadgeDefinition(id: "leftoverLegend", emoji: "🍱", name: "Leftover Legend", detail: "Same home-cooked dish 3 days in a row") { $0.maxLeftoverRun >= 3 },
        BadgeDefinition(id: "yearOne", emoji: "🎂", name: "Year One", detail: "Log meals in 12 different months") { $0.months.count >= 12 },
        BadgeDefinition(id: "midnightRamen", emoji: "🍜", name: "Midnight Ramen", detail: "Ramen after 10pm", hidden: true) { $0.midnightRamen },
    ]

    static func definition(id: String) -> BadgeDefinition? { all.first { $0.id == id } }
}

// MARK: - Weekly quests

enum QuestDifficulty: String, CaseIterable {
    case easy, medium, adventure

    var label: String {
        switch self {
        case .easy: "Easy"
        case .medium: "Medium"
        case .adventure: "Adventure"
        }
    }
}

struct QuestContext {
    let weekStart: Date
    let weekRecords: [LogRecord]
    let prior: [LogRecord]
    let calendar: Calendar
}

struct QuestDefinition {
    let id: String
    let difficulty: QuestDifficulty
    let emoji: String
    let build: (QuestContext) -> (title: String, target: Int, progress: Int)
    var isAvailable: (QuestContext) -> Bool = { _ in true }
}

struct QuestStatus: Identifiable, Hashable {
    let id: String
    let difficulty: QuestDifficulty
    let emoji: String
    let title: String
    let target: Int
    let progress: Int

    var isComplete: Bool { progress >= target }
    var clampedProgress: Int { min(progress, target) }
}

enum Quests {
    static let all: [QuestDefinition] = [
        // Easy
        QuestDefinition(id: "photos7", difficulty: .easy, emoji: "📸") { ctx in
            ("Log 7 meals with photos", 7, ctx.weekRecords.filter(\.hasPhoto).count)
        },
        QuestDefinition(id: "rate5", difficulty: .easy, emoji: "⭐") { ctx in
            ("Rate 5 dishes", 5, ctx.weekRecords.filter { $0.rating != nil }.count)
        },
        QuestDefinition(id: "breakfast3", difficulty: .easy, emoji: "🍳") { ctx in
            ("Log breakfast or brunch 3 times", 3, ctx.weekRecords.filter { $0.meal == .breakfast || $0.meal == .brunch }.count)
        },
        QuestDefinition(id: "days4", difficulty: .easy, emoji: "📅") { ctx in
            let days = Set(ctx.weekRecords.map { ctx.calendar.startOfDay(for: $0.date) })
            return ("Log on 4 different days", 4, days.count)
        },

        // Medium
        QuestDefinition(id: "cookHome", difficulty: .medium, emoji: "🏠") { ctx in
            // Adapts to the user: takeout-heavy users get an easier target.
            let twoWeeksAgo = ctx.calendar.date(byAdding: .day, value: -14, to: ctx.weekStart) ?? ctx.weekStart
            let recent = ctx.prior.filter { $0.date >= twoWeeksAgo }
            let homeShare = recent.isEmpty ? 0 : Double(recent.filter { $0.source == .home }.count) / Double(recent.count)
            let target = homeShare < 0.2 ? 1 : 3
            let title = target == 1 ? "Cook a meal at home" : "Cook at home \(target) times"
            return (title, target, ctx.weekRecords.filter { $0.source == .home }.count)
        },
        QuestDefinition(id: "cuisines3", difficulty: .medium, emoji: "🌍") { ctx in
            ("Eat 3 different cuisines", 3, Set(ctx.weekRecords.flatMap { $0.cuisines }).count)
        },
        QuestDefinition(id: "plantMix", difficulty: .medium, emoji: "🥗") { ctx in
            let types = Set(ctx.weekRecords.flatMap { $0.foodTypes })
            return ("Plant mix: veggies, fruit, grains & legumes", 4, FoodType.plantGroups.filter { types.contains($0) }.count)
        },
        QuestDefinition(id: "tag5", difficulty: .medium, emoji: "🏷️") { ctx in
            ("Fully tag 5 meals (source, cuisine, food types)", 5, ctx.weekRecords.filter(\.isFullyTagged).count)
        },

        // Adventure
        QuestDefinition(id: "newCuisine", difficulty: .adventure, emoji: "🛂") { ctx in
            let known = Set(ctx.prior.flatMap { $0.collectibleCuisines })
            let fresh = Set(ctx.weekRecords.flatMap { $0.collectibleCuisines }).subtracting(known)
            return ("Try a cuisine you've never had", 1, fresh.count)
        },
        QuestDefinition(id: "newPlace", difficulty: .adventure, emoji: "📍") { ctx in
            let known = Set(ctx.prior.compactMap { $0.placeKey })
            let fresh = Set(ctx.weekRecords.compactMap { $0.placeKey }).subtracting(known)
            return ("Eat somewhere new", 1, fresh.count)
        },
        QuestDefinition(
            id: "cookOut",
            difficulty: .adventure,
            emoji: "👩‍🍳",
            build: { ctx in
                let candidates = Quests.cookOutCandidates(ctx)
                let cooked = Set(ctx.weekRecords.filter { $0.source == .home }.flatMap { $0.collectibleCuisines })
                return ("Cook a cuisine at home you've only eaten out", 1, cooked.intersection(candidates).count)
            },
            isAvailable: { !Quests.cookOutCandidates($0).isEmpty }
        ),
    ]

    /// Cuisines the user has eaten out before but never cooked at home.
    static func cookOutCandidates(_ ctx: QuestContext) -> Set<Cuisine> {
        let eatenOut = Set(ctx.prior.filter { $0.source != nil && $0.source != .home }.flatMap { $0.collectibleCuisines })
        let cooked = Set(ctx.prior.filter { $0.source == .home }.flatMap { $0.collectibleCuisines })
        return eatenOut.subtracting(cooked)
    }
}

// MARK: - Output

struct GameState {
    var xp: Int
    var level: LevelInfo
    var stats: LifetimeStats
    var stamps: [Cuisine: CuisineStamp]
    var badgesUnlocked: [String: Date]
    var questsCompleted: Int
    var currentQuests: [QuestStatus]

    static let empty = GameState(
        xp: 0, level: .from(xp: 0), stats: LifetimeStats(), stamps: [:],
        badgesUnlocked: [:], questsCompleted: 0, currentQuests: []
    )
}

enum RewardEvent: Identifiable, Hashable {
    case newStamp(Cuisine, collected: Int)
    case stampUpgraded(Cuisine, StampTier)
    case badge(String)
    case questComplete(String)
    case levelUp(Int, String)

    var id: String {
        switch self {
        case .newStamp(let c, _): "stamp-\(c.rawValue)"
        case .stampUpgraded(let c, let t): "tier-\(c.rawValue)-\(t.rawValue)"
        case .badge(let id): "badge-\(id)"
        case .questComplete(let title): "quest-\(title)"
        case .levelUp(let level, _): "level-\(level)"
        }
    }

    var emoji: String {
        switch self {
        case .newStamp(let c, _): c.emoji
        case .stampUpgraded(let c, _): c.emoji
        case .badge(let id): Badges.definition(id: id)?.emoji ?? "🏅"
        case .questComplete: "🎯"
        case .levelUp: "⬆️"
        }
    }

    var title: String {
        switch self {
        case .newStamp(let c, _): "New stamp: \(c.name)!"
        case .stampUpgraded(let c, let t): "\(c.name) stamp is now \(t.label)!"
        case .badge(let id): "Badge unlocked: \(Badges.definition(id: id)?.name ?? id)"
        case .questComplete: "Quest complete!"
        case .levelUp(let level, _): "Level \(level)!"
        }
    }

    var subtitle: String {
        switch self {
        case .newStamp(_, let collected): "Stamp \(collected) of \(Cuisine.collectible.count) in your passport"
        case .stampUpgraded(_, let t): t == .gold ? "Fully mastered — tried it out and cooked it at home." : "You've tried 5 different dishes."
        case .badge(let id): Badges.definition(id: id)?.detail ?? ""
        case .questComplete(let title): "\(title) · +\(XPRules.questComplete) XP"
        case .levelUp(_, let title): "You're now a \(title)."
        }
    }
}

// MARK: - Engine

struct GameEngine {
    let calendar: Calendar

    init(calendar: Calendar = .biteLog) {
        self.calendar = calendar
    }

    func weekStart(for date: Date) -> Date {
        calendar.dateInterval(of: .weekOfYear, for: date)?.start ?? calendar.startOfDay(for: date)
    }

    /// Seven booleans (Mon…Sun) saying whether anything was logged that day.
    func daysLogged(inWeekOf date: Date, records: [LogRecord]) -> [Bool] {
        let start = weekStart(for: date)
        let loggedDays = Set(records.map { calendar.startOfDay(for: $0.date) })
        return (0..<7).map { offset in
            guard let day = calendar.date(byAdding: .day, value: offset, to: start) else { return false }
            return loggedDays.contains(calendar.startOfDay(for: day))
        }
    }

    func quests(weekStart: Date, weekRecords: [LogRecord], prior: [LogRecord], reroll: Int) -> [QuestStatus] {
        let ctx = QuestContext(weekStart: weekStart, weekRecords: weekRecords, prior: prior, calendar: calendar)
        let seed = weekSeed(weekStart) + reroll * 7919
        var result: [QuestStatus] = []
        for (index, difficulty) in QuestDifficulty.allCases.enumerated() {
            let pool = Quests.all.filter { $0.difficulty == difficulty && $0.isAvailable(ctx) }
            guard !pool.isEmpty else { continue }
            let raw = seed + index * 31
            let def = pool[((raw % pool.count) + pool.count) % pool.count]
            let built = def.build(ctx)
            result.append(QuestStatus(id: def.id, difficulty: difficulty, emoji: def.emoji,
                                      title: built.title, target: built.target, progress: built.progress))
        }
        return result
    }

    private func weekSeed(_ weekStart: Date) -> Int {
        let c = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: weekStart)
        return (c.yearForWeekOfYear ?? 0) * 53 + (c.weekOfYear ?? 0)
    }

    func state(for input: [LogRecord], now: Date = Date(), reroll: (Date) -> Int = { _ in 0 }) -> GameState {
        let records = input.sorted { $0.date < $1.date }
        var stats = LifetimeStats()
        var stamps: [Cuisine: CuisineStamp] = [:]
        var badges: [String: Date] = [:]
        var xp = 0
        var seenDishes = Set<String>()
        var seenPlaces = Set<String>()
        var entriesPerDay: [Date: Int] = [:]
        var leftoverRuns: [String: (day: Date, run: Int)] = [:]

        for r in records {
            let day = calendar.startOfDay(for: r.date)
            let countToday = (entriesPerDay[day] ?? 0) + 1
            entriesPerDay[day] = countToday
            if countToday <= XPRules.dailyEntryCap { xp += XPRules.entryXP(for: r) }

            if let d = r.dishKey, seenDishes.insert(d).inserted { xp += XPRules.newDish }
            if let p = r.placeKey, seenPlaces.insert(p).inserted { xp += XPRules.newPlace }

            for c in Set(r.collectibleCuisines) {
                if stamps[c] == nil {
                    xp += XPRules.newCuisine
                    stamps[c] = CuisineStamp(cuisine: c, firstDate: r.date, firstDish: r.title)
                }
                stamps[c]?.record(r)
            }

            stats.record(r, calendar: calendar)

            if r.source == .home, let d = r.dishKey {
                var run = 1
                if let prev = leftoverRuns[d] {
                    let gap = calendar.dateComponents([.day], from: prev.day, to: day).day ?? 0
                    run = gap == 0 ? prev.run : (gap == 1 ? prev.run + 1 : 1)
                }
                leftoverRuns[d] = (day, run)
                stats.maxLeftoverRun = max(stats.maxLeftoverRun, run)
            }

            for b in Badges.all where badges[b.id] == nil && b.isEarned(stats) {
                badges[b.id] = r.date
            }
        }

        // Quests: recompute every past week deterministically.
        let byWeek = Dictionary(grouping: records) { weekStart(for: $0.date) }
        var completed = 0
        for (week, weekRecords) in byWeek {
            let prior = Array(records.prefix { $0.date < week })
            completed += quests(weekStart: week, weekRecords: weekRecords, prior: prior, reroll: reroll(week))
                .filter(\.isComplete).count
        }
        xp += completed * XPRules.questComplete

        let thisWeek = weekStart(for: now)
        let current = quests(
            weekStart: thisWeek,
            weekRecords: byWeek[thisWeek] ?? [],
            prior: Array(records.prefix { $0.date < thisWeek }),
            reroll: reroll(thisWeek)
        )

        return GameState(xp: xp, level: .from(xp: xp), stats: stats, stamps: stamps,
                         badgesUnlocked: badges, questsCompleted: completed, currentQuests: current)
    }

    /// What's new between two states — used to celebrate after saving an entry.
    func events(from before: GameState, to after: GameState) -> [RewardEvent] {
        var events: [RewardEvent] = []
        for stamp in after.stamps.values.sorted(by: { $0.firstDate < $1.firstDate }) {
            if let old = before.stamps[stamp.cuisine] {
                if stamp.tier > old.tier { events.append(.stampUpgraded(stamp.cuisine, stamp.tier)) }
            } else {
                events.append(.newStamp(stamp.cuisine, collected: after.stamps.count))
            }
        }
        for b in Badges.all where after.badgesUnlocked[b.id] != nil && before.badgesUnlocked[b.id] == nil {
            events.append(.badge(b.id))
        }
        for q in after.currentQuests where q.isComplete {
            let wasComplete = before.currentQuests.first { $0.id == q.id }?.isComplete ?? false
            if !wasComplete { events.append(.questComplete(q.title)) }
        }
        if after.level.level > before.level.level {
            events.append(.levelUp(after.level.level, after.level.title))
        }
        return events
    }
}

extension Calendar {
    /// Gregorian calendar with weeks starting on Monday.
    static var biteLog: Calendar {
        var c = Calendar(identifier: .gregorian)
        c.firstWeekday = 2
        c.minimumDaysInFirstWeek = 4
        return c
    }
}
