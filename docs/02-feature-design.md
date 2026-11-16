# Food Diary App: Feature Design

> Builds on [01-user-research.md](./01-user-research.md). Working name: **"Bite Log"** (placeholder).

---

## 1. Product vision

**A food diary that takes 5 seconds to fill in and actually tells you something.**

Log a meal with a photo or a few words, optionally add how you felt, and get gentle, plain-language patterns over time. Numbers are opt-in, and the tone is never judgmental.

### Design principles
1. **Capture first, details later.** Every entry can start as just a photo or a word.
2. **Partial is fine.** Incomplete entries still count. Missing a meal doesn't break anything.
3. **You choose what to track.** Modules (symptoms, mood, macros, water…) are turned on per user.
4. **Insights over dashboards.** Short sentences beat charts nobody reads.
5. **Neutral language.** No "good/bad foods", no red warnings, no "cheat days".
6. **Private by default.** Data stays on the device first. Export anytime, and no social feed.

---

## 2. Feature brainstorm (everything on the table)

### Logging
- 📷 Photo log: one tap opens the camera, and the meal type is auto-tagged by time of day
- ✍️ Quick text log ("oat latte + banana bread")
- 🔁 "Again" button: re-log recent or frequent meals in one tap
- ⭐ Saved meals / recipes
- 🏷️ Tags: home-cooked, takeout, restaurant, snack, location
- 🎙️ Voice log
- 🔎 Barcode scan → packaged food info
- 🤖 AI photo recognition → suggested foods and portion estimates (always editable)
- 💧 Water and drink tracker
- 🕑 Back-fill: log a meal for earlier today or yesterday

### Body and mind (optional modules)
- 😊 Mood before/after (5 emoji scale)
- 🍽️ Hunger and fullness scale (1–5)
- ⚡ Energy level
- 🤢 Symptoms: bloating, pain, headache, reflux, skin, custom, each with severity and time
- 😴 Sleep and 🏃 activity (manual, or from Apple Health / Google Fit)
- 📝 Free-text notes / journal

### Numbers (optional module)
- Calories, protein/carbs/fat
- Daily targets (shown neutrally, as a range rather than a hard limit)
- Micronutrients (later)

### Insights
- 📅 Daily timeline view
- 🗓️ Calendar with a photo grid ("food mosaic")
- 📊 Weekly recap card: meals logged, home vs. out, veggie days, mood trends
- 🔍 Pattern finder: "Bloating was logged after 4 of 6 meals containing dairy, vs. 1 of 14 without"
- 🔎 Search history ("when did I last eat sushi?")

### Habit support
- ⏰ Smart reminders based on your usual meal times; skips if you already logged
- 🌱 Consistency shown as "days logged this week", not a fragile streak
- 🎯 Light goals: "eat breakfast 5x/week", "2 home-cooked dinners"

### Sharing and export
- 📄 PDF/CSV export for a doctor or dietitian (food + symptom timeline)
- 🔗 Read-only share link for a coach (later)
- ☁️ Optional cloud backup / multi-device sync

### Fun / delight
- Restaurant and dish memory ("what was that great ramen place?")
- Monthly "year in food" style recap
- Grocery spend tracking

---

## 3. Prioritization (MoSCoW)

Scored on **user value** (from research) vs. **build effort**.

| Priority | Feature | Why |
|---|---|---|
| **Must (MVP)** | Photo log + quick text log | Core low-friction capture, the #1 reason people quit |
| **Must** | Daily timeline + edit/delete entries | Basic diary function |
| **Must** | Meal type auto-tagging (by time) | Removes a step |
| **Must** | "Again" / recent meals quick re-log | Big speed win, cheap to build |
| **Must** | Optional mood + hunger/fullness on entry | Supports Casey & Mia at near-zero cost |
| **Must** | Symptom log (standalone entries, with severity) | Key differentiator for Sam |
| **Must** | Local storage + CSV export | Privacy and trust |
| **Should (v1.1)** | Weekly recap card | First payoff moment |
| **Should** | Calendar photo grid | Delightful, reinforces habit |
| **Should** | Smart reminders | Retention |
| **Should** | Food → symptom pattern finder (simple counts) | Core insight for Sam |
| **Should** | PDF report for doctor | High value for Sam |
| **Could (v2)** | Barcode scan, calories/macros module | Needed by some users, but crowded space and needs a food database |
| **Could** | AI photo recognition | Impressive, but costly and must stay optional |
| **Could** | Health app integration (sleep/steps) | Richer correlations |
| **Could** | Cloud sync / accounts | Needed for multi-device |
| **Won't (for now)** | Social feed, leaderboards | Conflicts with privacy and no-shame principles |
| **Won't** | Diet plans / meal prescriptions | Medical liability, out of scope |

---

## 4. MVP scope

