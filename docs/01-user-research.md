# Food Diary App: User Research

> Status: **Draft, based on desk research.** No real users have been interviewed yet.
> Treat everything below as hypotheses. Section 7 has an interview guide and a survey to test them.

---

## 1. Research goals

1. Why do people start keeping a food diary, and what do they want to get out of it?
2. Why do most people **stop** within a few weeks?
3. What does a log entry need to contain to be useful (calories? photos? feelings? symptoms?)
4. What would make someone come back to the app every day without feeling guilty or nagged?

---

## 2. Method

| Method | What it gives us | Status |
|---|---|---|
| Desk research (published studies, app-store reviews, Reddit communities such as r/loseit, r/ibs, r/EatingDisorders, r/MacroFactor) | Recurring pain points and motivations | Done (summarized below) |
| Competitive teardown of 8 apps | What's already solved, where the gaps are | Done (Section 4) |
| Proto-personas | Draft segments to recruit for | Done (Section 5) |
| **5–8 user interviews** | Check or throw out the hypotheses | **To do.** Guide in Section 7.1 |
| **Short survey (n ≈ 30–100)** | Size the segments, rank the features | **To do.** Questions in Section 7.2 |
| **Your own 7-day diary study** | First-hand friction. Log everything you eat for a week in Notes or on paper, and write down every time logging felt annoying | **To do.** Cheapest research there is |

---

## 3. Key findings from desk research

### 3.1 Why people track food
- **Weight change** (lose, gain, or maintain). This is the largest group and the one most apps serve.
- **Symptom detective work**: IBS, bloating, migraines, eczema, acid reflux, suspected intolerances. Doctors and dietitians often *ask* patients to keep a food-and-symptom diary.
- **Performance / macros**: lifters and athletes who hit protein or carb targets.
- **Medical management**: diabetes (carbs vs. glucose), kidney disease, pregnancy.
- **Mindful or intuitive eating**: understanding *why* they eat (stress, boredom), not *how much*.
- **Budget and habits**: "How often am I ordering takeout?", "Am I eating enough vegetables?"
- **Memory and fun**: a visual journal of meals, restaurants, and recipes they liked.

### 3.2 Why people quit (the core problem)
Research on self-monitoring consistently finds that logging frequency drops sharply after the first 2–4 weeks. The recurring reasons:

1. **Logging is too slow.** Searching a database for "chicken stir fry from my mom" and estimating grams is tedious. Home-cooked and mixed dishes are the worst case.
2. **Inaccurate or crowdsourced data.** Duplicate and wrong entries in large food databases erode trust.
3. **Guilt and shame loops.** Red numbers and "over budget" warnings make people avoid logging on bad days. Those are exactly the days with the most useful data.
4. **No payoff.** Users log for weeks and the app never tells them anything they didn't already know.
5. **Paywalls and ads.** Barcode scanning and other basic features moved behind subscriptions in popular apps, and this is a frequent complaint in reviews.
6. **One forgotten meal breaks the streak**, and then the whole habit collapses ("what-the-hell effect").
7. **Mismatch of goals.** Calorie-first apps feel wrong to people who track for symptoms, mood, or mindfulness.

### 3.3 What helps people keep going
- **Very low-effort capture**: photo first, details later. Quick re-log of "the usual."
- **Partial logging still counts.** "Ate lunch, roughly a sandwich" beats nothing.
- **Small, frequent insights** ("You've had breakfast 6 of 7 days", "bloating was reported on 4 of 5 days you had dairy").
- **Neutral, non-judgmental tone.**
- **Gentle reminders tied to the user's real meal times**, not fixed alarms.

### 3.4 Ethical and safety considerations
- Calorie counting can make disordered eating worse. Safeguards: let users turn numbers off, avoid moral language ("good/bad food", "cheat"), and never celebrate extreme deficits.
- Health data is sensitive. Default to **local-first / private** storage, offer an easy export, and add no social feed by default.
- Symptom correlations aren't diagnoses. Wording should say "pattern worth discussing with a professional."

---

## 4. Competitive landscape

| App | Focus | Strengths | Weaknesses / gaps |
|---|---|---|---|
| MyFitnessPal | Calories and macros | Huge database, barcode scanning | Crowdsourced data errors, many features behind a paywall, ads, calorie-centric |
| Cronometer | Micronutrients | Accurate verified data, very detailed | Overwhelming for casual users, slow to log |
| Lose It! | Weight loss | Friendly UI, photo logging | Weight-loss-only framing |
| MacroFactor | Macros, adaptive coaching | Fast logging, smart targets, no-shame design | Subscription only, gym-focused |
| Yazio / FatSecret | Calories | Free tiers, recipes | Generic, ad-heavy |
| See How You Eat / Ate | Photo food journal, mindful eating | Very low friction, no numbers | Few insights, no symptom tracking |
| Cara Care / mySymptoms | Gut health and symptoms | Symptom correlation | Clinical feel, dated UX |
| Notes app / paper | Anything | Zero friction, total flexibility | No search, reminders, or insights |

