import SwiftUI
import SwiftData

@main
struct BiteLogApp: App {
    @State private var appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(appModel)
        }
        .modelContainer(for: FoodEntry.self)
    }
}
