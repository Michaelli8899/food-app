# Food Diary App: Feature Design (v2)

> Builds on [01-user-research.md](./01-user-research.md). Gamification details are in [03-gamification.md](./03-gamification.md).
> Working name: **"Bite Log"** (placeholder). Other ideas: *Plate Passport*, *Forkcast*, *Munch Map*, *Dishcovery*.

## Decision log

| Date | Decision |
|---|---|
| 2026-11-16 | **Public app on the iPhone App Store** (not a personal tool) |
| 2026-11-16 | **No calorie counting.** The app is about variety, discovery and fun |
| 2026-11-16 | Track **food types, cuisines, and where the food came from** (home-cooked / restaurant / takeout…) |
| 2026-11-16 | **Gamification** is a core pillar, not an add-on |
| 2026-11-16 | **SwiftUI + SwiftData**, iOS 17+, project generated with XcodeGen. Local storage first; iCloud (CloudKit) sync once a paid developer account is set up |
| 2026-11-16 | v0.1 uses a free-text place field. MapKit place search and the Food Map move to v1.1 |

---

## 1. Product vision

**A food journal that feels like a game of exploration, not a diet.**

Snap what you eat, tag where it came from and what cuisine it is, and watch your *Food Passport* fill up. You collect cuisines, level up as a home cook, take on weekly quests, and get a "Wrapped"-style recap of your year in food.

**Positioning:** *"Untappd / Beli / Spotify Wrapped, for everything you eat."* It is the opposite of a calorie tracker. There are no numbers to hit and no "bad" foods.

### Design principles
1. **Capture first, details later.** A photo alone is a valid entry.
2. **Details are rewarded, never required.** Adding cuisine or food types earns stamps and XP. Gamification pays for completeness instead of nagging for it.
3. **Celebrate variety and curiosity**, not restriction.
4. **No punishment.** Missing a day costs nothing. There are no red numbers and no streak resets that wipe progress.
5. **Shareable by design.** Recap cards and passport stamps look good on Instagram Stories. That is how a public app grows.
6. **Private by default.** Entries are private unless the user shares a card.

### Who it's for (updated personas)
- **Primary, "Foodie Explorer Ellie"**: eats out, likes trying new places and cuisines, already photographs food. *Wants:* a memory of what she ate and where, plus bragging rights.
- **Primary, "Curious Casey"**: wants to know their eating habits (how much takeout? how often do I cook?) without counting calories.
- **Secondary, "Home Cook Hana"**: learning to cook. *Wants:* to see progress and keep cooking more.
- **Later module, "Symptom Sam"**: symptom tracking moves to a later optional module. It doesn't fit the fun tone of the core app, and health claims make App Store review harder.

---

## 2. What a log entry captures

Speed is protected by keeping only **photo or name** needed to save. Everything else is one-tap chips, and many fields can be filled in automatically.

| Field | Values | How it's filled fast |
|---|---|---|
| Photo | Camera / library | One tap from home screen |
| Dish name | Free text ("Tonkotsu ramen") | Autocomplete from your history |
| **Source** | 🏠 Home-cooked · 🍽️ Restaurant · 🥡 Takeout/Delivery · 🛒 Packaged/Store-bought · 👵 Someone cooked for me · 🎉 Event/Party | Big chips. Remembers your pattern by time of day |
| **Cuisine** | ~40 cuisines: Japanese, Mexican, Italian, Ethiopian, Korean, Thai, Indian, Lebanese, Peruvian, American, Fusion… | Auto-filled from restaurant category. Recent cuisines shown first |
| **Food types** (multi) | 🥦 Veg · 🍎 Fruit · 🌾 Grains · 🫘 Legumes · 🥩 Meat · 🐟 Seafood · 🥚 Eggs · 🧀 Dairy · 🌱 Plant-based · 🍰 Sweets · ☕ Drink · 🌶️ Spicy | Chips. Later: suggested from photo using on-device ML |
| Meal | Breakfast · Brunch · Lunch · Dinner · Snack · Late-night · Drink | Auto by time |
| Place | Restaurant / café | Apple MapKit place search, auto-suggested by location |
| Rating | 👎 · 😐 · 👍 · 🤩 ("would eat again?") | One tap |
| With | Solo · Friends · Family · Date · Work | Optional chip |
| First time? | Auto-detected for new dish/cuisine/place | Triggers a "New discovery!" moment |
| Price | Optional $ amount | Off by default (setting) |
| Note | Free text | Optional |

**Target:** photo-only log ≤ 3 seconds. Fully tagged log ≤ 15 seconds.

---

## 3. Feature list and priorities

### Must have (MVP)
| Feature | Notes |
|---|---|
| Photo + text logging | Core capture |
| Source, cuisine, food types, meal, rating chips | The new tracking axes |
| Restaurant search (MapKit) | Auto-fills cuisine. Powers the map |
| Timeline / History (Today + scrollback) | Basic diary |
| "Again" quick re-log | Speed |
| **Food Passport**: cuisines collected | #1 gamification hook (see 03) |
| **XP + levels** and ~20 starter **badges** | Progress feeling |
| **Weekly quests** (3 per week) | Reason to come back |
| Weekly stats card: home vs. out, cuisines, variety | First payoff |
| Local storage + iCloud sync (CloudKit) | Private, free, no login needed |
| Share card (export image of a stamp/badge/weekly recap) | Growth |

