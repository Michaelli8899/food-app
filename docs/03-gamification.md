# Gamification Design

> Goal: make logging **fun and rewarding** so people keep doing it, without calorie guilt, punishment, or unhealthy incentives.

## 1. Guardrails (what we will NOT reward)

Badly designed food gamification can encourage overeating, restriction, or anxiety. Rules:

- ❌ Never reward **eating more** or **eating less** (no "ate 5 meals today!", no "skipped dessert!").
- ❌ No streaks that **reset to zero**. Losing a 90-day streak is the #1 reason people quit habit apps.
- ❌ No public leaderboards on quantity.
- ❌ No moral labels ("clean", "junk", "cheat").
- ✅ Reward **logging, variety, curiosity, cooking, and reflection** (rating, noting).
- ✅ Every reward must be earnable by someone eating a perfectly normal diet.

---

## 2. The systems

### 2.1 🛂 Food Passport (signature feature)
- A stamp book with ~40 cuisines, grouped by world region.
- Log a dish tagged with a new cuisine and you earn a **stamp** with custom illustrated art, the date, the dish, and the place.
- A **world map** colours in regions as you collect.
- Region completion badges: "East Asia Explorer" (Japanese, Korean, Chinese, Taiwanese, Mongolian…).
- **Deeper levels per cuisine:** Bronze (1 dish) → Silver (5 different dishes) → Gold (5 dishes + cooked it at home once). This keeps the passport alive after the first 40 stamps.

### 2.2 ⭐ XP and levels
| Action | XP |
|---|---|
| Log an entry (photo or name) | +10 |
| Add source | +2 |
| Add cuisine | +3 |
| Add food types | +3 |
| Add rating | +2 |
| Home-cooked meal | +5 bonus |
| First time: new dish / place / cuisine | +15 / +20 / +50 |
| Complete a weekly quest | +100 |

- Levels have fun food titles: *Snack Rookie → Taste Tester → Flavor Scout → Spice Adventurer → Gourmet → Culinary Legend*.
- The XP curve should give the first 3 levels in week 1 (early wins), then slow down.
- A daily XP cap from logging (e.g. counts up to 6 entries/day) prevents spam-logging.

### 2.3 🏅 Badges (starter set of ~20)
| Badge | How to earn |
|---|---|
| First Bite | Log your first meal |
| Shutterbug | 25 meals with photos |
| Globetrotter I / II / III | 5 / 15 / 30 cuisines |
| Home Chef I / II / III | 10 / 50 / 150 home-cooked meals |
| Regular | Visit the same place 5 times |
| Hidden Gem Hunter | 10 different restaurants |
| Brunch Club | 5 brunches |
| Night Owl | 5 late-night snacks logged |
| Feel the Heat | 10 spicy dishes |
| Sea Legs | 10 seafood dishes |
| Plant Power | 50 plant-based meals |
| Rainbow Week | Logged all 5 food colours in one week |
| Leftover Legend | Re-logged the same home-cooked dish 3 days in a row |
| Critic | Rated 50 dishes |
| Comfort Classic | "Again" button used on the same dish 10 times |
| World Tour | One cuisine from every region |
| Year One | Logged in 12 different months |
- Also add **hidden badges** for surprise: "Pizza Purist" (pizza in 5 cities), "Midnight Ramen", "Birthday Feast".

### 2.4 🎯 Weekly quests
Three new quests every Monday: one easy, one medium, one "adventure". Users can reroll one per week.

Examples:
- *Easy:* Log 7 meals with photos · Rate 5 dishes · Log a breakfast 3 times
- *Medium:* Cook dinner at home 3 times · Eat 15 different plants · Try 2 cuisines this week
- *Adventure:* Try a cuisine you've never had · Visit a new restaurant · Cook a dish from a cuisine you've only eaten out

Quests adapt to the user. A takeout-heavy user gets "cook 1 meal at home", not 5.

### 2.5 📆 Consistency without punishment
- Show **"days logged this week: ●●●●○○○"**, which resets weekly so there's always a fresh start.
- An optional "Flame" counts **weeks** with at least 4 logged days, with 2 free "freeze" weeks per year.
- **Lifetime counters never go down** (total meals, total cuisines, total places).

### 2.6 🌈 Healthy-variety challenges (no calories)
- **Eat the Rainbow:** tag food colours (red, orange/yellow, green, purple/blue, white/brown) and fill the weekly ring.
- **30 Plants a Week:** count different plant foods (fruit, veg, grains, legumes, nuts, herbs). Gut-health research links plant variety to microbiome diversity, so it's a positive, popular challenge that isn't about restriction.

### 2.7 🏆 Personal rankings
- After rating a dish 🤩, ask "Better than your current #1 ramen?" (head-to-head comparison, like Beli).
- Builds lists such as "My Top 10 Tacos" and "Best Cafés". Shareable.

### 2.8 🎁 Recaps (the viral engine)
- **Weekly card** (Monday): cuisines this week, home vs. out split, top dish, quest results.
- **Monthly card:** new stamps, favourite place, most-cooked dish.
- **Bite Wrapped (December):** a story-style slideshow showing total meals, cuisines collected, #1 restaurant, "your food personality" (e.g. *The Spice Seeker*, *The Comfort Cook*, *The Brunch Royalty*), top-rated dish, map of places. One tap to share to Instagram Stories.

### 2.9 👥 Social (v2, opt-in)
- Follow friends and see their passports and new stamps (photos stay private unless shared).
- **Co-op quests:** "You and Alex: try 3 new cuisines together this month."
- "Taste twins": % overlap of cuisines with a friend.
- No public feed of everything you eat.

---

## 3. Reward moments (UX)
- **Haptics + confetti** on stamp unlocks, level-ups, and quest completions (keep XP ticks subtle).
- **Discovery overlay** for firsts: "🎉 First time eating Peruvian! Stamp 13/40".
- **Progress hints** on the Today screen: "1 more home-cooked dinner to finish your quest".
- Celebrate **meaningful** firsts big, everyday logging small. Too much confetti becomes noise.

---

## 4. Balancing and anti-cheating
- XP from logging is capped per day. Badges based on *distinct* items (cuisines, places) are naturally hard to farm.
- Since there's no public competition in the MVP, cheating only "hurts" the cheater, so keep checks light.
- Before social features launch, add sanity checks (e.g. a stamp needs a photo or a place).

---

## 5. Questions to test in research
1. Which hook excites people most: **Passport**, **Wrapped**, **quests**, or **rankings**? (Show sketches and ask them to rank.)
2. Do badges feel motivating or childish to the target audience?
3. Does tagging cuisine and food types feel fun with XP, or still like a chore?
4. Would people share passport or Wrapped cards publicly?