**Opportunity:** no app combines **photo-first, low-friction logging**, **flexible "track what matters to *you*" modules** (numbers optional), and **simple, trustworthy pattern insights** such as food → mood, symptoms, or energy.

---

## 5. Proto-personas (to validate)

### A. "Curious Casey": habit and awareness tracker (likely primary)
- 20s–30s, busy, eats out often.
- *Goal:* "I just want to see what I actually eat and notice patterns."
- *Pain:* Tried MyFitnessPal and quit after a week because entering grams was too much work.
- *Needs:* Snap a photo in 3 seconds, weekly recap, no calorie guilt.

### B. "Symptom-Sleuth Sam": gut and health detective
- Has IBS-like symptoms or migraines. A doctor suggested keeping a food diary.
- *Goal:* "Find out what's triggering my bloating."
- *Pain:* Paper diary is hard to analyze. Calorie apps don't track symptoms.
- *Needs:* Log symptoms with severity and time, see food → symptom correlations, export a PDF for the doctor.

### C. "Macro Morgan": fitness-focused
- Lifts 4x/week and tracks protein.
- *Goal:* "Hit 140 g protein daily."
- *Pain:* Database errors, slow entry of repeat meals.
- *Needs:* Barcode scan, saved meals, macro targets.
- *Note:* Well served by existing apps. Probably **not** the segment to start with.

### D. "Mindful Mia": emotional-eating awareness
- *Goal:* "Understand why I snack at night."
- *Needs:* Hunger and fullness scale, mood and context tags, no numbers at all.

> **Working hypothesis:** Start with **Casey + Sam** (low-friction capture plus pattern insights), which is the clearest gap in the market. Mia's needs overlap with Casey's at almost no extra cost. Macros can be an optional module later.

---

## 6. Jobs to be done

- *When I eat something,* I want to **record it in seconds**, *so I don't lose the habit.*
- *When I feel bad (bloated, tired, headache),* I want to **note it quickly**, *so I can connect it to what I ate.*
- *At the end of the week,* I want to **see a simple summary**, *so I learn something without doing analysis myself.*
- *Before a doctor or dietitian appointment,* I want to **export a clean report**, *so the visit is productive.*
- *When I'm about to eat the same thing again,* I want to **re-log it in one tap.**
- *On a bad day,* I want to **log without judgment**, *so I don't avoid the app.*

---

## 7. Validation toolkit

### 7.1 Interview guide (30 min, 5–8 people)
Recruit a mix: 2–3 people who tracked food before and quit, 2 with digestive or other symptoms, 1–2 who never tracked.

**Warm-up (5 min)**
1. Tell me a bit about how you usually eat on a weekday.

**Past behaviour (10 min)**

2. Have you ever tracked what you eat? What did you use? Why did you start?
3. Walk me through the last time you logged a meal. What was annoying?
4. Why did you stop? (Dig into the moment it happened.)
5. Did tracking ever make you feel worse? How?

**Goals and value (10 min)**

6. If an app could tell you one thing about your eating, what would you want it to be?
7. Besides food, what else would you want to record? (Mood, energy, symptoms, sleep, water, cost, location?)
8. Would you share this data with anyone, such as a doctor, partner, or coach?

**Reactions (5 min)**

9. (Show a rough sketch of photo-first logging and a weekly recap.) What's your first reaction? What's missing? What would you never use?
10. What would make you pay for it, and what would make you delete it?

*Tips:* Ask about past behaviour, not hypotheticals. Ask "why" up to 5 times. Don't pitch.

### 7.2 Survey (Google Forms, about 3 min)
1. Have you ever tracked your food? (Never / Tried and stopped / Currently)
2. If you stopped, why? (Multi-select: too slow, felt guilty, forgot, inaccurate data, no useful insights, cost, other)
3. Main reason you'd track food? (Weight, symptoms/health, fitness, mindfulness, curiosity, budget, other)
4. Rank how much each would matter to you: photo logging, barcode scan, calorie counts, symptom tracking, mood tracking, weekly insights, doctor export, reminders, privacy/offline.
5. How long would you spend logging one meal, at most? (<10 s / 10–30 s / 30–60 s / >1 min)
6. Would you prefer to see numbers (calories/macros) or no numbers? (Numbers / No numbers / Let me choose)
7. Phone: iOS / Android.

### 7.3 What would change our direction
- If **most** respondents track for weight or macros and are happy with existing apps → reconsider the niche.
- If **symptom tracking** ranks top for a large share → make Sam the primary persona and lead with correlations.
- If acceptable logging time is **under 10 seconds** for most → photo-only capture becomes non-negotiable.
