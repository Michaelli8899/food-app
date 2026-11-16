import SwiftUI

struct OnboardingView: View {
    var onFinish: () -> Void
    @State private var page = 0

    private let pages: [(emoji: String, title: String, body: String)] = [
        ("📸", "Snap every bite", "Log a meal in seconds with just a photo. Add details whenever you like."),
        ("🛂", "Fill your Food Passport", "Collect a stamp for every cuisine you try, at home, out, or on the couch with takeout."),
        ("🎯", "Quests, badges & levels", "Weekly quests and badges reward curiosity and cooking. No calories. Ever."),
    ]

    var body: some View {
        VStack {
            TabView(selection: $page) {
                ForEach(pages.indices, id: \.self) { i in
                    VStack(spacing: 20) {
                        Spacer()
                        Text(pages[i].emoji).font(.system(size: 110))
                        Text(pages[i].title).font(.largeTitle.bold()).multilineTextAlignment(.center)
                        Text(pages[i].body)
                            .font(.title3)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                        Spacer()
                    }
                    .tag(i)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))

            Button {
                if page < pages.count - 1 {
                    withAnimation { page += 1 }
                } else {
                    onFinish()
                }
            } label: {
                Text(page < pages.count - 1 ? "Next" : "Let's eat")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
    }
}
