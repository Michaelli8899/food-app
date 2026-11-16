import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \FoodEntry.date, order: .reverse) private var entries: [FoodEntry]
    @State private var search = ""
    @State private var sourceFilter: FoodSource?

    private var filtered: [FoodEntry] {
        entries.filter { e in
            if let sourceFilter, e.source != sourceFilter { return false }
            guard !search.isEmpty else { return true }
            let haystack = ([e.title, e.placeName, e.note] + e.cuisines.map(\.name)).joined(separator: " ")
            return haystack.localizedCaseInsensitiveContains(search)
        }
    }

    private struct DayGroup: Identifiable {
        let day: Date
        let entries: [FoodEntry]
        var id: Date { day }
    }

    private var days: [DayGroup] {
        let grouped = Dictionary(grouping: filtered) { Calendar.current.startOfDay(for: $0.date) }
        return grouped.keys.sorted(by: >).map { DayGroup(day: $0, entries: grouped[$0] ?? []) }
    }

    var body: some View {
        NavigationStack {
            Group {
                if entries.isEmpty {
                    ContentUnavailableView("No bites yet", systemImage: "fork.knife",
                                           description: Text("Everything you log shows up here."))
                } else if filtered.isEmpty {
                    ContentUnavailableView.search(text: search)
                } else {
                    List {
                        ForEach(days) { group in
                            Section(header: Text(dayTitle(group.day))) {
                                ForEach(group.entries) { entry in
                                    NavigationLink(value: entry) { EntryRow(entry: entry) }
                                }
                                .onDelete { offsets in
                                    for i in offsets { context.delete(group.entries[i]) }
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("History")
            .navigationDestination(for: FoodEntry.self) { EntryDetailView(entry: $0) }
            .searchable(text: $search, prompt: "Dish, place, cuisine…")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("Source", selection: $sourceFilter) {
                            Text("All").tag(FoodSource?.none)
                            ForEach(FoodSource.allCases) { s in
                                Text("\(s.emoji) \(s.label)").tag(FoodSource?.some(s))
                            }
                        }
                    } label: {
                        Image(systemName: sourceFilter == nil
                              ? "line.3.horizontal.decrease.circle"
                              : "line.3.horizontal.decrease.circle.fill")
                    }
                }
            }
        }
    }

    private func dayTitle(_ day: Date) -> String {
        let cal = Calendar.current
        if cal.isDateInToday(day) { return "Today" }
        if cal.isDateInYesterday(day) { return "Yesterday" }
        return day.formatted(.dateTime.weekday(.wide).month(.abbreviated).day())
    }
}

// MARK: - Entry detail

struct EntryDetailView: View {
    let entry: FoodEntry
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var editing = false
    @State private var confirmDelete = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let data = entry.photoData, let image = UIImage(data: data) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                } else {
                    EntryThumbnail(entry: entry, size: 120)
                        .frame(maxWidth: .infinity)
                }

                Text(entry.displayTitle).font(.largeTitle.bold())
                Text("\(entry.meal.emoji) \(entry.meal.label) · \(entry.date.formatted(date: .abbreviated, time: .shortened))")
                    .foregroundStyle(.secondary)

                Card {
                    VStack(alignment: .leading, spacing: 10) {
                        if let s = entry.source { detail("From", "\(s.emoji) \(s.label)") }
                        if !entry.placeName.isEmpty { detail("Place", "📍 \(entry.placeName)") }
                        if !entry.cuisines.isEmpty {
                            detail("Cuisine", entry.cuisines.map { "\($0.emoji) \($0.name)" }.joined(separator: ", "))
                        }
                        if !entry.foodTypes.isEmpty {
                            detail("Food types", FoodType.allCases.filter { entry.foodTypes.contains($0) }
                                .map { "\($0.emoji) \($0.label)" }.joined(separator: ", "))
                        }
                        if let r = entry.rating { detail("Verdict", "\(r.emoji) \(r.label)") }
                        if let c = entry.companions { detail("With", "\(c.emoji) \(c.label)") }
                        if entry.source == nil && entry.cuisines.isEmpty && entry.foodTypes.isEmpty && entry.rating == nil {
                            Text("Add tags to earn more XP and stamps.").foregroundStyle(.secondary)
                        }
                    }
                }

                if !entry.note.isEmpty {
                    Text(entry.note)
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button("Edit") { editing = true }
                Menu {
                    Button(role: .destructive) {
                        confirmDelete = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $editing) { AddEntryView(editing: entry) }
        .confirmationDialog("Delete this bite?", isPresented: $confirmDelete, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    context.delete(entry)
                }
            }
        }
    }

    private func detail(_ label: String, _ value: String) -> some View {
        HStack(alignment: .top) {
            Text(label).foregroundStyle(.secondary).frame(width: 90, alignment: .leading)
            Text(value)
        }
        .font(.subheadline)
    }
}
