# PRD: Bite Log, a fun food journal for iPhone

| | |
|---|---|
| **Status** | 🟡 **Draft, awaiting approval.** No new build work starts until this is approved |
| **Last updated** | 2026-11-16 |
| **Platform** | iPhone (iOS 17+), public App Store release |
| **One-liner** | A food journal that feels like collecting stamps, not counting calories |

> **How to read this:** §1–3 cover what we learned and why. §4–7 cover who it's for and what problems we solve. §8–10 list the features and the first release. §11–14 cover metrics, roadmap, risks and the decisions I need from you.

---

## 1. Research method and limits

| Source type | What we used | Notes |
|---|---|---|
| Peer-reviewed / academic | CHI 2015 food-journal survey (141 past journalers), dietary self-monitoring trials (JMIR, PMC), Yale SOM photo-vs-text study, calorie-app and eating-disorder survey (1,357 adults), Untappd gamification paper (2026) | Strongest evidence |
| App store reviews | See How You Eat, Beli, Thirty Plants, FoodyLife, Shutterbite, Stop Takeout | Shows what users of today's apps love and hate |
| Community posts | MyFitnessPal community forum threads, r/nutrition and r/personalfinance threads found through search mirrors, Duolingo streak case study summarizing Reddit posts | ⚠️ **Reddit blocks automated reading.** We could not read Reddit threads directly, so Reddit evidence here is second-hand. **Recommended:** spend 30 minutes reading r/loseit, r/intuitiveeating, r/foodtracking, r/EatCheapAndHealthy and r/food yourself, and add quotes to Appendix A |
| Market data | YouGov and Morning Consult Gen Z dining surveys, Spotify Wrapped engagement numbers | Sizing and positioning |

Sources are listed in Appendix B.

---

## 2. Key research findings

