# Intelligence Layer — my-soul-mate

## Messy Input
Profile interests are free-text tags entered by users (e.g. 'coffee', 'K-drama', 'hiking').

## Auto-Structure Schema (v1 rule engine)
```json
{
  "profile_a_interests": ["coffee", "hiking", "indie music"],
  "profile_b_interests": ["coffee", "yoga", "films"],
  "shared_count": 1,
  "total_unique": 5,
  "compatibility_score": 20,
  "source": "rule_based_interests",
  "confidence": 0.40,
  "review_status": "unreviewed"
}
```

## Scoring Rule (v1)
`score = (shared_interests / total_unique_interests) * 100`
Stored in `matches.compatibility_score` with source + confidence + review_status.

## Events to Track
- Profile viewed
- Like sent
- Match created
- Message sent
- Upgrade clicked
- Payment completed

## What Gets Ranked
- Profile browse feed ranked by compatibility_score with the logged-in user (v1: random / recency)

## v1 vs Later
| Feature | v1 | Later |
|---|---|---|
| Compatibility | Shared interest count | OpenAI embedding similarity |
| Feed ranking | Recency | Score-ranked + filters |
| Icebreakers | None | AI-generated from shared interests |