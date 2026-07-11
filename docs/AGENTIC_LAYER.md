# Agentic Layer — my-soul-mate

## Risk Levels & Actions

### Low — Auto (no approval needed)
- Tag/normalise interest strings on profile save
- Compute compatibility score on match creation
- Draft match notification copy

### Medium — Light approval
- Flag a profile as potentially inappropriate (human reviews before hiding)
- Suggest profile bio improvements (user approves before applying)

### High — Always approval
- Send a push/email notification to a user
- Initiate a Stripe Checkout session (user explicitly clicks Pay)

### Critical — Human only
- Delete a profile or match
- Issue a refund
- Ban a user account

## Named Tools (approved, v1)
- `compute_compatibility(profile_a_id, profile_b_id)` → returns score + stores in matches
- `create_stripe_checkout(profile_id, price_myr)` → server-side only
- `stripe_webhook_handler(event)` → sets is_premium, writes payments row

## Audit Log Fields
`action | actor_profile_id | target_table | target_id | payload | created_at`

Every named tool call writes an audit_log row.

## v1 vs Later
- v1: compute_compatibility + stripe tools only
- Later: moderation flagging agent, AI icebreaker draft tool