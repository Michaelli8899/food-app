import Foundation

// MARK: - Where the food came from

enum FoodSource: String, CaseIterable, Identifiable, Codable {
    case home, restaurant, takeout, packaged, cookedForMe, event

    var id: String { rawValue }

    var label: String {
        switch self {
        case .home: "Home-cooked"
        case .restaurant: "Restaurant"
        case .takeout: "Takeout"
        case .packaged: "Store-bought"
        case .cookedForMe: "Cooked for me"
        case .event: "Party / Event"
        }
    }

    var emoji: String {
        switch self {
        case .home: "🏠"
        case .restaurant: "🍽️"
        case .takeout: "🥡"
        case .packaged: "🛒"
        case .cookedForMe: "👵"
        case .event: "🎉"
        }
    }
}

// MARK: - Meal

enum MealType: String, CaseIterable, Identifiable, Codable {
    case breakfast, brunch, lunch, snack, dinner, lateNight, drink

    var id: String { rawValue }

    var label: String {
        switch self {
        case .breakfast: "Breakfast"
        case .brunch: "Brunch"
        case .lunch: "Lunch"
        case .snack: "Snack"
        case .dinner: "Dinner"
        case .lateNight: "Late-night"
        case .drink: "Drink"
        }
    }

    var emoji: String {
        switch self {
        case .breakfast: "🍳"
        case .brunch: "🥞"
        case .lunch: "🥪"
        case .snack: "🍿"
        case .dinner: "🍝"
        case .lateNight: "🌙"
        case .drink: "🧋"
        }
    }

    /// Best guess for the meal based on the time of day.
    static func suggested(for date: Date, calendar: Calendar = .current) -> MealType {
        switch calendar.component(.hour, from: date) {
        case 5..<10: .breakfast
        case 10..<11: .brunch
        case 11..<15: .lunch
        case 15..<17: .snack
        case 17..<22: .dinner
        default: .lateNight
        }
    }
}

// MARK: - Food types

enum FoodType: String, CaseIterable, Identifiable, Codable {
    case veg, fruit, grains, legumes, meat, seafood, eggs, dairy, plantBased, sweets, drink, spicy

    var id: String { rawValue }

    var label: String {
        switch self {
        case .veg: "Veggies"
        case .fruit: "Fruit"
        case .grains: "Grains"
        case .legumes: "Beans & Legumes"
        case .meat: "Meat"
        case .seafood: "Seafood"
        case .eggs: "Eggs"
        case .dairy: "Dairy"
        case .plantBased: "Plant-based"
        case .sweets: "Sweets"
        case .drink: "Drink"
        case .spicy: "Spicy"
        }
    }

    var emoji: String {
        switch self {
        case .veg: "🥦"
        case .fruit: "🍎"
        case .grains: "🌾"
        case .legumes: "🫘"
        case .meat: "🥩"
        case .seafood: "🐟"
        case .eggs: "🥚"
        case .dairy: "🧀"
        case .plantBased: "🌱"
        case .sweets: "🍰"
        case .drink: "☕"
        case .spicy: "🌶️"
        }
    }

    /// Plant food groups used by the "plant mix" quest.
    static let plantGroups: [FoodType] = [.veg, .fruit, .grains, .legumes]
}

// MARK: - Rating & companions

enum Rating: String, CaseIterable, Identifiable, Codable {
    case no, meh, yes, love

    var id: String { rawValue }

    var label: String {
        switch self {
        case .no: "Not again"
        case .meh: "Meh"
        case .yes: "Good"
        case .love: "Loved it"
        }
    }

    var emoji: String {
        switch self {
        case .no: "👎"
        case .meh: "😐"
        case .yes: "👍"
        case .love: "🤩"
        }
    }
}

enum Companions: String, CaseIterable, Identifiable, Codable {
    case solo, friends, family, date, work

    var id: String { rawValue }

    var label: String {
        switch self {
        case .solo: "Solo"
        case .friends: "Friends"
        case .family: "Family"
        case .date: "Date"
        case .work: "Work"
        }
    }

    var emoji: String {
        switch self {
        case .solo: "🙋"
        case .friends: "👯"
        case .family: "👨‍👩‍👧"
        case .date: "💞"
        case .work: "💼"
        }
    }
}

// MARK: - Cuisines & regions

enum Region: String, CaseIterable, Identifiable {
    case eastAsia, southeastAsia, southAsia, middleEast, africa, europe, northAmerica, latinAmerica, global

    var id: String { rawValue }

    var name: String {
        switch self {
        case .eastAsia: "East Asia"
        case .southeastAsia: "Southeast Asia"
        case .southAsia: "South Asia"
        case .middleEast: "Middle East & North Africa"
        case .africa: "Sub-Saharan Africa"
        case .europe: "Europe"
        case .northAmerica: "North America"
        case .latinAmerica: "Latin America & Caribbean"
        case .global: "Global"
        }
    }

