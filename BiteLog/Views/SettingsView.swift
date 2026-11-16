import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Environment(AppModel.self) private var app
    @Query(sort: \FoodEntry.date) private var entries: [FoodEntry]
    @AppStorage("hasOnboarded") private var hasOnboarded = true
    @State private var confirmDeleteAll = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Label("No calories. Ever.", systemImage: "heart.fill")
                    Text("Bite Log is about curiosity and variety, not counting. Your entries stay on this device.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Section("Your data") {
                    if let url = exportCSV() {
                        ShareLink(item: url) {
                            Label("Export as CSV", systemImage: "square.and.arrow.up")
                        }
                    }
                    Button("Show intro again") {
                        hasOnboarded = false
                        dismiss()
                    }
                    Button("Delete all data", role: .destructive) { confirmDeleteAll = true }
                }

                Section("About") {
                    LabeledContent("Version", value: Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "–")
                    LabeledContent("Bites logged", value: "\(entries.count)")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) { Button("Done") { dismiss() } }
            }
            .confirmationDialog("Delete every entry, stamp and badge? This can't be undone.",
                                isPresented: $confirmDeleteAll, titleVisibility: .visible) {
                Button("Delete everything", role: .destructive) {
                    try? context.delete(model: FoodEntry.self)
                    try? context.save()
                    app.resetAll()
                }
            }
        }
    }

    private func exportCSV() -> URL? {
        func esc(_ s: String) -> String { "\"\(s.replacingOccurrences(of: "\"", with: "\"\""))\"" }
        let iso = ISO8601DateFormatter()
        var lines = ["date,meal,title,source,cuisines,food_types,rating,with,place,note"]
        for e in entries {
            lines.append([
                iso.string(from: e.date),
                e.meal.label,
                esc(e.title),
                e.source?.label ?? "",
                esc(e.cuisines.map(\.name).joined(separator: "; ")),
                esc(FoodType.allCases.filter { e.foodTypes.contains($0) }.map(\.label).joined(separator: "; ")),
                e.rating?.label ?? "",
                e.companions?.label ?? "",
                esc(e.placeName),
                esc(e.note),
            ].joined(separator: ","))
        }
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("bite-log-export.csv")
        do {
            try lines.joined(separator: "\n").write(to: url, atomically: true, encoding: .utf8)
            return url
        } catch {
            return nil
        }
    }
}
