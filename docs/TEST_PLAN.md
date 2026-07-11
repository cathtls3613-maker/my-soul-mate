# Test Plan — my-soul-mate

## 1. Happy Path — Full Success Scenario

| Step | Action | Expected Result |
|---|---|---|
| 1 | Open `/` | ≥5 profile cards visible, no login prompt |
| 2 | Click a profile card | Detail page loads with bio + interests |
| 3 | Click Like on a profile that already liked back (seed data) | Toast: "You matched!" |
| 4 | Visit `/matches` | New match card visible |
| 5 | Click Message on match | Upgrade modal appears (free user) |
| 6 | Click Upgrade | Redirected to Stripe Checkout |
| 7 | Enter card 4242 4242 4242 4242, any future date, any CVC | Payment succeeds |
| 8 | Redirected to `/upgrade/success` | Success message shown |
| 9 | Visit `/matches/[id]/chat` | Message thread UI visible |
| 10 | Type a message, click Send | Message appears in thread |
| 11 | Refresh page | Message still visible (persisted to DB) |

## 2. Empty States
- Visit `/matches` with no matches → "No matches yet. Start liking profiles!"
- Visit a chat thread with no messages → "Say hello first! 👋"
- Browse page with no profiles in DB → "No profiles yet — be the first!"

## 3. Error States
- Disconnect network, click Like → button shows error toast, re-enables
- Submit incomplete profile form → field-level validation errors shown
- Stripe checkout cancelled → `/upgrade/cancel` page, no payment row created, `is_premium` unchanged
- Invalid Stripe webhook signature → API returns 400, no DB write

## 4. Permission Checks (Sprint 6)
- Logged in as User A: fetch `/api/messages?match_id=X` where A is not in match → 0 rows returned
- Logged in as User A: fetch payments → only A's payments returned

## 5. Data Integrity
- Double-like same profile → second insert rejected by UNIQUE constraint
- Webhook fires twice (Stripe retry) → `is_premium` already true, payments insert is idempotent on `stripe_session_id`