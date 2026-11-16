import XCTest
@testable import BiteLog

final class GameEngineTests: XCTestCase {
    private var calendar: Calendar = {
        var c = Calendar.biteLog
        c.timeZone = TimeZone(identifier: "UTC")!
        return c
    }()

    private lazy var engine = GameEngine(calendar: calendar)

    /// Monday 2026-11-16 12:00 UTC + offsets.
    private func date(day: Int = 0, hour: Int = 12) -> Date {
        let base = calendar.date(from: DateComponents(year: 2026, month: 11, day: 16, hour: hour))!
        return calendar.date(byAdding: .day, value: day, to: base)!
    }

    // MARK: XP & levels

    func testEmptyStateIsLevelOne() {
        let state = engine.state(for: [], now: date())
        XCTAssertEqual(state.xp, 0)
        XCTAssertEqual(state.level.level, 1)
        XCTAssertEqual(state.level.title, "Snack Rookie")
        XCTAssertTrue(state.stamps.isEmpty)
    }

    func testPhotoOnlyEntryEarnsBaseXP() {
        let r = LogRecord(date: date(), hasPhoto: true)
        let state = engine.state(for: [r], now: date())
        XCTAssertEqual(state.xp, XPRules.logEntry)
        XCTAssertNotNil(state.badgesUnlocked["firstBite"])
    }

    func testFullyTaggedHomeMealXP() {
        let r = LogRecord(date: date(), title: "Pad thai", source: .home, cuisines: [.thai],
                          foodTypes: [.grains, .spicy], rating: .love)
        let expected = XPRules.logEntry + XPRules.sourceTag + XPRules.cuisineTag + XPRules.foodTypesTag
            + XPRules.ratingTag + XPRules.homeCookedBonus + XPRules.newDish + XPRules.newCuisine
        XCTAssertEqual(XPRules.entryXP(for: r) + XPRules.newDish + XPRules.newCuisine, expected)
        let state = engine.state(for: [r], now: date(day: 14)) // a later week, so no current-quest noise
        XCTAssertGreaterThanOrEqual(state.xp, expected)
    }

    func testDailyCapLimitsLoggingXP() {
        let records = (0..<10).map { i in LogRecord(date: date(hour: 8 + i), hasPhoto: true) }
        let state = engine.state(for: records, now: date(day: 30))
        // Only 6 entries count; quests may add more on top, so check the logging part alone.
        XCTAssertEqual(state.xp - state.questsCompleted * XPRules.questComplete, XPRules.dailyEntryCap * XPRules.logEntry)
    }

    func testLevelThresholds() {
        XCTAssertEqual(LevelInfo.from(xp: 49).level, 1)
        XCTAssertEqual(LevelInfo.from(xp: 50).level, 2)
        XCTAssertEqual(LevelInfo.from(xp: 150).level, 3)
        XCTAssertEqual(LevelInfo.from(xp: 300).level, 4)
        let mid = LevelInfo.from(xp: 100)
        XCTAssertEqual(mid.xpIntoLevel, 50)
        XCTAssertEqual(mid.xpNeeded, 100)
    }

    // MARK: Passport

    func testStampTiers() {
        var records = ["Ramen", "Sushi", "Udon", "Katsu curry", "Onigiri"].enumerated().map { i, dish in
            LogRecord(date: date(day: i), title: dish, source: .restaurant, cuisines: [.japanese])
        }
        XCTAssertEqual(engine.state(for: Array(records.prefix(4)), now: date()).stamps[.japanese]?.tier, .bronze)
        XCTAssertEqual(engine.state(for: records, now: date()).stamps[.japanese]?.tier, .silver)

        records.append(LogRecord(date: date(day: 6), title: "Miso soup", source: .home, cuisines: [.japanese]))
        XCTAssertEqual(engine.state(for: records, now: date()).stamps[.japanese]?.tier, .gold)
    }

    func testFusionDoesNotEarnStamp() {
        let r = LogRecord(date: date(), title: "Kimchi tacos", cuisines: [.fusion])
        XCTAssertTrue(engine.state(for: [r], now: date()).stamps.isEmpty)
    }

    func testRepeatDishDoesNotCountAsNewDish() {
        let a = LogRecord(date: date(), title: "Bagel")
        let b = LogRecord(date: date(day: 1), title: "  bagel ")
        let one = engine.state(for: [a], now: date(day: 30)).xp
        let two = engine.state(for: [a, b], now: date(day: 30)).xp
        XCTAssertEqual(two - one, XPRules.logEntry)
    }

