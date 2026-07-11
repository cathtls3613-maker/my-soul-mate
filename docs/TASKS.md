# Tasks — my-soul-mate

## Sprint 1 — Database & Demo Browse
**Goal:** Anyone can open the app and see real profile cards from seed data.

- [ ] Run migration SQL (all tables + RLS v1 policies)
- [ ] Seed 5 demo profiles across 3 universities
- [ ] Build `/` browse page: profile card grid with photo, name, university, age
- [ ] Build `/profiles/[id]` detail page: full bio + interests
- [ ] Loading skeleton for cards
- [ ] Empty state: "No profiles yet — be the first!"
- [ ] Error state: "Something went wrong. Try refreshing."

**Definition of Done:** Visiting `/` in preview shows ≥5 profile cards from the database. Detail page loads. No console errors. Works without any login.

---

## Sprint 2 — Like & Match Engine ✅ v1 functional milestone
**Goal:** The core action works end-to-end: like → mutual like → match.

- [ ] Like button on profile card → POST `/api/likes` → inserts likes row
- [ ] API checks reciprocal like → inserts matches row if mutual
- [ ] Match toast / banner: "You matched with [Name]! 🎉"
- [ ] `/matches` page listing all matches for current (demo) profile
- [ ] Empty state on Matches page
- [ ] Audit log row written on every like and match
- [ ] Button disabled / loading state during API call

**Definition of Done:** Liking a profile that already liked the session profile creates a matches row visible on `/matches`. No dead buttons. Audit log populated.

---

## Sprint 3 — Stripe Checkout & Paid Tier
**Goal:** App can take a real (test-mode) payment and unlock messaging.

- [ ] `POST /api/checkout` creates Stripe Checkout session (server-side, test mode)
- [ ] Redirect to Stripe Checkout page
- [ ] `POST /api/webhooks/stripe` handles `checkout.session.completed` → sets `is_premium = true`, inserts payments row
- [ ] Success page `/upgrade/success` shown after payment
- [ ] Cancel page `/upgrade/cancel`
- [ ] Upgrade modal shown to free users who click Message
- [ ] Payment failure state handled (Stripe returns to cancel URL)
- [ ] Audit log row written on payment

**Definition of Done:** Test card 4242 4242 4242 4242 completes checkout. Webhook fires. `is_premium` flips to true in DB. Messaging UI unlocks on next page load.

---

## Sprint 4 — Messaging
**Goal:** Premium-matched users can chat in real time.

- [ ] Message thread page `/matches/[id]/chat`
- [ ] Send form: textarea + Send button → POST `/api/messages`
- [ ] Message list with sender name + timestamp
- [ ] Supabase Realtime subscription for new messages
- [ ] Premium gate: non-premium users see upgrade CTA instead of thread
- [ ] Empty thread state: "Say hello first! 👋"
- [ ] Send error state

**Definition of Done:** Two premium profiles in the same match can exchange messages. Messages persist on refresh. Non-premium sees upgrade CTA, not the thread.

---

## Sprint 5 — Auth & Profile Creation
**Goal:** Real users can sign up and create their own profile.

- [ ] Supabase Auth email/password signup + login pages
- [ ] `/create-profile` form: name, university (dropdown), bio, photo URL, interests (tags), gender, looking_for, age
- [ ] On submit: insert profiles row with `user_id = auth.uid()`
- [ ] Edit profile page
- [ ] Redirect after signup → create-profile if no profile exists

**Definition of Done:** New user signs up, creates profile, profile appears in browse feed.

---

## Sprint 6 — Lock It Down
**Goal:** Per-user data isolation enforced at the database layer.

- [ ] Replace permissive RLS with owner-scoped write policies (`auth.uid() = user_id`)
- [ ] Messages: read policy restricted to sender or recipient
- [ ] Payments: read policy restricted to owner
- [ ] audit_logs: insert-only, no update/delete policy
- [ ] Confirm with Supabase policy tests that wrong-user reads return 0 rows
- [ ] Review `/api/webhooks/stripe` with a second developer before live keys

**Definition of Done:** Logged-in user A cannot read user B's messages or payments. All existing features still work.

---

## Sprint 7 — Compatibility Score
**Goal:** Each match shows a compatibility score.

- [ ] `compute_compatibility(profile_a_id, profile_b_id)` function: shared interests / total unique * 100
- [ ] Called automatically when match is created
- [ ] Score stored in `matches.compatibility_score` with source + confidence + review_status
- [ ] Score badge shown on match card

**Definition of Done:** Every match row has a non-null compatibility_score. Badge visible in UI.

---

## Gantt (sprint → week)
```
Week 1:  Sprint 1 (DB + browse)
Week 1:  Sprint 2 (Like/Match) ← v1 functional
Week 2:  Sprint 3 (Stripe)
Week 2:  Sprint 4 (Messaging)
Week 3:  Sprint 5 (Auth)
Week 3:  Sprint 6 (Lock down)
Week 4:  Sprint 7 (Score)
```