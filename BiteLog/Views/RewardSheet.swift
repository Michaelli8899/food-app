import SwiftUI

/// The celebration shown after a log unlocks something (stamp, badge, quest, level).
struct RewardSheet: View {
    let events: [RewardEvent]
    @Environment(\.dismiss) private var dismiss
    @State private var appeared = false

    var body: some View {
        VStack(spacing: 20) {
            Text(events.first?.emoji ?? "🎉")
                .font(.system(size: 88))
                .scaleEffect(appeared ? 1 : 0.3)
                .rotationEffect(.degrees(appeared ? 0 : -25))
                .padding(.top, 32)

            Text(headline)
                .font(.title.bold())
                .multilineTextAlignment(.center)

            VStack(spacing: 12) {
                ForEach(events) { event in
                    HStack(spacing: 14) {
                        Text(event.emoji).font(.largeTitle)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(event.title).font(.headline)
                            Text(event.subtitle).font(.subheadline).foregroundStyle(.secondary)
                        }
                        Spacer(minLength: 0)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
            }
            .padding(.horizontal)

            Spacer(minLength: 0)

            Button {
                dismiss()
            } label: {
                Text("Yum, continue").font(.headline).frame(maxWidth: .infinity).padding(.vertical, 6)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
            .padding(.bottom)
        }
        .presentationDetents([.medium, .large])
        .sensoryFeedback(.success, trigger: appeared)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.55)) { appeared = true }
        }
    }

    private var headline: String {
        if events.contains(where: { if case .newStamp = $0 { return true } else { return false } }) {
            return "New discovery!"
        }
        return events.count > 1 ? "Look at you go!" : "Nice bite!"
    }
}
