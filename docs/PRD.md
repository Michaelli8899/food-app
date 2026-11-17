# Product Requirements Document: Bite Log

*A fun food journal for iPhone. Collect stamps, don't count calories.*

---

## 0. Document control

| Field | Value |
|---|---|
| **Product** | Bite Log (working name) |
| **Platform** | iPhone, iOS 17+. Public App Store release |
| **Document status** | 🟡 **Draft v0.3, awaiting approval.** No build work starts until §25 is signed off |
| **Owner** | Product owner (you) |
| **Author** | Claude (drafting support) |
| **Last updated** | 2026-11-17 |
| **Related docs** | [01 User research](./01-user-research.md) · [02 Feature design](./02-feature-design.md) · [03 Gamification design](./03-gamification.md) |

### Version history

| Version | Date | Change |
|---|---|---|
| v0.1 | 2026-11-16 | Initial concept and feature brainstorm (docs 01–03) |
| v0.2 | 2026-11-16 | First PRD draft with desk research, personas, jobs to be done, pain points, prioritization |
| v0.3 | 2026-11-17 | Full structure. Adds goals and non-goals, user journeys, detailed functional requirements, gamification spec, UX and content spec, data model, analytics plan, privacy, release and go-to-market plans, sign-off. **Roadmap re-dated**: a 2026 year-end recap is not realistic (see §19) |

### Approvals

| Role | Name | Decision | Date |
|---|---|---|---|
| Product owner | | ☐ Approved ☐ Changes requested | |
| Design (if any) | | ☐ Approved ☐ Changes requested | |
| Engineering | | ☐ Approved ☐ Changes requested | |

---

## 1. Executive summary

**Problem.** Most people who start a food journal quit within days. In one study, only about 3% of a photo-based food journal's downloads were still in use after a week. Logging is a chore: people forget, meals are hard to enter, and logging at the table is awkward. The apps give nothing back. Calorie-first apps add guilt, and more than a third of calorie-app users in one survey said the app contributed to disordered-eating symptoms.

**Solution.** Bite Log is a calorie-free iPhone food journal for **every** meal: home-cooked, takeout or restaurant. You log with a photo or a name plus one-tap tags. Each meal feeds a **Food Passport** of cuisine stamps, **weekly quests**, variety badges, and personal recaps worth sharing.

**Who.** Curious eaters aged roughly 20–35 who photograph their food and like trying new things (Explorer Ellie). People who want to understand their habits without counting (Curious Casey). The safety rules are designed around people who were burned by calorie apps (Recovering Riley).

**Why we win.** No current app combines (1) logging for every meal, (2) photo-light and calorie-free, (3) collecting in the style of Untappd, and (4) recaps in the style of Spotify Wrapped. Beli covers only restaurants. Photo diaries have no hook. Calorie apps cause guilt.

**MVP.** 12 features (§9): quick log, tags, "Again" re-log, reminders, back-fill, Passport, quests, XP and badges, weekly recap, history, share card, and safety rules.

**Targets.** At least 40% of users still logging on day 7, and at least 20% on day 30. Photo log in 5 seconds or less. 60% or more of entries tagged.

**Asks.** Approve positioning, MVP scope, safety rules, the validation plan and the timeline (§25).

---

## 2. Background and problem

### 2.1 Problem statement
People who want to understand and enjoy their eating keep quitting food journals within weeks. Logging feels like work: they forget, meals are hard to describe, and logging in public is awkward. The journal gives nothing back. Calorie-first tools add guilt and can encourage disordered eating.

### 2.2 How might we
**…make keeping a food journal so easy and so rewarding that people *want* to log every meal, home-cooked, takeout or restaurant, without counting anything?**

### 2.3 Why now
- **Fatigue with calorie apps** and growing awareness of their harms (F4).
- **Wrapped culture:** personal recaps are expected and shared widely (F7).
- **Gen Z curiosity about food:** 74% like trying new cuisines (F8).
- **On-device iOS capabilities** (Vision, PhotoKit, WidgetKit, SwiftData) make private, fast, offline logging cheap to build.

---

## 3. Goals, non-goals, and what success means

### 3.1 Product goals (year 1)

| # | Goal | Measured by |
|---|---|---|
| G1 | Make logging effortless | Median photo-log time ≤ 5 s. 3+ logs in first 48 h for ≥ 50% of new users |
| G2 | Build a lasting habit | D7 ≥ 40%, D30 ≥ 20% logging retention |
| G3 | Make it rewarding | ≥ 60% of entries tagged. ≥ 35% of weekly actives complete at least 1 quest |
| G4 | Grow through sharing | ≥ 0.3 share-card exports per weekly active user per month |
| G5 | Do no harm | ≤ 5% of users agree that "the app makes me feel guilty or anxious" |

### 3.2 Business goals
- Launch on the App Store with a **4.5★ or higher** rating.
- Reach **10k downloads** in the first 6 months (assumption, to validate).
- Keep **core logging free forever**. Explore an optional subscription after launch (§21).

### 3.3 Non-goals (explicitly out of scope)
- ❌ Calorie, macro, weight or portion tracking. No nutrition database.
- ❌ Diet plans, medical advice, or health or weight-loss claims.
- ❌ Public social feed, follower counts, public leaderboards.
- ❌ Restaurant reviews for the public (we are a personal journal, not Yelp).
- ❌ Android, iPad-optimized layout, or web app (later, maybe).
- ❌ Symptom or mood tracking in the MVP (possible later module).
- ❌ Ads.

---

## 4. User research

### 4.1 Method and limits

| Source type | What we used | Notes |
|---|---|---|
| Academic | CHI 2015 food-journal survey (141 past journalers). Dietary self-monitoring trials (JMIR / PMC). Yale SOM photo-vs-text study. Survey of calorie apps and eating disorders (1,357 adults). Untappd gamification paper (2026) | Strongest evidence |
| App store reviews | See How You Eat, Beli, Thirty Plants, FoodyLife, Shutterbite, Stop Takeout | What users of today's apps love and hate |
| Community posts | MyFitnessPal forum. r/nutrition and r/personalfinance threads read through mirror sites. Duolingo streak case study summarizing Reddit posts | ⚠️ **Reddit blocks automated reading.** Reddit evidence here is second-hand. To-do: add quotes by hand (Appendix B) |
| Market data | YouGov and Morning Consult Gen Z dining surveys. Spotify Wrapped engagement | Sizing and positioning |
| Primary research | **Not done yet.** Interview guide in Appendix C | Phase 0 (§19) |

### 4.2 Key findings

