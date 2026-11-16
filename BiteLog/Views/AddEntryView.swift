import SwiftUI
import SwiftData
import PhotosUI

/// Create or edit an entry. Only a photo *or* a name is needed to save;
/// every other field is optional and shows the XP it earns.
struct AddEntryView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Environment(AppModel.self) private var app
    @Query(sort: \FoodEntry.date, order: .reverse) private var allEntries: [FoodEntry]

    let editing: FoodEntry?

    @State private var title = ""
    @State private var photoData: Data?
    @State private var pickerItem: PhotosPickerItem?
    @State private var showCamera = false
    @State private var source: FoodSource?
    @State private var cuisines: [Cuisine] = []
    @State private var foodTypes: Set<FoodType> = []
    @State private var meal: MealType = .suggested(for: Date())
    @State private var rating: Rating?
    @State private var companions: Companions?
    @State private var placeName = ""
    @State private var note = ""
    @State private var date = Date()
    @State private var showAllCuisines = false
    @State private var didLoad = false

    init(editing: FoodEntry? = nil) {
        self.editing = editing
    }

    private var canSave: Bool {
        photoData != nil || !title.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    photoSection

                    TextField("What did you eat?", text: $title)
                        .font(.title3.weight(.semibold))
                        .textInputAutocapitalization(.sentences)
                        .padding()
                        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 14, style: .continuous))

                    section("Where's it from?", xp: XPRules.sourceTag) {
                        FlowLayout {
                            ForEach(FoodSource.allCases) { s in
                                Chip(label: "\(s.emoji) \(s.label)", isSelected: source == s) {
                                    source = source == s ? nil : s
                                }
                            }
                        }
                        if source == .home {
                            Text("🏠 Home-cooked bonus: +\(XPRules.homeCookedBonus) XP")
                                .font(.caption).foregroundStyle(.orange)
                        }
                    }

                    section("Cuisine", xp: XPRules.cuisineTag) {
                        FlowLayout {
                            ForEach(quickCuisines) { c in
                                Chip(label: "\(c.emoji) \(c.name)", isSelected: cuisines.contains(c)) {
                                    toggle(c)
                                }
                            }
                            Chip(label: "More…", isSelected: false) { showAllCuisines = true }
                        }
                    }

                    section("Food types", xp: XPRules.foodTypesTag) {
                        FlowLayout {
                            ForEach(FoodType.allCases) { t in
                                Chip(label: "\(t.emoji) \(t.label)", isSelected: foodTypes.contains(t)) {
                                    if foodTypes.contains(t) { foodTypes.remove(t) } else { foodTypes.insert(t) }
                                }
                            }
                        }
                    }

                    section("Would you eat it again?", xp: XPRules.ratingTag) {
                        FlowLayout {
                            ForEach(Rating.allCases) { r in
                                Chip(label: "\(r.emoji) \(r.label)", isSelected: rating == r) {
                                    rating = rating == r ? nil : r
                                }
                            }
                        }
                    }

                    section("Meal") {
                        FlowLayout {
                            ForEach(MealType.allCases) { m in
                                Chip(label: "\(m.emoji) \(m.label)", isSelected: meal == m) { meal = m }
                            }
                        }
                    }

                    section("More details") {
                        VStack(spacing: 12) {
                            TextField("Place (restaurant, café, friend's house…)", text: $placeName)
                                .padding(12)
                                .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                            FlowLayout {
                                ForEach(Companions.allCases) { c in
                                    Chip(label: "\(c.emoji) \(c.label)", isSelected: companions == c) {
                                        companions = companions == c ? nil : c
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            DatePicker("When", selection: $date, in: ...Date())
                            TextField("Notes", text: $note, axis: .vertical)
                                .lineLimit(2...5)
                                .padding(12)
                                .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                        }
                    }
                }
                .padding()
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle(editing == nil ? "New bite" : "Edit bite")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .bold()
                        .disabled(!canSave)
                }
            }
            .onAppear(perform: loadIfEditing)
            .onChange(of: pickerItem) { _, item in
                guard let item else { return }
                Task {
                    if let data = try? await item.loadTransferable(type: Data.self) {
                        photoData = ImageProcessing.jpeg(from: data) ?? data
                    }
                }
            }
            .onChange(of: placeName) { _, newValue in
                // Remember what cuisine a place serves.
                guard cuisines.isEmpty, let key = LogRecord.key(newValue),
                      let match = allEntries.first(where: { LogRecord.key($0.placeName) == key && !$0.cuisines.isEmpty })
                else { return }
                cuisines = match.cuisines
            }
            .fullScreenCover(isPresented: $showCamera) {
                CameraPicker { image in
                    photoData = ImageProcessing.jpeg(from: image)
                }
                .ignoresSafeArea()
            }
            .sheet(isPresented: $showAllCuisines) {
                CuisinePickerView(selection: $cuisines)
            }
        }
    }

    // MARK: Sections

    @ViewBuilder
    private var photoSection: some View {
        if let photoData, let image = UIImage(data: photoData) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(height: 240)
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay(alignment: .topTrailing) {
                    Button {
                        self.photoData = nil
                        pickerItem = nil
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.white, .black.opacity(0.5))
                    }
                    .padding(10)
                }
        } else {
            HStack(spacing: 12) {
                if CameraPicker.isAvailable {
                    Button { showCamera = true } label: {
                        photoButtonLabel("Snap it", systemImage: "camera.fill")
                    }
                }
                PhotosPicker(selection: $pickerItem, matching: .images) {
                    photoButtonLabel("Library", systemImage: "photo.on.rectangle")
                }
            }
            .buttonStyle(.plain)
        }
    }

    private func photoButtonLabel(_ text: String, systemImage: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: systemImage).font(.title)
            Text(text).font(.subheadline.weight(.semibold))
        }
        .frame(maxWidth: .infinity)
        .frame(height: 110)
        .background(Color.accentColor.opacity(0.12), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .foregroundStyle(Color.accentColor)
    }

    private func section<Content: View>(_ title: String, xp: Int? = nil, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title).font(.headline)
                Spacer()
                if let xp {
                    Text("+\(xp) XP").font(.caption.bold()).foregroundStyle(.orange)
                }
            }
            content()
        }
    }

    /// Recently used cuisines first, then popular defaults, plus anything selected.
    private var quickCuisines: [Cuisine] {
        var result: [Cuisine] = []
        for c in cuisines where !result.contains(c) { result.append(c) }
        for entry in allEntries.prefix(60) {
            for c in entry.cuisines where !result.contains(c) { result.append(c) }
            if result.count >= 8 { break }
        }
        for c in Cuisine.popularDefaults where result.count < 8 && !result.contains(c) { result.append(c) }
        return result
    }

    private func toggle(_ c: Cuisine) {
        if let i = cuisines.firstIndex(of: c) { cuisines.remove(at: i) } else { cuisines.append(c) }
    }

    // MARK: Load / save

    private func loadIfEditing() {
        guard !didLoad else { return }
        didLoad = true
        guard let e = editing else { return }
        title = e.title
        photoData = e.photoData
        source = e.source
        cuisines = e.cuisines
        foodTypes = e.foodTypes
        meal = e.meal
        rating = e.rating
        companions = e.companions
        placeName = e.placeName
        note = e.note
        date = e.date
    }

    private func save() {
        app.commit(in: context) {
            let entry = editing ?? FoodEntry(date: date)
            entry.date = date
            entry.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
            if editing == nil || entry.photoData != photoData { entry.setPhoto(photoData) }
            entry.source = source
            entry.cuisines = cuisines
            entry.foodTypes = foodTypes
            entry.meal = meal
            entry.rating = rating
            entry.companions = companions
            entry.placeName = placeName.trimmingCharacters(in: .whitespacesAndNewlines)
            entry.note = note
            if editing == nil { context.insert(entry) }
        }
        dismiss()
    }
}

// MARK: - Full cuisine picker

struct CuisinePickerView: View {
    @Binding var selection: [Cuisine]
    @Environment(\.dismiss) private var dismiss
    @State private var search = ""

    var body: some View {
        NavigationStack {
            List {
                ForEach(Region.allCases) { region in
                    let matches = region.cuisines.filter {
                        search.isEmpty || $0.name.localizedCaseInsensitiveContains(search)
                    }
                    if !matches.isEmpty {
                        Section("\(region.emoji) \(region.name)") {
                            ForEach(matches) { c in
                                Button {
                                    if let i = selection.firstIndex(of: c) { selection.remove(at: i) } else { selection.append(c) }
                                } label: {
                                    HStack {
                                        Text("\(c.emoji)  \(c.name)").foregroundStyle(.primary)
                                        Spacer()
                                        if selection.contains(c) {
                                            Image(systemName: "checkmark").foregroundStyle(Color.accentColor)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .searchable(text: $search, prompt: "Search cuisines")
            .navigationTitle("Cuisines")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