### Should have (v1.1)
| Feature | Notes |
|---|---|
| **Food Map**: pins of every place you've eaten | Very satisfying for Ellie |
| Personal rankings ("My top ramen") | Beli-style. Fun, and a reason to rate |
| Monthly recap + **"Bite Wrapped"** year in review | Big viral moment each December |
| **Eat the Rainbow / 30 Plants a Week** challenge | Healthy without calories |
| Home-cook skill tree (cook X cuisines at home) | Hana |
| Home-screen widget (log + weekly progress) | Retention, iOS-native delight |
| Smart reminders | Retention |

### Could have (v2+)
- On-device photo → dish / food type suggestions (Apple Vision / Core ML)
- Friends: follow, compare passports, co-op quests (opt-in)
- Takeout spending insights ("you saved ~$X cooking at home")
- Recipe saving for home-cooked dishes
- Symptom / mood module
- Seasonal events ("Taco Tuesday month", "Lunar New Year dumpling quest")
- Apple Watch quick log, Live Activities

### Won't have
- Calorie / macro counting, weight tracking
- Public leaderboards ranking *how much* someone eats
- Diet plans or health claims

---

## 4. MVP screens

1. **Today (home)**: today's entries as photo cards, big **+** button, "Again" chips, this week's quest progress bar
2. **Add entry** (bottom sheet): photo → source chips → cuisine chips → food type chips → rating → Save. All but photo/name are optional, and each filled field shows "+XP"
3. **Discovery moment** (overlay): "🎉 New cuisine unlocked: Ethiopian! Stamp #12" with a share button
4. **Passport**: stamp grid of cuisines (collected = colourful stamp with date and dish, uncollected = silhouette), plus a counter "12 / 40"
5. **Profile / Progress**: level, XP bar, badges, quests, weekly stats
6. **History**: calendar with photo thumbnails, search, filters (cuisine, source, place)
7. **Entry detail**: view / edit / delete
8. **Onboarding** (3 screens): what it is, "no calories, ever", pick favourite cuisines (pre-stamps 0 but personalizes quests), notification permission
9. **Settings**: iCloud sync, reminders, price tracking toggle, export CSV, delete all data

### Core loop
```
Eat → Snap (3 s) → Tag (optional, +XP) → Reward (XP / stamp / quest progress)
   → Weekly recap & new quests (Monday) → Share card → friends download → …
```

---

## 5. Data model (draft)

```text
Entry
  id, timestamp, mealType
  title?, photo?, note?
  source        enum (home, restaurant, takeout, packaged, cookedForMe, event)
  cuisineIds    [Cuisine]          (usually 1; fusion can have 2)
  foodTypes     [FoodType]
  placeId?      → Place
  rating        enum? (no, meh, yes, love)
  companions    enum?
  price?        decimal
  isFirstDish / isFirstCuisine / isFirstPlace   (computed at save)

Place        id, name, mapKitId, lat/lng, category, defaultCuisineId
Cuisine      id, name, region, flag/emoji, stampArt     (static catalog)
FoodType     id, name, emoji, isPlant                    (static catalog)

Progress     xp, level
Badge        id, unlockedAt?                             (definitions in code)
Quest        id, weekOf, definitionId, progress, target, completedAt?
```

---

## 6. Tech approach (iPhone-only)

| Option | Pros | Cons |
|---|---|---|
| **SwiftUI + SwiftData + CloudKit** ⭐ | Best iOS feel, widgets, MapKit, on-device Vision ML, free iCloud sync with no backend or login, Sign in with Apple not needed | **Requires a Mac with Xcode** to build. Swift learning curve |
| React Native + Expo | JavaScript/TypeScript, can build iOS in the cloud (EAS) **without a Mac**, test on your iPhone via Expo Go, Android later for free | Widgets and some native features need extra work. Sync needs a backend (e.g. Supabase) |

**Recommendation:** SwiftUI if you have a Mac, because it fits an iPhone-only, private, widget-heavy app best. Expo if you don't.

**App Store requirements:** Apple Developer Program ($99/yr), privacy policy URL, App Privacy "nutrition label", screenshots, and no medical claims.

---

## 7. Monetization (open, decide before launch)

Research showed paywalled basics are a top complaint. Proposal:
- **Free:** all logging, passport, badges, quests, weekly recap.
- **Optional "Bite+"** (~$2–3/mo or ~$20/yr): Wrapped extras, custom stamp themes and app icons, advanced stats and filters, unlimited personal rankings, early seasonal events.
- No ads in the MVP.

---

## 8. Success metrics

| Metric | MVP beta target |
|---|---|
| Time to log (photo only) | ≤ 3 s |
| Entries per active day | ≥ 2 |
| % entries with cuisine + source tagged | ≥ 60% (shows the reward loop works) |
| Day-7 / Day-30 retention | ≥ 40% / ≥ 20% |
| Weekly quest completion | ≥ 30% of active users |
| Share-card exports per weekly active user | Track. This is the growth signal |

---

## 9. Roadmap

| Phase | Contents |
|---|---|
| **0. Validate** (1–2 wks) | Log your own meals for a week with the new tags. Run interviews with the updated guide (01 §8). Test paper sketches of the Passport and quest screens |
| **1. MVP** (5–8 wks) | §4 screens, starter badges and quests, iCloud sync. TestFlight beta with 10–30 people |
| **1.1** | Food Map, rankings, monthly recap, widget, rainbow / 30-plants challenge |
| **Launch** | App Store release, ideally a few weeks **before December** to ride "Wrapped" season |
| **2** | Photo ML suggestions, friends and co-op quests, seasonal events, Bite+ |