**F1. Almost everyone quits, and fast.**
- In a photo-based food journal study, only **about 3% of ~190,000 downloads were still used after 1 week** ([Big Think](https://bigthink.com/surprising-science/why-so-many-people-quit-food-logging-apps-in-the-first-week/)).
- Consistent tracking fell **from 68% in week 1 to 21% by week 12**. Diet logging lasted a **median of 10 weeks** ([PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC8900900), [PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6416539/)).
- → *Making capture easy is necessary but not enough. People need a reason to come back.*

**F2. Why entries get missed.** Survey of 141 past journalers ([CHI 2015](https://homes.cs.washington.edu/~jfogarty/publications/chi2015-decaf.pdf)):

| Reason | Share |
|---|---|
| Forgot | 54% |
| Food too hard to enter | 40% |
| Didn't know what was in the meal | 40% |
| Didn't want to log in front of friends | 20% |

- Some people changed their diet to make logging easier: *"I just avoided eating things that were hard to log."*
- → *Never require ingredients or portions. Help people remember. Allow quiet logging later.*

**F3. Photos are easier but need structure.**
- 46% find photos easier than nutrition labels (22%) for judging a meal (CHI 2015).
- Yale found people **followed through less** with photo-only logging than with typed logging ([Yale Insights](https://insights.som.yale.edu/insights/when-counting-calories-words-are-more-valuable-than-pictures)).
- → *Photo first, plus quick one-tap tags.*

**F4. Calorie apps and game mechanics can harm.**
- 71% of 1,357 adults had used a calorie app. **More than a third** said it contributed to disordered-eating symptoms. Badges and daily streaks were named as triggers ([UKY](https://aes.as.uky.edu/bibcite/reference/27230), [The Swaddle](https://theswaddle.com/health-tracking-apps-provide-a-worrying-pipeline-to-eating-disorders-better-tech-design-can-fix-that/)).
- A MyFitnessPal user: *"feel like a slave to the app"* ([MFP](https://community.myfitnesspal.com/en/discussion/comment/37254330)).
- Database calorie values can be badly off: +49% for pho, −76% for pearl milk tea ([TDP](https://tdp-frontend.pages.dev/article/2026-03-20-the-promise-and-pitfall-of-food-tracking-apps-5cb17704)).
- → *No calories is a feature. Reward variety, never amount.*

**F5. Losing a streak leads to quitting.**
- Users *"repeatedly report abandoning the app after losing a long streak"* ([Duolingo case study](https://jiwonvyoo.github.io/portfolio/case/duolingo/duo.html)).
- → *No daily streaks that reset. Use weekly goals and totals that only go up.*

**F6. Collecting works when it rewards variety.**
- Untappd's badges for unique beers, countries and styles drive check-ins. Researchers flag badges for quantity as ethically grey ([arXiv](https://arxiv.org/html/2601.04841v1)).
- → *A cuisine passport: collecting applied to food variety.*

**F7. Recaps spread themselves.**
- Spotify Wrapped 2025: **200M engaged users and 500M shares in 24 h** ([MBW](https://www.musicbusinessworldwide.com/spotify-wrapped-campaign-hit-200m-engaged-users-in-24-hours-a-19-yoy-increase)).
- The niche app Thirty Plants already ships a "wrapped" ([App Store](https://apps.apple.com/app/id6447438431)).

**F8. The audience is curious but budget-aware.**
- 74% of Gen Z like new cuisines. About 1 in 5 tried 5 or more new restaurants last month ([YouGov](https://yougov.com/en-gb/articles/55399-how-gen-z-consumers-eat-out-in-2026-attitudes-restaurant-types-and-discovery-drivers), [Morning Consult](https://pro.morningconsult.com/analysis/gen-z-restaurant-research)).
- But 69% see eating out as a treat.
- → *Every meal must count, not just restaurants.*

### 4.3 Competitive analysis (F9)

| App | Category | What users like | What users complain about / what's missing | Our angle |
|---|---|---|---|---|
| **See How You Eat** | Photo diary | "simple, easy to use", PDF export | Photo limits, **91-day history cap**, "annoying" upgrade prompts, dated UI, no insights | Unlimited history, a reason to return |
| **Beli** | Restaurant ranking | Head-to-head ranking, lists, 4.86★ | **Restaurants only**. $79.99/yr tier. Notifications. "Commercialized". Users want **"lists… based on cuisine"** | All meals. Cuisine-first. Personal |
| **MyFitnessPal and similar** | Calorie counting | Huge database | Slow, guilt, paywalls, harm (F4) | No numbers |
| **Thirty Plants** | Plant variety | Clear goal, "wrapped" | Single purpose | Plant challenge as a later feature (F-19) |
| **Stop Takeout** | Takeout accountability | Simple | Single purpose, guilt framing | Neutral home-vs-out insight |
| **FoodyLife / Shutterbite / FoodView** | "No calorie" photo diaries | No numbers | Commodity apps with no hook | Passport, quests, recaps |

**White space:** logging for every meal + calorie-free + collecting + recaps.

---

## 5. Target users

### 5.1 Positioning statement
> **For** curious eaters who photograph their food and like trying new things,
> **who** have quit calorie apps or never wanted one,
> **Bite Log is** a food journal for iPhone
> **that** turns every meal, whether home-cooked, takeout or restaurant, into stamps, quests and recaps worth sharing.
> **Unlike** MyFitnessPal (counting and guilt) or Beli (restaurants only),
> **we** celebrate variety and discovery across all your meals, with no numbers to hit.

### 5.2 Proto-personas *(hypotheses until Phase 0 interviews)*

| | **Explorer Ellie** (primary) | **Curious Casey** (primary) | **Recovering Riley** (shapes the safety rules) |
|---|---|---|---|
| Snapshot | 24, city, eats out or orders in 3–5×/week, posts food on Instagram | 29, busy, suspects too much takeout, quit MyFitnessPal in week 2 | 31, calorie tracking became obsessive, now does intuitive eating |
| Wants | A record of what and where she ate, plus bragging rights | An honest view of habits without numbers | Mindful awareness and fun, with no pressure |
| Frustrations | Camera roll chaos. Beli is restaurants only | Slow logging, forgetting, guilt | Numbers, red warnings, streaks |
| Hook | Passport, map, rankings, recap | 5-second log, home-vs-out split, gentle quests | No-calories promise, neutral tone |
| Risk to avoid | Boredom after the first stamps | Quitting in week 1 | Anxiety, compulsive checking |

### 5.3 Anti-personas (not designing for)
- People who need precise nutrition data (athletes cutting weight, clinical diets). → MyFitnessPal or Cronometer.
- People who want public reviews or restaurant discovery. → Yelp, Google Maps, Beli.

---

## 6. Jobs to be done

| # | When… | I want to… | So I can… | Type | Persona |
|---|---|---|---|---|---|
| J1 | I'm about to eat or just finished | capture it in seconds, even with friends around | keep my journal without effort or awkwardness | Functional | All |
| J2 | I forgot to log | catch up easily later | not feel the journal is "ruined" | Functional / Emotional | Casey, Riley |
| J3 | I try a new cuisine or place | feel that it counted | feel adventurous and proud | Emotional | Ellie |
| J4 | I wonder about my habits | see home vs. out and how varied my meals are | make small changes without guilt | Functional | Casey |
| J5 | I want to cook more or try new things | get small, doable challenges | build the habit in a fun way | Functional / Emotional | Casey, Ellie |
| J6 | Someone asks "where was that ramen?" | find it instantly | recommend and remember it | Functional / Social | Ellie |
| J7 | It's the end of a month or year | see a fun recap | reminisce and share | Social / Emotional | Ellie |
| J8 | I had a "bad" food day | log without judgment | not avoid the app | Emotional | Riley, Casey |

---

## 7. Pain points

| # | Pain point | Evidence | Severity | Jobs | Addressed by |
|---|---|---|---|---|---|
| PP1 | **No payoff**, so the habit dies | F1, F9 | 🔴 Critical | J3, J4, J7 | F-06, F-07, F-08, F-09, F-17 |
| PP2 | **Forgetting** | F2 (54%) | 🔴 Critical | J1, J2 | F-04, F-05, F-13, F-14 |
| PP3 | **Logging is slow or hard** | F2 (40% / 40%) | 🔴 Critical | J1 | F-01, F-02, F-03 |
| PP4 | **Guilt, numbers, anxiety** | F4 | 🔴 Critical | J8 | F-11 |
| PP5 | **Streak loss leads to quitting** | F5 | 🟠 High | J2, J8 | F-11, F-05 |
| PP6 | **Everyday meals ignored** by restaurant apps | F8, F9 | 🟠 High | J3, J4 | F-02, F-06 |
| PP7 | **Food memories unorganized** | F9 (to validate) | 🟡 Medium | J6 | F-10, F-15, F-16 |
| PP8 | **Awkward to log at the table** | F2 (20%) | 🟡 Medium | J1, J2 | F-05, F-13 |
| PP9 | **Paywalls and limits** on basics | F9 | 🟡 Medium | All | §21 pricing principles |

---

## 8. Solution overview

### 8.1 Product principles
1. **Capture first, details later.** A photo or a name is a complete entry.
2. **Details are rewarded, never required.** Tags earn XP. Nothing nags.
3. **Celebrate variety and curiosity**, never amount or restriction.
4. **No punishment.** Missed days cost nothing. Totals only go up.
5. **Every meal counts.** Home, takeout, restaurant, office snacks.
6. **Private by default, shareable by choice.**
7. **Free core, forever.**

### 8.2 Core loop
```
   ┌──────────────────────────────────────────────────────────┐
   ▼                                                          │
 Eat ──► Snap / name (≤5 s) ──► Tag (optional, +XP) ──► Reward │
                                                    (XP, stamp,│
                                                quest progress)│
                                                          │    │
 Monday: recap + new quests ◄─────────────────────────────┘    │
          │                                                    │
          └──► Share card ──► friend installs ─────────────────┘
```

### 8.3 Opportunity tree
```
Outcome: people log most meals for 30+ days and enjoy it
├── O1 Effortless capture         → F-01 Quick log · F-02 Tags · F-03 Again · F-04 Reminders · F-05 Back-fill · F-13 Camera-roll catch-up · F-14 Widget
├── O2 A reason to come back      → F-06 Passport · F-07 Quests · F-08 XP/levels/badges
├── O3 Insight & memory           → F-09 Weekly recap · F-10 History · F-15 Food Map · F-16 Rankings
├── O4 Shareability               → F-12 Share card · F-17 Monthly recap / Bite Wrapped
└── O5 Kind & safe                → F-11 Guardrails · F-18 iCloud backup · pricing principles
```

---

## 9. Feature inventory and prioritization

**Scoring (RICE-lite):**
- **Reach** = share of active users who touch the feature per month.
- **Impact** = 1 (low) to 3 (high) effect on goals G1–G5.
- **Confidence** = strength of evidence.
- **Effort** = S (≤ 3 days), M (1–2 weeks), L (3+ weeks).

**Priority levels:** P0 = MVP. P1 = before public launch. P2 = after launch.

| ID | Feature | Pain points | Reach | Impact | Conf. | Effort | **Priority** |
|---|---|---|---|---|---|---|---|
| F-01 | Quick log (photo *or* name) | PP3 | 100% | 3 | High | M | **P0** |
| F-02 | Tag set (source, cuisine, food types, meal, rating, place, companions, note) | PP6 | 100% | 3 | High | M | **P0** |
| F-03 | "Again" one-tap re-log | PP3 | 70% | 2 | High | S | **P0** |
| F-04 | Gentle meal-time reminders | PP2 | 80% | 3 | High | S | **P0** |
| F-05 | Back-fill / edit time | PP2, PP5 | 60% | 2 | High | S | **P0** |
| F-06 | Food Passport with tiers | PP1, PP6 | 90% | 3 | Med-High | M | **P0** |
| F-07 | Weekly quests | PP1 | 80% | 3 | Medium | M | **P0** |
| F-08 | XP, levels, badges | PP1 | 90% | 2 | Medium | M | **P0** |
| F-09 | Weekly recap card | PP1 | 90% | 3 | High | S | **P0** |
| F-10 | History: search, filter, edit, delete | PP7 | 70% | 2 | High | S | **P0** |
| F-11 | Safety guardrails | PP4, PP5 | 100% | 3 | High | S | **P0** |
| F-12 | Share card (stamp, weekly recap) | Growth | 40% | 2 | Medium | S | **P0** |
| F-13 | Camera-roll catch-up | PP2, PP8 | 60% | 3 | Medium | M | **P1** |
| F-14 | Home and Lock Screen widgets | PP2 | 50% | 2 | High | M | **P1** |
| F-15 | Apple Maps place search + Food Map | PP7 | 60% | 2 | High | M | **P1** |
| F-16 | Personal rankings (head-to-head) | PP7 | 40% | 2 | Medium | M | **P1** |
| F-17 | Monthly recap + Bite Wrapped (yearly) | Growth | 80% | 3 | High | L | **P1** (monthly) / Dec 2027 (Wrapped) |
| F-18 | iCloud sync and backup | PP9 | 50% | 2 | High | M | **P1** |
| F-19 | Variety challenges (Rainbow / 30 plants) | PP1 | 30% | 2 | Medium | M | P2 |
| F-20 | Dish and cuisine suggestions from photo (on-device ML) | PP3 | 100% | 2 | Low-Med | L | P2 |
| F-21 | Friends: compare passports, co-op quests | Growth | 30% | 2 | Low | L | P2 |
| F-22 | Takeout spend insight (optional price) | J4 | 25% | 1 | Low | S | P2 |
| F-23 | Seasonal events | PP1 | 50% | 2 | Low | M | P2 |

---

## 10. User journeys

### UJ1: First run (activation)
1. Install, then open. 3 onboarding screens (§11.13). No account.
2. The Today screen shows an empty state: "Snap your next bite."
3. Tap **Log a bite**, then camera, snap, Save. Takes 5 seconds or less.
4. **Reward:** "First Bite" badge and level 2 → celebration sheet.
5. After the 3rd log: a one-time prompt offers meal-time reminders (F-04).

**Success:** 3+ logs within 48 h.

### UJ2: Log a restaurant meal (Ellie)
1. At the table, Ellie snaps a photo (or opens the camera from the widget in P1).
2. Taps 🍽️ Restaurant, then 🇵🇪 Peruvian, then 🐟 Seafood, then 🤩. Types "Ceviche" and the place name.
3. Save → **"New stamp: Peruvian! 13/44"** and "+50 XP". She shares the stamp.

### UJ3: Forgot to log (Casey)
1. Evening reminder: "What's on the plate today? 🍜".
2. Casey opens the app, taps **Log a bite**, sets the time to 12:30 (back-fill), types "Burrito", taps 🥡 Takeout.
3. Full rewards and no penalty. *(P1: the camera-roll catch-up suggests the lunch photo instead.)*

### UJ4: Monday recap and new quests
1. First open on Monday shows the **Weekly recap** card (F-09): 14 meals, 🏠 6 / 🥡 5 / 🍽️ 3, 5 cuisines (1 new), top dish, quests 2/3.
2. Tap **See this week's quests**: three new quests, one shuffle available.
3. Share the recap card (optional).

### UJ5: Gold stamp
1. Ellie has eaten 5 different Japanese dishes (Silver).
2. She cooks miso soup at home and tags 🏠 + 🇯🇵 → **"Japanese stamp is now Gold!"**

### UJ6: Bad day (Riley)
1. Riley logs late-night chips and fries without tags.
2. The app responds only with the normal "+10 XP". There's no judgment, no warning, and no "you broke your streak".

### UJ7: Edit or delete
1. History → entry → Edit, or ⋯ → Delete → confirm.
2. All XP, stamps and badges are recalculated, and nothing breaks.

---

## 11. Functional requirements: MVP (P0)

Requirement IDs use **FR-[feature].[n]**. Acceptance criteria (AC) use Given / When / Then.

### 11.1 F-01 Quick log
**User story:** As Casey, I want to log a meal with just a photo or a few words so it takes seconds.

| ID | Requirement |
|---|---|
| FR-01.1 | The Today screen has a persistent primary **Log a bite** button that opens the entry sheet |
| FR-01.2 | The entry sheet offers **Camera** (if available) and **Library** as the first options, plus a name field |
| FR-01.3 | **Save** is enabled when a photo **or** a non-blank name exists. All other fields are optional |
| FR-01.4 | Meal type is pre-filled from the local time: 05–10 Breakfast, 10–11 Brunch, 11–15 Lunch, 15–17 Snack, 17–22 Dinner, else Late-night |
| FR-01.5 | Photos are downscaled on device (long edge ≤ 1600 px, JPEG ~0.8) and a ~400 px thumbnail is generated |
| FR-01.6 | There is no limit on photos per day or on history length |
| FR-01.7 | The name field autocompletes from the user's previous dish names *(nice-to-have in P0)* |

**AC**
- **Given** a new user on Today, **when** they tap Log a bite → Camera → shutter → Save, **then** the entry appears in Today within 1 s, and the median time in usability tests is ≤ 5 s.
- **Given** the entry sheet with no photo and a blank name, **then** Save is disabled.
- **Given** a device without a camera (simulator), **then** only Library and name are shown.

**Edge cases:** photo permission denied → show inline guidance with a Settings link, and name-only logging still works. Very large or HEIC images → convert to JPEG. Cancel with unsaved changes → discard without a prompt (MVP).

### 11.2 F-02 Tags
| ID | Requirement |
|---|---|
| FR-02.1 | **Source** (single select): 🏠 Home-cooked · 🍽️ Restaurant · 🥡 Takeout · 🛒 Store-bought · 👵 Cooked for me · 🎉 Party/Event |
| FR-02.2 | **Cuisine** (multi-select): 44 cuisines in 8 regions plus "Fusion" (which doesn't earn a stamp). Shows 8 quick chips (selected → recent → popular defaults), and **More…** opens a searchable list grouped by region |
| FR-02.3 | **Food types** (multi): Veggies, Fruit, Grains, Beans & Legumes, Meat, Seafood, Eggs, Dairy, Plant-based, Sweets, Drink, Spicy |
| FR-02.4 | **Rating** (single, optional): 👎 Not again · 😐 Meh · 👍 Good · 🤩 Loved it |
| FR-02.5 | **More details** (collapsed): place (free text in P0), companions (Solo / Friends / Family / Date / Work), date and time, notes |
| FR-02.6 | Each tag section header shows the XP it earns (§12.1) |
| FR-02.7 | If a typed place matches a previous entry's place (case-insensitive, trimmed) and no cuisine is selected, pre-fill that entry's cuisine |
| FR-02.8 | **No** ingredient, portion, calorie or nutrition fields anywhere |

**AC**
- **Given** a user previously logged "Tacos El Gordo" as Mexican, **when** they type "tacos el gordo" in place, **then** 🇲🇽 Mexican is pre-selected.
- **Given** any tag chip, **when** it's tapped twice, **then** it is deselected (single-select chips allow clearing).

### 11.3 F-03 "Again" re-log
| ID | Requirement |
|---|---|
| FR-03.1 | Today shows an "Again?" row with up to 8 dishes, ranked by frequency in the last 30 days (most recent wins ties) |
| FR-03.2 | Tapping a chip creates a new entry timed *now*, copying name, source, cuisines, food types and place. It does not copy photo, rating, companions or notes |
| FR-03.3 | Rewards are processed the same as a manual log |

**AC:** **Given** "Oatmeal" logged 4× in 30 days, **then** it appears first. **When** tapped, **then** a new entry appears in Today with the same tags.

### 11.4 F-04 Gentle reminders
| ID | Requirement |
|---|---|
| FR-04.1 | Off by default. A one-time opt-in card appears **after the 3rd log** (not during onboarding) |
| FR-04.2 | The user picks up to 3 windows (defaults 08:30, 12:30, 19:00), editable in Settings |
| FR-04.3 | A reminder is **suppressed** if any entry exists within ±2 h of the window that day |
| FR-04.4 | Copy rotates through neutral lines (§14.4). Never uses "missed", "forgot", "streak" or guilt words |
| FR-04.5 | Maximum 3 notifications a day, and no re-engagement spam (no "We miss you!") |

**AC:** **Given** a reminder at 12:30 and a lunch logged at 12:05, **then** no 12:30 notification fires.

**Technical note:** schedule local notifications. Reschedule when the app is active and after each save.

### 11.5 F-05 Back-fill and edit time
| ID | Requirement |
|---|---|
| FR-05.1 | Any entry's date and time can be set to any past moment (no future dates) |
| FR-05.2 | Back-filled entries earn identical rewards and count toward the week they belong to |
| FR-05.3 | Weekly dots and quests update immediately |

### 11.6 F-06 Food Passport
| ID | Requirement |
|---|---|
| FR-06.1 | Passport tab: header "N of 44 cuisines collected" plus a progress bar and "X of 8 regions explored" |
| FR-06.2 | Stamps are grouped by region. Collected = colored stamp with tier border and first date. Uncollected = dashed outline, gray emoji, name visible |
| FR-06.3 | Tiers per §12.3 (Bronze / Silver / Gold) |
| FR-06.4 | Tapping a stamp opens detail: tier, first date, first dish, meal and dish counts, "cooked at home" status, next-tier hint, **Share** |
| FR-06.5 | A new stamp or tier upgrade triggers the celebration sheet (§12.6) |

**AC:** **Given** no Peruvian entries, **when** the user saves an entry tagged Peruvian, **then** the celebration shows "New stamp: Peruvian!" and the Passport count goes up by 1.

### 11.7 F-07 Weekly quests
| ID | Requirement |
|---|---|
| FR-07.1 | Weeks run Monday 00:00 to Sunday 23:59 local time. Each week gets **3 quests**: Easy, Medium, Adventure (pool in §12.5) |
| FR-07.2 | Selection is deterministic per week (so it's stable across launches) and skips quests the user can't achieve (e.g. "cook a cuisine you've only eaten out" needs history) |
| FR-07.3 | Targets adapt: if fewer than 20% of the user's meals in the previous 14 days were home-cooked, "Cook at home" targets 1 instead of 3 |
| FR-07.4 | **Shuffle** once a week, allowed only before any quest that week is complete |
| FR-07.5 | Each completed quest gives +100 XP and a celebration. Unfinished quests silently expire, with no "failed" state |
| FR-07.6 | Today shows the next unfinished quest with a progress bar |

### 11.8 F-08 XP, levels, badges
| ID | Requirement |
|---|---|
| FR-08.1 | XP per §12.1. Logging XP counts only the first 6 entries per calendar day |
| FR-08.2 | Levels and titles per §12.2 |
| FR-08.3 | About 21 badges per §12.4, including at least 1 secret badge (shown as "❓ Secret" until earned) |
| FR-08.4 | **All progress is recalculated from entries.** Edits and deletes are reflected immediately and consistently |
| FR-08.5 | Ordinary logs show a brief "+N XP" toast. Bigger milestones show the celebration sheet |

### 11.9 F-09 Weekly recap
| ID | Requirement |
|---|---|
| FR-09.1 | On the first app open each Monday (when the previous week had 1 or more entries), show the recap for the previous week |
| FR-09.2 | Content: meals logged, days logged (●●●●○○○), split by source, cuisines (new ones highlighted), new places, top-rated dish (photo if any), quests completed |
| FR-09.3 | Wording is descriptive only (§14.4). No comparison to "goals" or other users |
| FR-09.4 | Past recaps are reachable from the Progress tab |
| FR-09.5 | **Share** exports the card as an image (F-12) |

**Edge:** the previous week had 0 entries → no recap, just a friendly "New week, new quests 🎯" card.

### 11.10 F-10 History
| ID | Requirement |
|---|---|
| FR-10.1 | List grouped by day (Today, Yesterday, then weekday and date), newest first |
| FR-10.2 | Search across dish name, place, notes and cuisine names |
| FR-10.3 | Filter by source |
| FR-10.4 | Entry detail: photo, all tags, Edit (opens the entry sheet pre-filled), Delete with confirmation |
| FR-10.5 | Swipe to delete in the list |

### 11.11 F-11 Safety guardrails *(launch-blocking)*
| ID | Requirement |
|---|---|
| FR-11.1 | No calorie, macro, weight or portion fields, imports or HealthKit nutrition writes |
| FR-11.2 | No XP, badge or quest rewards eating **more** or **less**. Every reward is reachable on a normal diet |
| FR-11.3 | No daily streak that resets. Use weekly dots that refresh Monday, and lifetime totals that never decrease |
| FR-11.4 | No moral food language ("clean", "junk", "cheat", "bad", "guilty") in UI, notifications or App Store copy |
| FR-11.5 | Notifications follow FR-04 |
| FR-11.6 | Settings → About states "No calories. Ever." and links to eating-disorder support resources (e.g. NEDA / national helplines) |
| FR-11.7 | Copy review checklist (§14.4) is part of release criteria |

### 11.12 F-12 Share card
| ID | Requirement |
|---|---|
| FR-12.1 | Share a **stamp** (from stamp detail) and the **weekly recap** as a branded 1080×1350 image through the iOS share sheet |
| FR-12.2 | Meal photos appear on a card only if the user toggles "Include photo" |
| FR-12.3 | Cards include a small "Bite Log" wordmark (and an App Store link once live) |

### 11.13 Onboarding
| ID | Requirement |
|---|---|
| FR-13.1 | 3 swipeable screens: **Snap every bite**, **Fill your Food Passport**, **No calories. Ever.** Then "Let's eat" |
| FR-13.2 | No account, no sign-up, no permission prompts during onboarding. Camera and Photos permissions are requested on first use |
| FR-13.3 | Can be replayed from Settings |

### 11.14 Settings
| ID | Requirement |
|---|---|
| FR-14.1 | Reminders (on/off, times) |
| FR-14.2 | Export all data as CSV (via share sheet) |
| FR-14.3 | Delete all data (double confirmation). This also resets quest shuffles |
| FR-14.4 | About: version, "No calories. Ever.", support resources, privacy policy link, contact |

---

## 12. Gamification specification

### 12.1 XP table

| Action | XP |
|---|---|
| Log an entry (counts only the first 6 per day) | +10 |
| Tag source | +2 |
| Tag cuisine | +3 |
| Tag food types | +3 |
| Add rating | +2 |
| Home-cooked bonus | +5 |
| First time: new dish name | +15 |
| First time: new place | +20 |
| First time: new cuisine (stamp) | +50 |
| Complete a weekly quest | +100 |

### 12.2 Levels
- **Cumulative XP to reach level *n*** = 25 × (n−1) × n. That gives L2 = 50, L3 = 150, L4 = 300, L5 = 500, L10 = 2,250, L20 = 9,500.
- A typical active user (~2 tagged logs a day) reaches L3–L4 in week 1 and about L10 in 2 months.

| Levels | Title |
|---|---|
| 1–2 | Snack Rookie |
| 3–4 | Taste Tester |
| 5–7 | Flavor Scout |
| 8–11 | Spice Adventurer |
| 12–16 | Gourmet |
| 17+ | Culinary Legend |

### 12.3 Passport tiers

| Tier | Rule |
|---|---|
| 🥉 Bronze | At least 1 entry tagged with the cuisine |
| 🥈 Silver | 5 or more *different* named dishes in that cuisine |
| 🥇 Gold | Silver, plus at least 1 home-cooked entry in that cuisine |

### 12.4 Badge catalog (MVP)

| Badge | Rule | Badge | Rule |
|---|---|---|---|
| 🍴 First Bite | 1 entry | 🥂 Brunch Club | 5 brunches |
| 📸 Shutterbug | 25 photo entries | 🦉 Night Owl | 5 late-night entries |
| 🧳 Globetrotter I | 5 cuisines | 🔥 Feel the Heat | 10 spicy dishes |
| ✈️ Globetrotter II | 15 cuisines | ⚓ Sea Legs | 10 seafood dishes |
| 🌏 Globetrotter III | 30 cuisines | 🌿 Plant Power | 50 plant-based entries |
| 🗺️ World Tour | ≥ 1 cuisine in all 8 regions | 🧐 Critic | 50 ratings |
| 🍳 Home Chef I / II / III | 10 / 50 / 150 home-cooked | 🧸 Comfort Classic | same dish 10× |
| 🪑 Regular | same place 5× | 🍱 Leftover Legend | same home dish 3 days in a row |
| 💎 Hidden Gem Hunter | 10 different places | 🎂 Year One | entries in 12 different months |
| 🍜 *Secret: Midnight Ramen* | ramen after 22:00 | | |

**Every badge passes the guardrail check:** reachable on a normal diet, and none rewards eating more or less.

### 12.5 Quest pool (MVP)

| Difficulty | ID | Quest | Target |
|---|---|---|---|
| Easy | photos7 | Log 7 meals with photos | 7 |
| Easy | rate5 | Rate 5 dishes | 5 |
| Easy | breakfast3 | Log breakfast or brunch 3 times | 3 |
| Easy | days4 | Log on 4 different days | 4 |
| Medium | cookHome | Cook at home (adaptive) | 1 or 3 |
| Medium | cuisines3 | Eat 3 different cuisines | 3 |
| Medium | plantMix | Log veggies, fruit, grains and legumes this week | 4 |
| Medium | tag5 | Fully tag 5 meals (source, cuisine, food types) | 5 |
| Adventure | newCuisine | Try a cuisine you've never had | 1 |
| Adventure | newPlace | Eat somewhere new | 1 |
| Adventure | cookOut | Cook a cuisine at home you've only eaten out *(needs history)* | 1 |

### 12.6 Reward moments

| Event | Treatment |
|---|---|
| Ordinary log | "+N XP" toast, 1.6 s, subtle |
| New stamp / tier up | Celebration sheet: large emoji, spring animation, success haptic, **Share** |
| Badge unlocked | Celebration sheet |
| Quest complete | Celebration sheet ("+100 XP") |
| Level up | Celebration sheet with new title |

Several events from one save are grouped into a single sheet.

### 12.7 Balancing and anti-abuse
- The daily logging-XP cap (6) stops spam-logging.
- Distinct-item rules (cuisines, places, dishes) can't be farmed by repetition.
- There's no competition in the MVP, so cheating only affects the cheater. Stronger checks are added before friend features (F-21).
- **Tuning metric:** median level at D7 should be 3–4. Adjust the XP table after beta if needed.

---

## 13. Requirements: P1 (summary)

| ID | Feature | Key requirements | Open questions |
|---|---|---|---|
| F-13 | **Camera-roll catch-up** | Opt-in limited Photos access. On-device Vision food classifier finds today's food photos. A "3 meals to log?" card. Tap to pre-fill an entry with the photo and its timestamp. Nothing leaves the device | Accuracy threshold, battery cost, App Review wording |
| F-14 | **Widgets** | Lock Screen: tap to open the camera log. Home (small/medium): weekly dots and current quest. Interactive "Again" button (iOS 17 App Intents) | Which widget sizes |
| F-15 | **Place search + Food Map** | MapKit local search with autocomplete. Saves place ID and coordinates. Map tab with pins and a cuisine filter. Location permission "When in use" only, optional | Map as a tab or inside History? |
| F-16 | **Personal rankings** | After 🤩, offer "Better than your #1 ramen?" as a head-to-head comparison. Lists per dish type or cuisine. Shareable | How dish types are grouped |
| F-17 | **Monthly recap; Bite Wrapped** | Monthly story-style recap on the 1st. Yearly Wrapped in December: totals, cuisines, #1 place, "food personality", top dish, map. Exports for Instagram Stories | Personality rules |
| F-18 | **iCloud sync** | SwiftData + CloudKit private database. Off for no-iCloud accounts. Resolves conflicts by last write. Needs paid Apple Developer Program | Migration from local-only store |

---

## 14. UX specification

### 14.1 Information architecture
```
Tab bar
├── Today      — week dots, current quest, "Again?" row, today's entries, [Log a bite]
├── Passport   — progress header, regions → stamps → stamp detail (share)
├── History    — search, source filter, day sections → entry detail (edit/delete)
└── Progress   — level card, weekly quests (shuffle), lifetime stats, badges, past recaps, ⚙︎ Settings
Modal sheets: Entry sheet · Cuisine picker · Celebration · Weekly recap · Onboarding
```

### 14.2 Screen inventory

| Screen | Purpose | Key states |
|---|---|---|
| Today | Daily home | Empty day, entries, all quests done |
| Entry sheet | Create or edit | New, edit, photo attached, permission denied |
| Cuisine picker | Full cuisine list | Search, no results |
| Passport | Collection | 0 stamps, partial, region complete |
| Stamp detail | Info and share | Collected (by tier), uncollected |
| History | Browse and search | No entries, no search results |
| Entry detail | View | With and without photo, minimal tags |
| Progress | Game overview | New user, mid-game |
| Celebration | Reward | Single and multiple events |
| Weekly recap | Monday summary | Normal, previous week empty |
| Settings | Config and data | Reminders on/off, export, delete |
| Onboarding | First run | 3 pages |

### 14.3 Visual direction
- Warm, playful, food-forward. Accent color is coral (#FF6B4A light / #FF8766 dark).
- Rounded cards. Emoji used as icons for cuisines and tags (system emoji, no custom art in the MVP). Custom stamp illustrations come later.
- Supports Light and Dark mode. SF Pro and SF Rounded for big numbers.

### 14.4 Content and tone guidelines
- **Voice:** a friendly foodie friend. Curious and encouraging, never judgmental.

| ✅ Do | ❌ Don't |
|---|---|
| "You cooked 3 dinners this week 🍳" | "Only 3 home-cooked meals" |
| "New week, new quests 🎯" | "You failed 2 quests" |
| "What's on the plate? 🍜" | "You forgot to log lunch!" |
| "Not again 👎" (as a rating) | "Bad food", "junk", "cheat meal" |
| "Keep exploring…" | "Don't lose your streak!" |

**Reminder copy rotation (examples):** "What's on the plate? 🍜" · "Snack, feast, or leftovers? 🥡" · "Anything tasty today? 📸"

### 14.5 Empty and error states

| Situation | Message |
|---|---|
| Today, nothing logged | 🍽️ "Nothing logged yet today. Snap your next bite. A photo is all it takes." |
| Passport, 0 stamps | "Log a meal with a cuisine to earn your first stamp." |
| History empty | "No bites yet. Everything you log shows up here." |
| Search no results | System "No results for '…'" |
| Camera denied | "Camera access is off. You can turn it on in Settings, or pick from your library." |
| Save failed | "Couldn't save. Please try again." (keeps the sheet open with data) |

### 14.6 Accessibility
- Dynamic Type up to AX5 without clipping critical actions.
- VoiceOver labels on every chip ("Mexican, selected"), stamp ("Peruvian, Bronze stamp" / "not collected") and progress bar.
- Contrast ≥ 4.5:1 for text. State isn't conveyed by color alone (checkmarks, dashed borders).
- Respects Reduce Motion: celebrations fade instead of springing.
- Tap targets ≥ 44 pt.

### 14.7 Localization
- English (US) for the MVP. All strings go in String Catalogs, ready for localization.
- Dates and times follow the device locale. The week starts Monday by design (documented in recap copy).

---

## 15. Data and technical design

### 15.1 Architecture
- **SwiftUI** app, **iOS 17+**, iPhone portrait.
- **SwiftData** local store. Models are CloudKit-compatible (all properties defaulted or optional, no unique constraints) for F-18.
- **Game engine:** a pure Swift module with no UI dependencies. Takes all entries and returns game state (XP, level, stamps, badges, quests). It is deterministic and unit-tested. Progress is **derived, not stored**, so it can never drift from entries.
- **Project:** generated with XcodeGen (`project.yml`). Unit tests in `BiteLogTests`.
- **No backend** in the MVP.

### 15.2 Data model

```text
FoodEntry (SwiftData @Model)
  id             UUID
  date           Date            // editable; supports back-fill
  title          String          // "" allowed if photo present
  photoData      Data?           // external storage, ≤1600px JPEG
  thumbnailData  Data?           // external storage, ~400px
  hasPhoto       Bool
  sourceRaw      String?         // FoodSource
  cuisineRaws    [String]        // [Cuisine]
  foodTypeRaws   [String]        // [FoodType]
  mealRaw        String          // MealType
  ratingRaw      String?         // Rating
  companionsRaw  String?         // Companions
  placeName      String          // free text (P0); P1 adds placeId, lat, lng
  note           String

Static catalogs (code): FoodSource, MealType, FoodType, Rating, Companions, Region, Cuisine(44+fusion)
Derived (not stored): GameState { xp, level, stats, stamps, badgesUnlocked, questsCompleted, currentQuests }
UserDefaults: questRerolls { weekKey: Int }, hasOnboarded, reminder settings, lastRecapShownWeek
```

### 15.3 Performance budgets

| Metric | Budget |
|---|---|
| Cold start to interactive Today | < 1.5 s on iPhone 12 |
| Game state recalculation with 2,000 entries | < 50 ms (cache per change if exceeded) |
| Save to celebration visible | < 1 s |
| Storage per photo entry | ≤ ~400 KB |

### 15.4 Offline and reliability
- Fully functional offline.
- Saves use SwiftData autosave plus explicit save after commit.
- No data loss on app kill after Save returns.

### 15.5 Device and OS support
- iOS 17.0+. iPhone SE (2nd gen) and newer. Portrait only.
- Simulator support without a camera (Library and name only).

### 15.6 Dependencies (third party)
- **None** in the MVP (Apple frameworks only).
- Optional: a privacy-focused analytics SDK (§17). Decision needed.

---

## 16. Privacy, safety and compliance

| Area | Requirement |
|---|---|
| Data storage | On-device only in the MVP. iCloud private database in P1 (user's own account) |
| Accounts | None |
| Photos | Requested only when used. Limited library access supported. Processed on device |
| Data rights | CSV export and delete-all in Settings |
| App Privacy label | MVP target: **"Data Not Collected"**. If opt-in analytics are added: "Usage Data, not linked to you" |
| Privacy policy | Required URL before submission (simple hosted page) |
| Health claims | None in app or store copy. Category: **Food & Drink** (not Health & Fitness) to avoid diet framing |
| Safety | Guardrails FR-11. Eating-disorder resources in Settings. Copy checklist §14.4 |
| Age rating | 4+ (no user-generated public content, no web access) |
| Notifications | Local only, opt-in, ≤ 3/day |

---

## 17. Analytics and instrumentation

**Principle:** measure enough to learn, without tracking people.

- **TestFlight beta:** opt-in anonymous analytics (privacy-focused SDK such as TelemetryDeck, or a self-hosted endpoint). No personal identifiers, no photos, no free-text content.
- **Public MVP:** analytics off by default, with an opt-in toggle. Or ship with no analytics and rely on App Store Connect metrics and in-app surveys. **Decision needed (§25).**

| Event | Properties (no free text) | Supports metric |
|---|---|---|
| `app_open` | days_since_install | Retention |
| `onboarding_complete` | — | Activation funnel |
| `entry_saved` | has_photo, n_tags, source, cuisine_count, is_backfill, via (manual / again) | G1, G3 |
| `entry_log_duration` | seconds (sheet open → save) | G1 |
| `reward_shown` | type (stamp / tier / badge / quest / level) | G3 |
| `quest_completed` | quest_id, difficulty | G3 |
| `quests_shuffled` | — | Quest tuning |
| `recap_viewed` | week_offset | G3 |
| `share_exported` | card_type, include_photo | G4 |
| `reminder_opt_in` | windows_count | G1 |
| `notification_opened` | window | G1 |
| `safety_survey` | response (1–5) | G5 |

---

## 18. Success metrics

| Type | Metric | Definition | Beta target | Launch +90 days target |
|---|---|---|---|---|
| ⭐ North Star | **Weekly active loggers** | Users with entries on ≥ 4 days in a week | Growing week over week | Growing week over week |
| Activation | 48-h activation | % of new users with ≥ 3 entries within 48 h of install | ≥ 50% | ≥ 45% |
| Retention | D7 / D30 | % of installs with ≥ 1 entry on day 7 / day 30 | ≥ 40% / ≥ 20% | ≥ 30% / ≥ 15% |
| Effort | Log time | Median seconds from sheet open to save, photo-only | ≤ 5 s | ≤ 5 s |
| Engagement | Tag rate | % of entries with source + cuisine | ≥ 60% | ≥ 55% |
| Engagement | Quest completion | % of weekly active users completing ≥ 1 quest | ≥ 35% | ≥ 30% |
| Growth | Share rate | Share exports / weekly active users / month | ≥ 0.3 | ≥ 0.3 |
| Quality | Rating | App Store average | n/a | ≥ 4.5★ |
| 🛡️ Guardrail | Guilt/anxiety | % agreeing "makes me feel guilty or anxious" (in-app survey after 14 days) | ≤ 5% | ≤ 5% |
| 🛡️ Guardrail | Compulsive use | % of users opening > 20×/day | ≤ 2% | ≤ 2% |

---

## 19. Release plan

> **Timeline correction:** earlier drafts aimed for a year-end 2026 recap. It's 17 Nov 2026, and validation plus the MVP take about 8–10 weeks, so **Bite Wrapped moves to December 2027**. Monthly recaps launch with the public release.

| Phase | Dates (target) | Scope | Exit criteria |
|---|---|---|---|
| **0. Validate** | 17 Nov – 30 Nov 2026 | Hand-gather Reddit quotes (App. B). 5 interviews (App. C). Clickable prototype test (Quick log, Passport, quest) | ≥ 4/5 testers understand the Passport and log a photo in ≤ 5 s. PRD v1.0 approved |
| **1. MVP build** | 1 Dec 2026 – 22 Jan 2027 | F-01 to F-12, onboarding, settings | All P0 acceptance criteria pass. Release criteria below |
| **2. Private beta** | 25 Jan – 5 Mar 2027 | TestFlight, 20–50 users (include 1–2 intuitive-eating users) | D7 ≥ 40%, guilt guardrail ≤ 5%, crash-free ≥ 99.5% |
| **3. P1 + public launch** | Mar – Apr 2027 | F-13 to F-18 (monthly recap included), App Store submission | Store approval, launch checklist |
| **4. Grow** | May – Nov 2027 | P2 items based on data, optional Bite+ | — |
| **5. Bite Wrapped** | Dec 2027 | Yearly recap | Share rate spike |

### 19.1 Release criteria (MVP to beta)
- [ ] All P0 acceptance criteria pass
- [ ] Unit tests for the game engine pass. Manual test plan done on 2 device sizes
- [ ] Crash-free sessions ≥ 99.5% in internal testing
- [ ] Copy checklist (§14.4) reviewed on every screen and notification
- [ ] Accessibility pass (VoiceOver walkthrough of UJ1–UJ4, Dynamic Type AX3)
- [ ] Privacy policy published. Privacy label filled
- [ ] Performance budgets (§15.3) met with 2,000 seeded entries

---

## 20. Go-to-market

| Element | Plan |
|---|---|
| App Store name | "Bite Log: Food Passport" (subject to name decision) |
| Subtitle | "Fun food journal. No calories." |
| Keywords | food journal, food diary, cuisine, restaurant log, foodie, meal photo, takeout, cooking |
| Category | Food & Drink (primary), Lifestyle (secondary) |
| Screenshots | 1) Passport stamps 2) 5-second log 3) Quest complete 4) Weekly recap 5) "No calories. Ever." |
| Launch channels | TikTok and Instagram food creators (share-card format). Reddit communities where self-promotion is allowed (r/iosapps, r/SideProject, r/foodies), following each subreddit's rules. Product Hunt |
| Hooks | "How many cuisines have you tried?" passport challenge. Monthly recap shares |
| Beta recruitment | Friends, a foodie group chat, Instagram story call-out |

---

## 21. Monetization

**Principles:** core logging, the Passport, quests and badges, history and export are **free forever**. No ads. No limits on photos or history.

| Option (post-launch) | Contents | Price hypothesis |
|---|---|---|
| **Bite+** (optional subscription) | Custom stamp themes and app icons, Wrapped extras and alternate card designs, advanced stats and filters, unlimited personal ranking lists, early seasonal events | ~$2.99/mo or ~$19.99/yr |
| One-time "Supporter" unlock | Cosmetic thank-you pack | ~$4.99 |

Decide after launch, based on retention and user requests. **Not in the MVP.**

---

## 22. Dependencies

| Dependency | Needed for | Status |
|---|---|---|
| Mac with Xcode 15+ | Build | ✅ Owner has a Mac |
| Apple Developer Program ($99/yr) | TestFlight, App Store, iCloud (F-18) | ☐ To purchase before Phase 2 |
| Privacy policy hosting | App Store submission | ☐ |
| App icon and screenshots | Store listing | ☐ Design needed |
| Analytics vendor (optional) | §17 | ☐ Decision |

---

## 23. Risks, assumptions and validation

| # | Assumption / risk | If wrong | Test | Phase |
|---|---|---|---|---|
| A1 | Cuisine collecting feels fun, not childish | Core hook fails | Prototype test plus interviews | 0 |
| A2 | Tags are fast enough for ≥ 60% tag rate | Passport and quests feel empty | Beta metric. Usability timing | 0–2 |
| A3 | Rewards don't trigger anxiety | Harm, bad reviews | Guardrails, safety survey, intuitive-eating beta testers | 2 |
| A4 | Reminders + rewards lift D7 far above the 3% benchmark | Same fate as F1 | Beta D7 | 2 |
| A5 | Users share stamps and recaps | Slow growth | Share metric | 2–3 |
| A6 | 44 cuisines is the right size (not too few or too many) | Passport too easy or too hard | Beta: stamps per user at D30 | 2 |
| R1 | Camera-roll access feels invasive | F-13 unused | Opt-in, on-device, clear copy | 3 |
| R2 | Scope creep delays launch | Missed timeline | Cut order: F-16 → F-15 → F-14 | 1–3 |
| R3 | App Review flags health framing | Delay | Food & Drink category, no health claims | 3 |
| R4 | Recomputing game state is slow at scale | Laggy UI | Performance budget. Add caching | 1 |

---

## 24. Open questions

| # | Question | Default if no answer |
|---|---|---|
| Q1 | Should F-13 camera-roll catch-up move into P0? It's strong against forgetting (54%) but adds ~1–2 weeks | Keep as P1 |
| Q2 | Analytics: opt-in anonymous SDK, or none? | Opt-in for beta only |
| Q3 | Final app name? | "Bite Log" working name |
| Q4 | Should cuisine taxonomy allow user-added cuisines? | No (keeps Passport finite) |
| Q5 | Week start Monday for everyone, or follow locale? | Monday |
| Q6 | Include "Fusion" stamps or keep it as a tag only? | Tag only |

---

## 25. Decisions needed for approval

1. ☐ **Positioning and personas** (§5): Ellie and Casey primary, Riley shaping the safety rules.
2. ☐ **Goals and non-goals** (§3).
3. ☐ **MVP scope** (§9, P0 = F-01 to F-12), and Q1 (camera-roll catch-up in P0?).
4. ☐ **Guardrails as launch-blocking** (§11.11).
5. ☐ **Timeline** (§19), including moving Bite Wrapped to Dec 2027.
6. ☐ **Phase 0 validation before build** (recommended) or skip.
7. ☐ Answers or defaults for **Q2–Q6** (§24).

> **Existing code:** a v0.1 prototype already in the repo covers much of P0 (logging, tags, Again, Passport, XP, badges, quests, history, onboarding, CSV export). It is missing reminders (F-04), the weekly recap (F-09), the recap share card, the support-resources link, and the copy review. After approval, I'll audit it against this PRD and close the gaps. **No code changes until then.**

---

## Appendix A: Glossary

| Term | Meaning |
|---|---|
| Entry / bite | One logged meal, snack or drink |
| Source | Where the food came from (home-cooked, restaurant, takeout…) |
| Stamp | Passport item earned the first time you log a cuisine |
| Tier | Bronze / Silver / Gold level of a stamp |
| Quest | One of three weekly challenges |
| Back-fill | Logging a meal for an earlier time |
| WAU | Weekly active users |
| D7 / D30 | Share of users still logging 7 / 30 days after install |

## Appendix B: Community research to add by hand
Reddit blocks automated tools. Search these and paste 5–10 representative quotes per row into this table:

| Community | Search terms | Quotes |
|---|---|---|
| r/loseit, r/MyFitnessPal | "quit tracking", "tired of logging", "forgot to log" | |
| r/intuitiveeating, r/EDAnonymous | "calorie app anxiety", "food journal without numbers" | |
| r/food, r/foodies, r/AskNYC (or your city) | "app to remember restaurants", "track what I ate" | |
| r/EatCheapAndHealthy, r/personalfinance | "stop ordering takeout", "cook more" | |
| r/apple, r/iosapps | "Beli", "food diary app" | |

## Appendix C: Interview guide (30 min, 5 participants)
**Screener:** ages 20–35, iPhone users. Mix of 2 who photograph food often, 2 who quit a tracking app, and 1 who tries to cook more.

1. Walk me through what you ate yesterday and where it came from.
2. Do you photograph your food? What happens to those photos afterward?
3. Have you ever tracked food? What did you use, and why did you stop? (Dig into the moment.)
4. Did tracking ever make you feel bad? How?
5. How many cuisines do you think you've tried this year? Would you want to know?
6. *(Show prototype)* Log your last meal. *(Time it, watch for hesitation.)*
7. *(Show Passport, a quest, a recap)* What's your first reaction? Fun, or cringe? What would make you open this next week?
8. Would you share any of these? Where?
9. What would make you delete this app?

## Appendix D: Sources
- Cordeiro et al., *Rethinking the Mobile Food Journal*, CHI 2015: [PDF](https://homes.cs.washington.edu/~jfogarty/publications/chi2015-decaf.pdf)
- Big Think, *Why so many people quit food logging apps in the first week*: [link](https://bigthink.com/surprising-science/why-so-many-people-quit-food-logging-apps-in-the-first-week/)
- Self-monitoring adherence: [PMC8900900](https://pmc.ncbi.nlm.nih.gov/articles/PMC8900900), [PMC6416539](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6416539/), [PMC6856872](https://pmc.ncbi.nlm.nih.gov/articles/PMC6856872)
- Yale Insights, *When counting calories, words are more valuable than pictures*: [link](https://insights.som.yale.edu/insights/when-counting-calories-words-are-more-valuable-than-pictures)
- Calorie apps and eating disorders: [UKY](https://aes.as.uky.edu/bibcite/reference/27230), [The Swaddle](https://theswaddle.com/health-tracking-apps-provide-a-worrying-pipeline-to-eating-disorders-better-tech-design-can-fix-that/), [TDP](https://tdp-frontend.pages.dev/article/2026-03-20-the-promise-and-pitfall-of-food-tracking-apps-5cb17704), [The Nightly](https://thenightly.com.au/lifestyle/food/sarah-di-lorenzo-are-food-tracking-apps-helping-or-harming-your-health-what-to-know-before-using-tech-tools-c-20967183)
- MyFitnessPal community, *Why I stopped counting calories*: [link](https://community.myfitnesspal.com/en/discussion/comment/37254330)
- Duolingo streaks: [case study](https://jiwonvyoo.github.io/portfolio/case/duolingo/duo.html), [uxdesign.cc](https://uxdesign.cc/3-reframing-streaks-on-duolingo-5-ideas-for-a-more-healthy-and-flexible-approach-to-language-8fd89545771e)
- Untappd: [Wikipedia](https://en.wikipedia.org/wiki/Untappd), [arXiv 2601.04841](https://arxiv.org/html/2601.04841v1), [Brews News](https://brewsnews.com.au/the-anti-social-social-beer-app)
- Spotify Wrapped: [Music Business Worldwide](https://www.musicbusinessworldwide.com/spotify-wrapped-campaign-hit-200m-engaged-users-in-24-hours-a-19-yoy-increase), [WDEF](https://www.wdef.com/?p=2271401)
- Gen Z dining: [YouGov](https://yougov.com/en-gb/articles/55399-how-gen-z-consumers-eat-out-in-2026-attitudes-restaurant-types-and-discovery-drivers), [Morning Consult](https://pro.morningconsult.com/analysis/gen-z-restaurant-research)
- App stores: [See How You Eat](https://apps.apple.com/app/food-diary-see-how-you-eat-log/id940579920), [Beli](https://apps.apple.com/app/id1478375386), [Beli review analysis](https://www.onclarity.com/leaderboard/insight/belibeli), [Thirty Plants](https://apps.apple.com/app/id6447438431), [FoodyLife](https://apps.apple.com/app/id1350599517), [Shutterbite](https://apps.apple.com/us/app/-/id1592843782), [Stop Takeout](https://apps.apple.com/us/app/-/id6757351663)
- Community mirrors: [r/nutrition thread](https://pol1.lr.ggtyler.dev/r/nutrition/comments/1g4sl22/weekly_personal_nutrition_discussion_all_personal/lsfkbf2/?context=3), [r/personalfinance "cook more often"](https://lr.eu.psf.lt/r/personalfinance/comments/15fbxsb/30day_challenge_8_cook_more_often_august_2023)