    var emoji: String {
        switch self {
        case .eastAsia: "🏯"
        case .southeastAsia: "🌴"
        case .southAsia: "🪷"
        case .middleEast: "🕌"
        case .africa: "🌍"
        case .europe: "🏰"
        case .northAmerica: "🗽"
        case .latinAmerica: "🌮"
        case .global: "🌐"
        }
    }

    /// Regions that appear in the passport (everything except "global").
    static var passportRegions: [Region] { allCases.filter { $0 != .global } }

    var cuisines: [Cuisine] { Cuisine.allCases.filter { $0.region == self } }
}

enum Cuisine: String, CaseIterable, Identifiable, Codable {
    // East Asia
    case japanese, chinese, korean, taiwanese
    // Southeast Asia
    case thai, vietnamese, filipino, malaysian, indonesian, singaporean
    // South Asia
    case indian, pakistani, nepali, sriLankan
    // Middle East & North Africa
    case lebanese, turkish, persian, israeli, moroccan, egyptian
    // Sub-Saharan Africa
    case ethiopian, nigerian, southAfrican
    // Europe
    case italian, french, spanish, greek, german, british, portuguese, polish, scandinavian
    // North America
    case american, southern, cajun, hawaiian
    // Latin America & Caribbean
    case mexican, peruvian, brazilian, argentinian, colombian, caribbean, cuban
    // Not collectible
    case fusion

    var id: String { rawValue }

    private var info: (name: String, emoji: String, region: Region) {
        switch self {
        case .japanese: ("Japanese", "🇯🇵", .eastAsia)
        case .chinese: ("Chinese", "🇨🇳", .eastAsia)
        case .korean: ("Korean", "🇰🇷", .eastAsia)
        case .taiwanese: ("Taiwanese", "🇹🇼", .eastAsia)
        case .thai: ("Thai", "🇹🇭", .southeastAsia)
        case .vietnamese: ("Vietnamese", "🇻🇳", .southeastAsia)
        case .filipino: ("Filipino", "🇵🇭", .southeastAsia)
        case .malaysian: ("Malaysian", "🇲🇾", .southeastAsia)
        case .indonesian: ("Indonesian", "🇮🇩", .southeastAsia)
        case .singaporean: ("Singaporean", "🇸🇬", .southeastAsia)
        case .indian: ("Indian", "🇮🇳", .southAsia)
        case .pakistani: ("Pakistani", "🇵🇰", .southAsia)
        case .nepali: ("Nepali", "🇳🇵", .southAsia)
        case .sriLankan: ("Sri Lankan", "🇱🇰", .southAsia)
        case .lebanese: ("Lebanese", "🇱🇧", .middleEast)
        case .turkish: ("Turkish", "🇹🇷", .middleEast)
        case .persian: ("Persian", "🇮🇷", .middleEast)
        case .israeli: ("Israeli", "🇮🇱", .middleEast)
        case .moroccan: ("Moroccan", "🇲🇦", .middleEast)
        case .egyptian: ("Egyptian", "🇪🇬", .middleEast)
        case .ethiopian: ("Ethiopian", "🇪🇹", .africa)
        case .nigerian: ("Nigerian", "🇳🇬", .africa)
        case .southAfrican: ("South African", "🇿🇦", .africa)
        case .italian: ("Italian", "🇮🇹", .europe)
        case .french: ("French", "🇫🇷", .europe)
        case .spanish: ("Spanish", "🇪🇸", .europe)
        case .greek: ("Greek", "🇬🇷", .europe)
        case .german: ("German", "🇩🇪", .europe)
        case .british: ("British", "🇬🇧", .europe)
        case .portuguese: ("Portuguese", "🇵🇹", .europe)
        case .polish: ("Polish", "🇵🇱", .europe)
        case .scandinavian: ("Scandinavian", "🇸🇪", .europe)
        case .american: ("American", "🇺🇸", .northAmerica)
        case .southern: ("Southern / Soul", "🍗", .northAmerica)
        case .cajun: ("Cajun & Creole", "🦐", .northAmerica)
        case .hawaiian: ("Hawaiian", "🌺", .northAmerica)
        case .mexican: ("Mexican", "🇲🇽", .latinAmerica)
        case .peruvian: ("Peruvian", "🇵🇪", .latinAmerica)
        case .brazilian: ("Brazilian", "🇧🇷", .latinAmerica)
        case .argentinian: ("Argentinian", "🇦🇷", .latinAmerica)
        case .colombian: ("Colombian", "🇨🇴", .latinAmerica)
        case .caribbean: ("Caribbean", "🏝️", .latinAmerica)
        case .cuban: ("Cuban", "🇨🇺", .latinAmerica)
        case .fusion: ("Fusion", "🌐", .global)
        }
    }

    var name: String { info.name }
    var emoji: String { info.emoji }
    var region: Region { info.region }

    /// Whether this cuisine earns a passport stamp.
    var isCollectible: Bool { region != .global }

    static var collectible: [Cuisine] { allCases.filter(\.isCollectible) }

    /// Shown in the add-entry sheet before the user has any history.
    static let popularDefaults: [Cuisine] = [.italian, .japanese, .mexican, .chinese, .indian, .american, .thai, .korean]
}
