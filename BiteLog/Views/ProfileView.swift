import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(AppModel.self) private var app
    @Query private var entries: [FoodEntry]
    @State private var showSettings = false

    var body: some View {
        let state = app.state(for: entries)

        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    levelCard(state.level, xp: state.xp)
                    questsSection(state)
                    statsGrid(state.stats)
                    badgesSection(state)
                }
                .padding()
            }
            .navigationTitle("Progress")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showSettings = true } label: { Image(systemName: "gearshape") }
                }
            }
            .sheet(isPresented: $showSettings) { SettingsView() }
        }
    }

    private func levelCard(_ level: LevelInfo, xp: Int) -> some View {
        Card {
            VStack(alignment: .leading, spacing: 10) {
                Text("LEVEL \(level.level)").font(.caption.bold()).foregroundStyle(Color.accentColor)
                Text(level.title).font(.title.bold())
                ProgressView(value: level.progress)
                HStack {
                    Text("\(level.xpIntoLevel) / \(level.xpNeeded) XP to next level")
                    Spacer()
                    Text("\(xp) XP total")
                }
                .font(.caption.monospacedDigit())
                .foregroundStyle(.secondary)
            }
        }
    }

    private func questsSection(_ state: GameState) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Weekly quests").font(.title3.bold())
                Spacer()
                if app.canShuffleQuests(state: state) {
                    Button {
                        withAnimation { app.shuffleQuests() }
                    } label: {
                        Label("Shuffle", systemImage: "shuffle")
                    }
                    .font(.subheadline)
                }
            }
            Text("New quests every Monday · +\(XPRules.questComplete) XP each")
                .font(.caption)
                .foregroundStyle(.secondary)
            ForEach(state.currentQuests) { quest in
                Card {
                    HStack(spacing: 12) {
                        Text(quest.emoji).font(.title)
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(quest.difficulty.label.uppercased())
                                    .font(.caption2.bold())
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text("\(quest.clampedProgress)/\(quest.target)")
                                    .font(.caption.monospacedDigit())
                            }
                            Text(quest.title)
                                .font(.subheadline.weight(.semibold))
                                .strikethrough(quest.isComplete)
                            ProgressView(value: Double(quest.clampedProgress), total: Double(quest.target))
                                .tint(quest.isComplete ? .green : .accentColor)
                        }
                    }
                }
            }
        }
    }

    private func statsGrid(_ stats: LifetimeStats) -> some View {
        let homeShare = stats.entries == 0 ? 0 : Int((Double(stats.homeCooked) / Double(stats.entries) * 100).rounded())
        let tiles: [(String, String, String)] = [
            ("🍽️", "\(stats.entries)", "Bites logged"),
            ("🌍", "\(stats.cuisines.count)", "Cuisines"),
            ("📍", "\(stats.distinctPlaces)", "Places"),
            ("🏠", "\(homeShare)%", "Home-cooked"),
        ]
        return VStack(alignment: .leading, spacing: 12) {
            Text("Lifetime").font(.title3.bold())
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(tiles.indices, id: \.self) { i in
                    let tile = tiles[i]
                    Card {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(tile.0).font(.title2)
                            Text(tile.1).font(.title.bold()).monospacedDigit()
                            Text(tile.2).font(.caption).foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
    }

    private func badgesSection(_ state: GameState) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Badges").font(.title3.bold())
                Spacer()
                Text("\(state.badgesUnlocked.count)/\(Badges.all.count)")
                    .font(.subheadline.monospacedDigit())
                    .foregroundStyle(.secondary)
            }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 96), spacing: 12)], spacing: 12) {
                ForEach(Badges.all) { badge in
                    let unlocked = state.badgesUnlocked[badge.id]
                    VStack(spacing: 6) {
                        Text(unlocked == nil && badge.hidden ? "❓" : badge.emoji)
                            .font(.system(size: 36))
                            .grayscale(unlocked == nil ? 1 : 0)
                            .opacity(unlocked == nil ? 0.4 : 1)
                        Text(unlocked == nil && badge.hidden ? "Secret" : badge.name)
                            .font(.caption.weight(.semibold))
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                        Text(unlocked == nil && badge.hidden ? "Keep exploring…" : badge.detail)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity, minHeight: 130)
                    .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
            }
        }
    }
}
