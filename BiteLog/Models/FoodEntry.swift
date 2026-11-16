import Foundation
import SwiftData

/// One logged meal / drink. Every stored property has a default so the model
/// stays compatible with CloudKit sync if we turn it on later.
@Model
final class FoodEntry {
    var id: UUID = UUID()
    var date: Date = Date()
    var title: String = ""
    @Attribute(.externalStorage) var photoData: Data?
    @Attribute(.externalStorage) var thumbnailData: Data?
    var hasPhoto: Bool = false
    var sourceRaw: String?
    var cuisineRaws: [String] = []
    var foodTypeRaws: [String] = []
    var mealRaw: String = MealType.lunch.rawValue
    var ratingRaw: String?
    var companionsRaw: String?
    var placeName: String = ""
    var note: String = ""

    init(date: Date = Date(), title: String = "", meal: MealType? = nil) {
        self.date = date
        self.title = title
        self.mealRaw = (meal ?? MealType.suggested(for: date)).rawValue
    }

    // MARK: Typed accessors

    var source: FoodSource? {
        get { sourceRaw.flatMap(FoodSource.init(rawValue:)) }
        set { sourceRaw = newValue?.rawValue }
    }

    var cuisines: [Cuisine] {
        get { cuisineRaws.compactMap(Cuisine.init(rawValue:)) }
        set { cuisineRaws = newValue.map(\.rawValue) }
    }

    var foodTypes: Set<FoodType> {
        get { Set(foodTypeRaws.compactMap(FoodType.init(rawValue:))) }
        set { foodTypeRaws = FoodType.allCases.filter { newValue.contains($0) }.map(\.rawValue) }
    }

    var meal: MealType {
        get { MealType(rawValue: mealRaw) ?? .lunch }
        set { mealRaw = newValue.rawValue }
    }

    var rating: Rating? {
        get { ratingRaw.flatMap(Rating.init(rawValue:)) }
        set { ratingRaw = newValue?.rawValue }
    }

    var companions: Companions? {
        get { companionsRaw.flatMap(Companions.init(rawValue:)) }
        set { companionsRaw = newValue?.rawValue }
    }

    var displayTitle: String {
        if !title.isEmpty { return title }
        if let c = cuisines.first { return "\(c.name) \(meal.label.lowercased())" }
        return meal.label
    }

    /// Emoji used when there's no photo.
    var placeholderEmoji: String { cuisines.first?.emoji ?? meal.emoji }

    func setPhoto(_ data: Data?) {
        photoData = data
        thumbnailData = data.flatMap { ImageProcessing.jpeg(from: $0, maxDimension: 400, quality: 0.7) }
        hasPhoto = data != nil
    }

    /// Copy the tags of another entry ("Again" button). Photo is not copied.
    func copyTags(from other: FoodEntry) {
        title = other.title
        sourceRaw = other.sourceRaw
        cuisineRaws = other.cuisineRaws
        foodTypeRaws = other.foodTypeRaws
        placeName = other.placeName
    }

    var record: LogRecord {
        LogRecord(id: id, date: date, title: title, hasPhoto: hasPhoto, source: source,
                  cuisines: cuisines, foodTypes: foodTypes, meal: meal, rating: rating, placeName: placeName)
    }
}