### F1. Almost everyone quits food logging, and fast
- In a study of a **photo-based** food journal app, only **about 3% of ~190,000 downloads were still in use after one week** ([Big Think](https://bigthink.com/surprising-science/why-so-many-people-quit-food-logging-apps-in-the-first-week/)).
- In app-based programs, consistent tracking fell **from 68% in week 1 to 21% by week 12**. In another study it fell from 6 days a week to 2. Diet logging lasted a **median of 10 weeks** before people stopped ([PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC8900900), [PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6416539/)).
- **Implication:** logging with a photo alone did *not* fix retention in the study above. People need a **reason to come back**, not just fewer taps.

### F2. Why people miss entries (CHI 2015, 141 past journalers)
- **54% simply forgot.**
- **40% skipped foods that were too hard to enter.**
- **40% didn't know what was in the meal.**
- **20% didn't want to log in front of friends.**
- Some people **changed what they ate** to make logging easier: *"I just avoided eating things that were hard to log."*
- Paper journalers lasted a median of 2–3 months. People using apps lasted 7–12 months.
- **Implication:** never require ingredients or portions. Help people remember. Let them log later, quietly.

### F3. Photos make logging easier but need a little structure
- **46% of respondents found photos easier** for judging a meal, versus 22% for nutrition labels (CHI 2015).
- A Yale study found people **followed through less with photo-only logging** than with typed logging ([Yale Insights](https://insights.som.yale.edu/insights/when-counting-calories-words-are-more-valuable-than-pictures)).
- **Implication:** photo first, plus **one-tap tags** (source, cuisine). Tags take no effort, and they are what make insights and game rewards possible.

### F4. Calorie apps can cause real harm, and so can game mechanics
- **71% of 1,357 adults** had used a calorie tracking app. **More than a third** said it contributed to disordered-eating symptoms such as food preoccupation and all-or-nothing thinking. Badges and daily streaks were named as possible triggers ([UKY reference](https://aes.as.uky.edu/bibcite/reference/27230), [The Swaddle](https://theswaddle.com/health-tracking-apps-provide-a-worrying-pipeline-to-eating-disorders-better-tech-design-can-fix-that/)).
- A MyFitnessPal forum user: *"feel like a slave to the app"* ([MFP community](https://community.myfitnesspal.com/en/discussion/comment/37254330)).
- Database calorie values can be badly off, e.g. **+49% for beef pho, −76% for pearl milk tea** ([TDP](https://tdp-frontend.pages.dev/article/2026-03-20-the-promise-and-pitfall-of-food-tracking-apps-5cb17704)).
- **Implication:** no calories is a feature in its own right. Game mechanics must reward **variety and curiosity, never amount or restriction**.

### F5. Losing a streak is a common reason people quit
- Reddit users *"repeatedly report abandoning the app after losing a long streak"*. Once a streak breaks, people feel there's *"nothing left to lose"* ([Duolingo case study](https://jiwonvyoo.github.io/portfolio/case/duolingo/duo.html)).
- **Implication:** no daily streaks that reset to zero. Use weekly goals and totals that only go up.

### F6. Collecting things works, if it rewards the right behavior
- Untappd built a large, loyal audience with badges for **unique beers, countries and styles**. Researchers flag badges for *quantity* as ethically grey ([arXiv 2601.04841](https://arxiv.org/html/2601.04841v1), [Wikipedia](https://en.wikipedia.org/wiki/Untappd)).
- **Implication:** a "cuisine passport" (badges for unique cuisines and places) is a proven mechanic, applied to food variety.

### F7. Personal recaps spread themselves
- Spotify Wrapped 2025: **200M engaged users and 500M shares in 24 hours**. In 2024, shares were up 41% year over year ([Music Business Worldwide](https://www.musicbusinessworldwide.com/spotify-wrapped-campaign-hit-200m-engaged-users-in-24-hours-a-19-yoy-increase)).
- The niche app Thirty Plants already added a "2025 wrapped" ([App Store](https://apps.apple.com/app/id6447438431)).
- **Implication:** a year-end recap is our main way to grow. It needs to ship before December.

### F8. The audience wants to explore food
- **74% of Gen Z like trying new foods and cuisines** ([YouGov](https://yougov.com/en-gb/articles/55399-how-gen-z-consumers-eat-out-in-2026-attitudes-restaurant-types-and-discovery-drivers)). **About 1 in 5 tried 5 or more new restaurants in the last month** ([Morning Consult](https://pro.morningconsult.com/analysis/gen-z-restaurant-research)).
- But **69% see eating out as a treat**. Everyday meals are mostly home-cooked or takeout, so the app must make *all* meals count, not just restaurants.

### F9. Gaps in existing apps

| App | What users like | What users complain about / what's missing |
|---|---|---|
| **See How You Eat** (photo diary) | "simple, easy to use", visual, PDF export | Limit on photos per day, **history capped at 91 days**, "annoying" upgrade prompts, dated UI ("looks like a scam website"), no game or insights |
| **Beli** (restaurant ranking) | Rankings by head-to-head comparison, social lists. 4.86★ | **Restaurants only**, no home or takeout meals. $79.99/yr tier. Complaints about notifications and becoming "more commercialized". Users want **"lists to rank restaurants based on cuisine"** |
| **MyFitnessPal / calorie apps** | Huge database | Slow logging, guilt, paywalls, can trigger disordered eating |
| **Thirty Plants** | Plant-variety goal, has a "wrapped" | Single purpose, no cuisines or meals |
| **Stop Takeout** | Accountability for ordering less takeout | Single purpose, framed around guilt |
| **FoodyLife / Shutterbite / FoodView** | "No calories" photo diaries | Commodity apps: a diary with no reason to return |

**White space:** an app that covers **every meal** (home, takeout, restaurant), stays **photo-light and calorie-free**, and adds **Untappd-style collecting plus a Wrapped-style recap**. No current app combines these.

---

## 3. Strategy context
- **Goal (year 1):** launch on the App Store, reach day-30 retention of 20% or more, and create a share loop through recaps.
- **Business model:** free core features. An optional subscription later (§12). Core logging is never paywalled, since paywalled basics are a top complaint (F9).
- **Why now:** fatigue with calorie apps (F4), people open to apps without calories (several "no calorie" diaries exist but none has a hook), Wrapped culture (F7), and Gen Z's curiosity about food (F8).

---

## 4. Positioning

> **For** curious eaters who photograph their food and like trying new things,
> **who** have quit calorie apps or never wanted one,
> **Bite Log is** a food journal for iPhone
> **that** turns every meal, whether home-cooked, takeout or restaurant, into stamps, quests and a yearly recap worth sharing.
> **Unlike** MyFitnessPal (counting and guilt) or Beli (restaurants only),
> **we** celebrate variety and discovery across all your meals, with no numbers to hit.

---

## 5. Proto-personas

### P1. "Explorer Ellie" (primary)
- 24, lives in a city, eats out or orders in 3–5 times a week, **already photographs food for Instagram**.
- **Wants:** a record of what she ate and where, plus bragging rights for trying new things.
- **Frustrations:** camera roll full of food photos with no structure. Beli covers only restaurants.
- **Hook:** Passport, map, rankings, Wrapped.

### P2. "Curious Casey" (primary)
- 29, busy, suspects they order too much takeout. **Tried MyFitnessPal and quit in week 2.**
- **Wants:** an honest picture of their habits (home vs. takeout, how varied their meals are) **with no calories**.
- **Frustrations:** logging took too long, forgot meals, guilt.
- **Hook:** 5-second logging, home-vs-out split, gentle weekly quests ("cook 1 dinner").

### P3. "Recovering Riley" (secondary, shapes the guardrails)
- 31. Calorie tracking became obsessive, and now Riley follows intuitive eating.
- **Wants:** mindful awareness and fun **without numbers, red warnings or streak pressure**.
- **Hook:** a no-calories promise, a neutral tone, nothing that punishes missed days.
- **Design rule:** if a feature would make Riley anxious, we don't ship it.

*(Home cooks and people tracking symptoms are later segments.)*

---

## 6. Jobs to be done

| # | When… | I want to… | So I can… | Type | Persona |
|---|---|---|---|---|---|
| J1 | I'm about to eat or just finished | capture it in a few seconds, even with friends around | keep my journal without effort or awkwardness | Functional | All |
| J2 | I forgot to log a meal | catch up easily later (from my photos or a quick prompt) | not feel my journal is "ruined" | Functional / Emotional | Casey, Riley |
| J3 | I try a new cuisine or restaurant | feel that it counted | feel adventurous and proud | Emotional | Ellie |
| J4 | I wonder about my habits | see how often I cook vs. order, and how varied my meals are | make small changes without guilt | Functional | Casey |
| J5 | I want to cook more or try new things | get small, doable challenges | build the habit in a fun way | Functional / Emotional | Casey, Ellie |
| J6 | A friend asks "where was that great ramen?" | find it instantly | recommend it and remember it | Functional / Social | Ellie |
| J7 | It's the end of the month or year | see a fun recap of my food life | reminisce and share it | Social / Emotional | Ellie |
| J8 | I had a bad food day | log without judgment | not avoid the app | Emotional | Riley, Casey |

---

## 7. Problem statement

**Problem:** People who want to understand and enjoy their eating habits keep quitting food journals within weeks. Logging feels like a chore (forgetting, hard-to-enter meals, logging in public). The apps give nothing back. Calorie-first apps add guilt and can encourage disordered eating.

**How might we** make keeping a food journal so easy and so rewarding that people *want* to log every meal, home-cooked, takeout or restaurant, without counting anything?

### Ranked pain points

| # | Pain point | Evidence | Severity | Jobs |
|---|---|---|---|---|
| PP1 | **No payoff.** Logging gives back nothing fun or useful, so the habit dies | F1 (3% at week 1), F9 (commodity diaries) | 🔴 Critical | J3, J4, J7 |
| PP2 | **Forgetting** to log | F2 (54%) | 🔴 Critical | J1, J2 |
| PP3 | **Logging is slow or hard** (unknown ingredients, mixed dishes, database search) | F2 (40% / 40%), F4 | 🔴 Critical | J1 |
| PP4 | **Guilt, numbers, anxiety** | F4 (>1/3 report harm) | 🔴 Critical | J8 |
| PP5 | **Streak loss leads to quitting** | F5 | 🟠 High | J2, J8 |
| PP6 | **Restaurant apps ignore everyday meals**, and diaries ignore discovery | F8, F9 (Beli) | 🟠 High | J3, J4 |
| PP7 | **Food memories are unorganized** (camera roll chaos, "what was that place?") | F9, persona interviews (to validate) | 🟡 Medium | J6 |
| PP8 | **Social awkwardness** logging at the table | F2 (20%) | 🟡 Medium | J1, J2 |
| PP9 | **Paywalls, ads, limits** on basic features | F9 (history cap, upgrade prompts) | 🟡 Medium | All |

---

## 8. From opportunities to features

```
Desired outcome: people log most meals for 30+ days and enjoy it
├── O1 Make capture effortless           → PP2, PP3, PP8
│   ├── Photo-or-name entry, one-tap tags (no ingredients, ever)
│   ├── Camera-roll catch-up (log later, quietly)
│   ├── "Again" re-log of frequent meals
│   └── Gentle meal-time reminder + Lock Screen / Home Screen widget
├── O2 Give a reason to come back         → PP1, PP6
│   ├── Food Passport (cuisine stamps, tiers)
│   ├── Weekly quests (adaptive)
│   ├── XP / levels / badges for variety
│   └── Discovery moments ("first time trying Peruvian!")
├── O3 Turn logs into insight & memory    → PP1, PP7, J4, J6
│   ├── Weekly recap card (home vs. out, cuisines, top dish)
│   ├── History search + filters; Food Map
│   └── Personal rankings ("my top ramen")
├── O4 Make it shareable                  → growth, J7
│   ├── Share cards (stamp, weekly recap)
│   └── Monthly recap + "Bite Wrapped"
└── O5 Keep it kind & safe                → PP4, PP5, PP9
    ├── No calories, no amount-based rewards, neutral copy
    ├── No daily streaks that reset; weekly progress + lifetime totals
    └── Free core, private by default, unlimited history
```

---

## 9. Features and priority (RICE-lite)

Scores: **Reach** (share of users who touch it), **Impact** (1–3), **Confidence** (from evidence), **Effort** (S/M/L). P0 = MVP, P1 = fast follow before Wrapped season, P2 = later.

| ID | Feature | Pain points / jobs | Reach | Impact | Conf. | Effort | **Priority** |
|---|---|---|---|---|---|---|---|
| F-01 | **Quick log**: photo *or* name, with optional one-tap tags | PP3, J1 | 100% | 3 | High | M | **P0** |
| F-02 | **Tag set**: source (home / restaurant / takeout / store-bought / cooked for me / event), cuisine (~44), food types, meal, rating, place | PP6, J4 | 100% | 3 | High | M | **P0** |
| F-03 | **"Again" one-tap re-log** | PP3 | 70% | 2 | High | S | **P0** |
| F-04 | **Gentle reminders** at the user's meal times, skipped if already logged | PP2 | 80% | 3 | High | S | **P0** |
| F-05 | **Back-fill**: log for earlier today or yesterday without penalty | PP2, PP5, J2 | 60% | 2 | High | S | **P0** |
| F-06 | **Food Passport** with Bronze / Silver / Gold tiers | PP1, PP6, J3 | 90% | 3 | Med-High | M | **P0** |
| F-07 | **Weekly quests** (3 per week, adapt to user, one shuffle) | PP1, J5 | 80% | 3 | Medium | M | **P0** |
| F-08 | **XP, levels, badges** (variety-based only) | PP1 | 90% | 2 | Medium | M | **P0** |
| F-09 | **Weekly recap card** (home vs. out, cuisines, top dish, quests) | PP1, J4 | 90% | 3 | High | S | **P0** |
| F-10 | **History**: search, filters, edit, delete | J6 | 70% | 2 | High | S | **P0** |
| F-11 | **Safety guardrails** (see §10.3) | PP4, PP5 | 100% | 3 | High | S | **P0** |
| F-12 | **Share card** (stamp and weekly recap as image) | Growth, J7 | 40% | 2 | Medium | S | **P0** |
| F-13 | **Camera-roll catch-up**: suggests today's food photos to log in one tap (on-device detection) | PP2, PP8, J2 | 60% | 3 | Medium | M | **P1** |
| F-14 | **Home / Lock Screen widget**: quick log and weekly progress | PP2 | 50% | 2 | High | M | **P1** |
| F-15 | **Place search (Apple Maps) + Food Map** | J6, PP7 | 60% | 2 | High | M | **P1** |
| F-16 | **Personal rankings** (head-to-head, per dish or cuisine) | J6, F9 gap | 40% | 2 | Medium | M | **P1** |
| F-17 | **Monthly recap + "Bite Wrapped"** (December) | Growth, J7 | 80% | 3 | High | L | **P1, by Dec** |
| F-18 | **iCloud sync / backup** | PP9 | 50% | 2 | High | M | **P1** |
| F-19 | **Variety challenges**: Eat the Rainbow / 30 plants | J5 | 30% | 2 | Medium | M | P2 |
| F-20 | Suggested dish / cuisine from photo (on-device ML) | PP3 | 100% | 2 | Low-Med | L | P2 |
| F-21 | Friends: compare passports, co-op quests (opt-in) | Growth | 30% | 2 | Low | L | P2 |
| F-22 | Takeout spend insight (optional price field) | J4 | 25% | 1 | Low | S | P2 |
| F-23 | Seasonal events (e.g. "Dumpling Week") | PP1 | 50% | 2 | Low | M | P2 |

**Won't build:** calories or macros, weight tracking, public leaderboards, quantity badges, diet plans, ads.

---

## 10. MVP (P0) requirements

### 10.1 User stories and acceptance criteria

**F-01 Quick log**
- *As Casey, I want to log a meal with just a photo so it takes seconds.*
- ✅ The entry sheet opens from the Today screen in 1 tap. The camera is reachable in 1 more tap.
- ✅ Saving needs **a photo or a name**. Nothing else is required.
- ✅ Meal type is pre-filled from the time of day.
- ✅ **Target:** photo-only log in ≤ 5 seconds (median in usability test).
- ✅ Photos are downscaled on device. History has no limit on photos or days.

**F-02 Tags**
- ✅ Source, cuisine, food types, rating and place are one-tap chips. Each shows the XP it earns.
- ✅ Recently used cuisines appear first. A searchable full list is available.
- ✅ Typing a place logged before fills in its cuisine.
- ✅ No ingredient, portion or nutrition fields anywhere.

**F-03 Again**
- ✅ Shows up to 8 frequent dishes from the last 30 days. One tap creates a new entry with the same tags, timed now.

**F-04 Reminders**
- ✅ Off by default. Offered after the user has logged 3 meals (not during onboarding).
- ✅ The user picks up to 3 meal windows. A reminder is skipped if a meal was already logged in that window.
- ✅ Copy is neutral (e.g. "What's on the plate? 🍜"). Never "You missed…".

**F-05 Back-fill**
- ✅ Date and time can be edited on any entry. Back-filled entries earn the same rewards.

**F-06 Passport**
- ✅ A stamp for each collectible cuisine, grouped by region, with count "N / 44".
- ✅ **Bronze** = tried it. **Silver** = 5 different dishes. **Gold** = Silver plus cooked at home once.
- ✅ First-time cuisine shows a celebration ("New stamp!").

**F-07 Weekly quests**
- ✅ Three quests every Monday (Easy / Medium / Adventure), chosen to be achievable for that user (e.g. takeout-heavy users get "cook 1 meal at home").
- ✅ One shuffle per week, allowed before any quest is complete.
- ✅ Unfinished quests simply expire. No penalty, no "failed" message.

**F-08 XP, levels, badges**
- ✅ XP comes from logging, tagging, firsts (new dish / place / cuisine) and quests. Logging XP is capped at 6 entries per day.
- ✅ About 20 badges, all for variety or exploration (e.g. Globetrotter, Home Chef, Hidden Gem Hunter). At least 1 secret badge.
- ✅ Progress is recalculated from entries, so edits and deletes keep it accurate.

**F-09 Weekly recap**
- ✅ Shown on first open each Monday and kept in history.
- ✅ Includes meals logged, home / takeout / restaurant split, cuisines (new ones highlighted), top-rated dish and quest results.
- ✅ Wording is descriptive, not judgmental ("You cooked 3 dinners" rather than "Only 3…").

**F-10 History**
- ✅ Grouped by day. Search across dish, place, cuisine and notes. Filter by source. Edit and delete.

**F-12 Share card**
- ✅ Exports a branded image of a stamp or weekly recap through the iOS share sheet. Meal photos are only included if the user chooses.

### 10.2 Onboarding (≤ 3 screens)
1. "Snap every bite": photo-first logging.
2. "Fill your Food Passport": stamps and quests.
3. "No calories. Ever.": the safety promise.

No account and no sign-up. The first log is the "aha" moment.

### 10.3 Guardrails (F-11), required for launch
1. No calorie, macro, weight or portion fields, and no imports of that data.
2. No reward for eating **more** or **less**. Every badge and quest is reachable on a normal diet.
3. No daily streak that resets. Use weekly dots that refresh each Monday, and lifetime totals that never go down.
4. No moral food words ("clean", "junk", "cheat", "bad").
5. No notification shames or nags. At most 3 a day, user-chosen, off by default.
6. App Store copy makes no health claims.

### 10.4 Non-functional
- **Privacy:** data on device by default. No account. Export (CSV) and delete-all in Settings. App Privacy label: "Data Not Collected" for the MVP, with analytics only if privacy-preserving and opt-in.
- **Performance:** Today screen loads in under 1 second with 2,000 entries.
- **Accessibility:** Dynamic Type, VoiceOver labels on stamps and chips, sufficient contrast.
- **Offline:** everything works offline.

---

## 11. Success metrics

| Type | Metric | MVP beta target | Why |
|---|---|---|---|
| North Star | **Weekly active loggers** (≥ 4 days logged per week) | Grow week over week | Habit health |
| Activation | % of new users with 3+ logs in their first 48 h | ≥ 50% | F1: week 1 decides everything |
| Retention | Day 7 / Day 30 logging retention | ≥ 40% / ≥ 20% | Beat the 3% week-1 benchmark (F1) |
| Effort | Median time to log, photo only | ≤ 5 s | PP3 |
| Engagement | % of entries with source + cuisine tagged | ≥ 60% | Shows the reward loop works (F3) |
| Engagement | Weekly quest completion (≥ 1 quest) | ≥ 35% of WAU | PP1 |
| Growth | Share-card exports per WAU per month | ≥ 0.3 | F7 |
| Safety | % of users rating "the app makes me feel guilty/anxious" as agree (in-app survey) | ≤ 5% | PP4 |

---

## 12. Roadmap

| Phase | Timing | Scope | Exit criteria |
|---|---|---|---|
| **0. Validate** | 1–2 weeks | Read Reddit communities (App. A). 5 interviews with Ellie and Casey types. Clickable prototype test of Quick log, Passport and a quest | ≥ 4/5 testers understand the Passport and log a photo in ≤ 5 s |
| **1. MVP (P0)** | 5–7 weeks | F-01 to F-12 | TestFlight beta with 20–50 users |
| **2. Beta learn** | 2–3 weeks | Measure §11 and fix friction | D7 ≥ 40% |
| **3. Launch + Wrapped (P1)** | Before December | F-13 to F-18, App Store launch | Launch, Wrapped shipped |
| **4. Later (P2)** | After launch | F-19 to F-23, optional "Bite+" subscription (themes, deeper stats, Wrapped extras; core stays free) | — |

---

## 13. Risks and assumptions

| # | Assumption / risk | Risk if wrong | How we test |
|---|---|---|---|
| A1 | People find cuisine collecting fun, not childish | Core hook fails | Prototype test plus interview reactions (Phase 0) |
| A2 | Tags feel quick enough that ≥ 60% of entries are tagged | Passport and quests feel empty | Beta metric |
| A3 | Game rewards don't trigger anxiety (Riley) | Harm and bad reviews | Guardrails, safety survey, include 1–2 intuitive-eating users in beta |
| A4 | Photo logging plus reminders lifts week-1 retention far above 3% | Same fate as F1 | Beta D7 |
| A5 | People will share stamps and recaps | Slower growth | Share-export metric |
| R1 | Camera-roll access feels invasive | Feature unused, trust lost | Opt-in, on-device only, clear copy |
| R2 | December deadline slips | Miss Wrapped season | Recap is P1 with a fixed date. Cut F-16 first |
| R3 | Apple review flags health claims | Delay | No health claims in copy |

---

## 14. Decisions I need from you

1. **Approve the positioning (§4) and personas (§5)?** Ellie and Casey primary, Riley shaping the guardrails.
2. **Approve the MVP scope (§9, P0 = F-01 to F-12)?** Or move something between P0 and P1. Candidates to pull into P0 are **F-13 camera-roll catch-up** (strong against forgetting, more effort) or **F-15 place search**.
3. **Guardrails (§10.3):** approve as hard launch requirements?
4. **Phase 0 validation:** run interviews and a prototype test first (recommended), or go straight to the MVP build?
5. **Name:** keep "Bite Log" as the working name, or explore names now?

> **Note on existing code:** an earlier v0.1 prototype is in the repo. After approval I'll compare it against this PRD and adjust it rather than start over. Until then, no code changes.

---

## Appendix A: Community research to add by hand
Search Reddit (Reddit blocks automated tools) and paste 5–10 quotes per topic:
- r/loseit, r/MyFitnessPal: "quit tracking", "tired of logging"
- r/intuitiveeating, r/EDAnonymous: "calorie app anxiety", "food journal without numbers"
- r/food, r/FoodPorn, r/AskNYC (or your city): "app to remember restaurants", "what I ate"
- r/EatCheapAndHealthy, r/personalfinance: "stop ordering takeout", "cook more"
- r/Beli (if present), r/apple: Beli and food app feedback

## Appendix B: Sources
- Cordeiro et al., *Rethinking the Mobile Food Journal*, CHI 2015: [PDF](https://homes.cs.washington.edu/~jfogarty/publications/chi2015-decaf.pdf)
- Big Think, *Why so many people quit food logging apps in the first week*: [link](https://bigthink.com/surprising-science/why-so-many-people-quit-food-logging-apps-in-the-first-week/)
- Self-monitoring adherence: [PMC8900900](https://pmc.ncbi.nlm.nih.gov/articles/PMC8900900), [PMC6416539](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6416539/), [PMC6856872](https://pmc.ncbi.nlm.nih.gov/articles/PMC6856872)
- Yale Insights, *When counting calories, words are more valuable than pictures*: [link](https://insights.som.yale.edu/insights/when-counting-calories-words-are-more-valuable-than-pictures)
- Calorie apps and eating disorders: [UKY](https://aes.as.uky.edu/bibcite/reference/27230), [The Swaddle](https://theswaddle.com/health-tracking-apps-provide-a-worrying-pipeline-to-eating-disorders-better-tech-design-can-fix-that/), [TDP](https://tdp-frontend.pages.dev/article/2026-03-20-the-promise-and-pitfall-of-food-tracking-apps-5cb17704), [The Nightly](https://thenightly.com.au/lifestyle/food/sarah-di-lorenzo-are-food-tracking-apps-helping-or-harming-your-health-what-to-know-before-using-tech-tools-c-20967183)
- MyFitnessPal community, *Why I stopped counting calories*: [link](https://community.myfitnesspal.com/en/discussion/comment/37254330)
- Duolingo streak case study: [link](https://jiwonvyoo.github.io/portfolio/case/duolingo/duo.html), [uxdesign.cc](https://uxdesign.cc/3-reframing-streaks-on-duolingo-5-ideas-for-a-more-healthy-and-flexible-approach-to-language-8fd89545771e)
- Untappd: [Wikipedia](https://en.wikipedia.org/wiki/Untappd), [arXiv 2601.04841](https://arxiv.org/html/2601.04841v1), [Brews News](https://brewsnews.com.au/the-anti-social-social-beer-app)
- Spotify Wrapped: [Music Business Worldwide](https://www.musicbusinessworldwide.com/spotify-wrapped-campaign-hit-200m-engaged-users-in-24-hours-a-19-yoy-increase), [WDEF](https://www.wdef.com/?p=2271401)
- Gen Z dining: [YouGov](https://yougov.com/en-gb/articles/55399-how-gen-z-consumers-eat-out-in-2026-attitudes-restaurant-types-and-discovery-drivers), [Morning Consult](https://pro.morningconsult.com/analysis/gen-z-restaurant-research)
- App store listings and reviews: [See How You Eat](https://apps.apple.com/app/food-diary-see-how-you-eat-log/id940579920), [Beli](https://apps.apple.com/app/id1478375386), [Beli review analysis](https://www.onclarity.com/leaderboard/insight/belibeli), [Thirty Plants](https://apps.apple.com/app/id6447438431), [FoodyLife](https://apps.apple.com/app/id1350599517), [Shutterbite](https://apps.apple.com/us/app/-/id1592843782), [Stop Takeout](https://apps.apple.com/us/app/-/id6757351663)
- Community mirrors: [r/nutrition thread](https://pol1.lr.ggtyler.dev/r/nutrition/comments/1g4sl22/weekly_personal_nutrition_discussion_all_personal/lsfkbf2/?context=3), [r/personalfinance "cook more often"](https://lr.eu.psf.lt/r/personalfinance/comments/15fbxsb/30day_challenge_8_cook_more_often_august_2023)