    // MARK: Badges

    func testLeftoverLegend() {
        let records = (0..<3).map { LogRecord(date: date(day: $0), title: "Chili", source: .home) }
        XCTAssertNotNil(engine.state(for: records, now: date()).badgesUnlocked["leftoverLegend"])

        let broken = [records[0], records[2]]
        XCTAssertNil(engine.state(for: broken, now: date()).badgesUnlocked["leftoverLegend"])
    }

    func testGlobetrotter() {
        let cuisines: [Cuisine] = [.thai, .italian, .mexican, .korean, .ethiopian]
        let records = cuisines.enumerated().map { i, c in LogRecord(date: date(day: i), cuisines: [c]) }
        XCTAssertNotNil(engine.state(for: records, now: date()).badgesUnlocked["globetrotter1"])
    }

    // MARK: Quests

    func testThreeQuestsOnePerDifficulty() {
        let quests = engine.state(for: [], now: date()).currentQuests
        // "cookOut" is unavailable for a brand-new user, but every difficulty still has options.
        XCTAssertEqual(quests.map(\.difficulty), [.easy, .medium, .adventure])
    }

    func testQuestsAreStableAndShuffleChangesThem() {
        let a = engine.state(for: [], now: date()).currentQuests.map(\.id)
        let b = engine.state(for: [], now: date(day: 3)).currentQuests.map(\.id) // same week
        XCTAssertEqual(a, b)
        let shuffled = engine.state(for: [], now: date()) { _ in 1 }.currentQuests.map(\.id)
        XCTAssertNotEqual(a, shuffled)
    }

    func testNewCuisineQuestProgress() {
        let week = engine.weekStart(for: date())
        let prior = [LogRecord(date: date(day: -10), cuisines: [.italian])]
        let thisWeek = [
            LogRecord(date: date(), cuisines: [.italian]),
            LogRecord(date: date(day: 1), cuisines: [.peruvian]),
        ]
        let quest = Quests.all.first { $0.id == "newCuisine" }!
        let ctx = QuestContext(weekStart: week, weekRecords: thisWeek, prior: prior, calendar: calendar)
        XCTAssertEqual(quest.build(ctx).progress, 1)
    }

    func testCookHomeQuestAdaptsToTakeoutHeavyUsers() {
        let week = engine.weekStart(for: date())
        let takeout = (1...6).map { LogRecord(date: date(day: -$0), source: .takeout) }
        let quest = Quests.all.first { $0.id == "cookHome" }!
        let ctx = QuestContext(weekStart: week, weekRecords: [], prior: takeout, calendar: calendar)
        XCTAssertEqual(quest.build(ctx).target, 1)
    }

    // MARK: Events

    func testEventsAfterFirstCuisine() {
        let before = engine.state(for: [], now: date())
        let after = engine.state(for: [LogRecord(date: date(), title: "Injera", cuisines: [.ethiopian])], now: date())
        let events = engine.events(from: before, to: after)
        XCTAssertTrue(events.contains(.newStamp(.ethiopian, collected: 1)))
        XCTAssertTrue(events.contains(.badge("firstBite")))
        XCTAssertTrue(events.contains { if case .levelUp = $0 { return true } else { return false } })
    }

    func testWeekDots() {
        let records = [LogRecord(date: date()), LogRecord(date: date(day: 2))]
        XCTAssertEqual(engine.daysLogged(inWeekOf: date(day: 4), records: records),
                       [true, false, true, false, false, false, false])
    }

    // MARK: Catalog

    func testMealSuggestion() {
        XCTAssertEqual(MealType.suggested(for: date(hour: 8), calendar: calendar), .breakfast)
        XCTAssertEqual(MealType.suggested(for: date(hour: 12), calendar: calendar), .lunch)
        XCTAssertEqual(MealType.suggested(for: date(hour: 19), calendar: calendar), .dinner)
        XCTAssertEqual(MealType.suggested(for: date(hour: 23), calendar: calendar), .lateNight)
    }

    func testEveryPassportRegionHasCuisines() {
        for region in Region.passportRegions {
            XCTAssertFalse(region.cuisines.isEmpty, region.name)
        }
        XCTAssertEqual(Cuisine.collectible.count, Cuisine.allCases.count - 1)
    }
}
