# Architecture — my-soul-mate

## Stack
| Layer | Choice |
|---|---|
| Frontend | Next.js 14 (App Router) |
| Database | Supabase (Postgres + Realtime) |
| Auth | Supabase Auth (Sprint 5, not Sprint 1) |
| Payments | Stripe Checkout + Webhooks |
| Hosting | Vercel |

## Build Sequence
**Now:** Tables → seed profiles → browse page → like/match engine → Stripe checkout → messaging
**Next:** Supabase Auth signup, profile creation by real users, owner-scoped RLS
**Later:** AI compatibility scoring, university email verification, push notifications

## Key Action Flow — "Like → Match → Pay → Message"
1. Visitor opens `/` → Supabase returns seeded profiles (no auth required)
2. Visitor clicks Like → POST to `/api/likes` → row inserted in `likes`
3. Server checks for reciprocal like → if found, inserts `matches` row
4. Match banner shown → user visits `/matches`
5. User clicks Message → UI checks `profile.is_premium`; if false, shows upgrade modal
6. Upgrade → server creates Stripe Checkout session (secret key server-only) → redirect
7. Stripe webhook hits `/api/webhooks/stripe` → sets `is_premium = true`, inserts `payments` row
8. User returns → message thread unlocked → sends message → Supabase Realtime pushes to recipient

## Why It Runs Without AI
Like detection, match creation, payment gating, and messaging are pure DB + server logic. Compatibility score (Sprint 7) is rule-based first (shared interests count). AI is additive, never load-bearing.