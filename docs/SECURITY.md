# Security — my-soul-mate

## Secret Handling
- `STRIPE_SECRET_KEY` and `SUPABASE_SERVICE_ROLE_KEY` live only in Vercel environment variables (server-side)
- Next.js API routes (`/api/*`) are the only callers — never imported in client components
- Stripe webhook validated with `STRIPE_WEBHOOK_SECRET` via `stripe.webhooks.constructEvent`
- Public env vars (`NEXT_PUBLIC_*`) contain only publishable Stripe key and Supabase anon key

## Permission Model
- v1: permissive RLS (demo-first); all tables readable/writable by anon
- Lock-down sprint: every table's write policy requires `auth.uid() = user_id`
- Messages: read restricted to profiles whose id is sender or recipient in the match
- Payments: read restricted to profile owner only
- Agent tools inherit the calling user's session — no elevated service-role calls from client

## Approved-Tools Rule
Only named, code-reviewed API routes may touch Stripe or write payments/audit_logs. No raw `fetch` to Stripe from client. No wildcard exec functions.

## Audit Principle
Every like, match, payment, and message write appends a row to `audit_logs` with actor, action, target, and payload. Audit rows are insert-only; no update or delete policy is granted on audit_logs at lock-down.

## Payment Risk Note
Stripe Checkout and webhook handling carry financial risk. Before going live (real MYR charges), have a second developer or a payment-specialist review `/api/webhooks/stripe` end-to-end. Do not ship to production with test keys.