**Goal of MVP:** prove that people will log at least 2 meals a day for 2 weeks when logging is this easy.

### MVP screens
1. **Today (home)**: timeline of today's entries, with a big **+** button and a row of "Again" chips
2. **Add entry** (bottom sheet):
   - Camera / photo picker *or* text field (either one is enough to save)
   - Meal type (pre-selected by time; Breakfast / Lunch / Dinner / Snack / Drink)
   - Optional, collapsed: mood 😞😕😐🙂😄, hunger before / fullness after, tags, note
   - **Save** (target: ≤ 2 taps for photo, ≤ 5 seconds total)
3. **Log symptom**: pick from chips (bloating, cramps, headache, nausea, low energy, + custom), severity 1–5, time (defaults to now)
4. **History**: scroll back by day, plus a search box
5. **Entry detail**: view / edit / delete
6. **Settings**: choose modules (mood, hunger, symptoms), reminders on/off, export CSV

### Key user flow: log a meal
```
Open app → tap [+] → camera opens → snap → (auto: "Lunch, 12:41") → [Save]
                                          ↳ optional: tap "Add details" → mood / note / tags
```

### Key user flow: log a symptom
```
Open app → tap [+] → "Symptom" tab → tap "Bloating" → severity ●●●○○ → [Save]
```

---

## 5. Data model (draft)

```text
Entry
  id            uuid
  type          "meal" | "drink" | "symptom" | "note"
  timestamp     datetime (editable; supports back-fill)
  mealType      "breakfast" | "lunch" | "dinner" | "snack" | null
  title         string? (e.g. "Chicken burrito")
  photoUri      string?
  note          string?
  tags          string[]  (e.g. ["takeout", "spicy", "dairy"])
  moodBefore    1–5?
  moodAfter     1–5?
  hungerBefore  1–5?
  fullnessAfter 1–5?
  createdAt / updatedAt

Symptom (when type = "symptom")
  name          string (e.g. "bloating")
  severity      1–5
  durationMin   int?

SavedMeal
  id, title, photoUri?, tags[], useCount, lastUsedAt

Settings
  enabledModules   ["mood", "hunger", "symptoms", "macros", ...]
  reminderTimes    time[] | "smart"
  showNumbers      bool
```

Tags such as `dairy`, `gluten`, `caffeine`, or `spicy` matter because the pattern finder compares symptom frequency in the hours after meals **with** a tag against meals **without** it. That works without a full nutrition database.

---

## 6. Tech options (to decide before development)

| Option | Pros | Cons | Fit |
|---|---|---|---|
| **React Native + Expo** | One codebase for iOS + Android, fast iteration, camera and notifications built in, test on your phone via Expo Go | Slightly less native feel | ⭐ Recommended for MVP |
| Flutter | Great UI performance, single codebase | Dart learning curve | Good |
| Native Swift / Kotlin | Best platform feel and HealthKit access | Two codebases | Later, if needed |
| PWA (web app) | No app store, simplest to build | Weaker camera, notification, and offline support on iOS | Fastest prototype |

**Storage:** on-device SQLite (e.g. `expo-sqlite`) for MVP, with photos in the app's file system. Add optional cloud sync (e.g. Supabase / Firebase) in v2.

---

## 7. Success metrics

| Metric | MVP target |
|---|---|
| Median time to log a meal | ≤ 10 s |
| Meals logged per active day | ≥ 2 |
| Day-7 retention (logged on day 7) | ≥ 40% |
| Day-14 retention | ≥ 25% |
| % entries with optional details (mood/tags) | Watch only. Shows if optional fields are valued |
| Qualitative: "I learned something about my eating" | ≥ 50% of testers at end of week 2 |

---

## 8. Roadmap sketch

| Phase | Contents |
|---|---|
| **0. Validate** (1–2 wks) | Your own 7-day diary study, 5–8 interviews, survey. Update personas and priorities |
| **1. MVP** (3–5 wks) | Section 4 screens, local storage, CSV export. Test with 5–10 friends for 2 weeks |
| **1.1** | Weekly recap, calendar grid, smart reminders, symptom pattern finder, PDF export |
| **2** | Optional numbers module (barcode + food database), AI photo suggestions, Health app integration, cloud sync |

---

## 9. Open questions (decide before building)

1. **Who is this for first?** Just you, or a public app? It changes how much polish, onboarding, and backend we need.
2. **Primary goal:** awareness/habits, symptom-detective, or calories/macros?
3. **Platform:** iPhone, Android, or both? Is a web prototype acceptable to start?
4. **Numbers:** include calories in the MVP or keep it numbers-free?
5. **AI features:** worth an API cost (e.g. photo → food suggestions) in v1, or later?
6. **Data:** local-only is OK, or do you need sync across devices from day one?
