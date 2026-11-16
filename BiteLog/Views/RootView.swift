import SwiftUI

struct RootView: View {
    @Environment(AppModel.self) private var app
    @AppStorage("hasOnboarded") private var hasOnboarded = false

    var body: some View {
        TabView {
            TodayView()
                .tabItem { Label("Today", systemImage: "fork.knife") }
            PassportView()
                .tabItem { Label("Passport", systemImage: "globe.americas.fill") }
            HistoryView()
                .tabItem { Label("History", systemImage: "calendar") }
            ProfileView()
                .tabItem { Label("Progress", systemImage: "star.circle.fill") }
        }
        .overlay(alignment: .bottom) {
            if let amount = app.xpToast {
                XPToast(amount: amount)
                    .padding(.bottom, 100)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .task(id: amount) {
                        try? await Task.sleep(for: .seconds(1.6))
                        withAnimation { app.xpToast = nil }
                    }
            }
        }
        .animation(.spring, value: app.xpToast)
        .sheet(isPresented: Binding(
            get: { !app.pendingRewards.isEmpty },
            set: { if !$0 { app.pendingRewards = [] } }
        )) {
            RewardSheet(events: app.pendingRewards)
        }
        .fullScreenCover(isPresented: Binding(
            get: { !hasOnboarded },
            set: { hasOnboarded = !$0 }
        )) {
            OnboardingView { hasOnboarded = true }
        }
    }
}
