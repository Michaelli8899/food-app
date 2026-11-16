import SwiftUI
import SwiftData

struct PassportView: View {
    @Environment(AppModel.self) private var app
    @Query private var entries: [FoodEntry]
    @State private var selected: Cuisine?

    var body: some View {
        let state = app.state(for: entries)

        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    header(state: state)

                    ForEach(Region.passportRegions) { region in
                        let collected = region.cuisines.filter { state.stamps[$0] != nil }.count
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("\(region.emoji) \(region.name)").font(.headline)
                                Spacer()
                                Text("\(collected)/\(region.cuisines.count)")
                                    .font(.subheadline.monospacedDigit())
                                    .foregroundStyle(collected == region.cuisines.count ? Color.accentColor : .secondary)
                            }
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 12)], spacing: 12) {
                                ForEach(region.cuisines) { cuisine in
                                    StampView(cuisine: cuisine, stamp: state.stamps[cuisine])
                                        .onTapGesture { selected = cuisine }
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Food Passport")
            .sheet(item: $selected) { cuisine in
                StampDetailView(cuisine: cuisine, stamp: state.stamps[cuisine])
            }
        }
    }

    private func header(state: GameState) -> some View {
        let total = Cuisine.collectible.count
        let count = state.stamps.count
        return Card {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .firstTextBaseline) {
                    Text("\(count)")
                        .font(.system(size: 44, weight: .bold, design: .rounded))
                    Text("of \(total) cuisines collected").foregroundStyle(.secondary)
                }
                ProgressView(value: Double(count), total: Double(total))
                Text(count == 0
                     ? "Log a meal with a cuisine to earn your first stamp."
                     : "\(state.stats.regions.count) of \(Region.passportRegions.count) regions explored")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

// MARK: - Stamp

extension StampTier {
    var color: Color {
        switch self {
        case .bronze: Color(red: 0.80, green: 0.50, blue: 0.20)
        case .silver: Color(red: 0.62, green: 0.65, blue: 0.70)
        case .gold: Color(red: 0.95, green: 0.75, blue: 0.10)
        }
    }
}

struct StampView: View {
    let cuisine: Cuisine
    let stamp: CuisineStamp?
    var size: CGFloat = 100

    var body: some View {
        VStack(spacing: 4) {
            Text(cuisine.emoji)
                .font(.system(size: size * 0.36))
                .grayscale(stamp == nil ? 1 : 0)
                .opacity(stamp == nil ? 0.35 : 1)
            Text(cuisine.name)
                .font(.caption.weight(.semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .foregroundStyle(stamp == nil ? Color.secondary : Color.primary)
            if let stamp {
                Text(stamp.firstDate.formatted(.dateTime.month(.abbreviated).day().year(.twoDigits)))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            } else {
                Text("?").font(.caption2).foregroundStyle(.tertiary)
            }
        }
        .padding(8)
        .frame(width: size, height: size)
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(stamp == nil ? Color(.secondarySystemBackground) : (stamp?.tier.color ?? .clear).opacity(0.15))
        }
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(
                    stamp?.tier.color ?? Color(.tertiaryLabel),
                    style: StrokeStyle(lineWidth: stamp == nil ? 1 : 2.5, dash: stamp == nil ? [4, 4] : [])
                )
        }
        .rotationEffect(.degrees(stamp == nil ? 0 : Double(cuisine.name.count % 7) - 3))
        .accessibilityElement(children: .combine)
        .accessibilityLabel(stamp == nil ? "\(cuisine.name), not collected" : "\(cuisine.name), \(stamp!.tier.label) stamp")
    }
}

// MARK: - Stamp detail

struct StampDetailView: View {
    let cuisine: Cuisine
    let stamp: CuisineStamp?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                StampView(cuisine: cuisine, stamp: stamp, size: 160)
                    .padding(.top, 24)

                if let stamp {
                    VStack(spacing: 6) {
                        Text("\(stamp.tier.label) stamp").font(.title2.bold())
                        Text("First tried \(stamp.firstDate.formatted(date: .long, time: .omitted))")
                            .foregroundStyle(.secondary)
                        if !stamp.firstDish.isEmpty {
                            Text("“\(stamp.firstDish)”").italic()
                        }
                    }
                    Card {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("\(stamp.entryCount) meals · \(stamp.dishes.count) different dishes", systemImage: "fork.knife")
                            Label(stamp.cookedAtHome ? "Cooked at home ✓" : "Not cooked at home yet", systemImage: "house")
                            Divider()
                            Text(nextStep(for: stamp)).font(.subheadline).foregroundStyle(.secondary)
                        }
                    }
                    .padding(.horizontal)

                    ShareLink(item: shareImage(stamp: stamp),
                              preview: SharePreview("\(cuisine.name) stamp", image: shareImage(stamp: stamp))) {
                        Label("Share stamp", systemImage: "square.and.arrow.up")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.horizontal)
                } else {
                    VStack(spacing: 8) {
                        Text("Not collected yet").font(.title2.bold())
                        Text("Log any \(cuisine.name) dish to earn this stamp.")
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal)
                }
                Spacer()
            }
            .navigationTitle(cuisine.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) { Button("Done") { dismiss() } }
            }
        }
        .presentationDetents([.large])
    }

    private func nextStep(for stamp: CuisineStamp) -> String {
        switch stamp.tier {
        case .bronze:
            "Try \(StampTier.dishesForSilver) different \(cuisine.name) dishes to reach Silver (\(stamp.dishes.count)/\(StampTier.dishesForSilver))."
        case .silver:
            "Cook a \(cuisine.name) dish at home to reach Gold."
        case .gold:
            "Mastered! You've explored and cooked \(cuisine.name)."
        }
    }

    @MainActor
    private func shareImage(stamp: CuisineStamp) -> Image {
        let card = VStack(spacing: 16) {
            Text("BITE LOG · FOOD PASSPORT").font(.caption.bold()).foregroundStyle(.secondary)
            StampView(cuisine: cuisine, stamp: stamp, size: 220)
            Text("\(cuisine.name) · \(stamp.tier.label)").font(.title.bold())
        }
        .padding(40)
        .background(Color.white)
        .environment(\.colorScheme, .light)

        let renderer = ImageRenderer(content: card)
        renderer.scale = 3
        if let ui = renderer.uiImage { return Image(uiImage: ui) }
        return Image(systemName: "seal")
    }
}
