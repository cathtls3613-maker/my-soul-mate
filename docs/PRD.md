# PRD — my-soul-mate

## Problem
Gen Z private university students in Malaysia have no dedicated, university-verified space to meet romantic matches across campuses. Generic apps (Tinder, Bumble) mix in non-students and feel unsafe.

## Target User
Undergraduate students at private Malaysian universities, 18–25, active on mobile, willing to pay a small amount for a safer, curated experience.

## Core Objects
- **University** — verified private university list
- **Profile** — student identity, interests, photo, premium status
- **Like** — directional interest signal
- **Match** — mutual like between two profiles
- **Message** — chat within a match (premium-gated)
- **Payment** — Stripe checkout record, unlocks premium

## MVP Must-Haves (v1)
- [ ] Browse profiles from multiple private universities without logging in
- [ ] Create a profile (name, university, bio, interests, photo)
- [ ] Like a profile; mutual like auto-creates a match
- [ ] Stripe Checkout flow to upgrade to premium (MYR)
- [ ] Send and receive messages inside a match (premium only)
- [ ] Every action persists to the database and reflects in the UI immediately

## Non-Goals (v1)
- University email verification
- Mobile native app
- AI icebreaker suggestions
- Admin moderation panel
- Refunds or subscription management

## Success Criteria
**End-to-end pass:** A new visitor browses demo profiles → creates their own profile → likes someone who likes them back → sees a match → hits the upgrade prompt → completes Stripe test checkout → sends a message in the match thread → message is visible on refresh.

**Definition of Done:** Every button and form in the above flow writes real data to Supabase. No step shows a dead button, static seed-only screen, or unhandled error. Stripe webhook correctly flips `is_premium = true`. Tested manually per TEST_PLAN.md.