# Data Model — my-soul-mate

## universities
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | owner-scope placeholder |
| created_at | timestamptz | |
| name | text | e.g. Sunway University |
| city | text | |
| country | text | default 'Malaysia' |

## profiles
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | links to auth.uid at lock-down |
| display_name | text | |
| university_id | uuid FK → universities | |
| bio | text | |
| photo_url | text | |
| interests | text[] | |
| gender | text | |
| looking_for | text | |
| age | int | |
| is_premium | boolean | default false; set by webhook |

## likes
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | |
| from_profile_id | uuid FK → profiles | |
| to_profile_id | uuid FK → profiles | |
| UNIQUE | (from, to) | prevents double-like |

## matches
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| profile_a_id | uuid FK → profiles | |
| profile_b_id | uuid FK → profiles | |
| compatibility_score | numeric | **AI field** |
| compatibility_score_source | text | e.g. 'rule_based_interests' |
| compatibility_score_confidence | numeric | 0–1 |
| compatibility_score_review_status | text | default 'unreviewed' |

## messages
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| match_id | uuid FK → matches | |
| sender_profile_id | uuid FK → profiles | |
| body | text | |

## payments
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| profile_id | uuid FK → profiles | |
| stripe_session_id | text | |
| stripe_payment_intent_id | text | |
| amount_cents | int | |
| currency | text | default 'myr' |
| status | text | pending / paid / failed |

## audit_logs
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| actor_profile_id | uuid nullable | |
| action | text | e.g. 'like.created' |
| target_table | text | |
| target_id | uuid | |
| payload | jsonb | |

## RLS
All tables: permissive v1 read+write. Lock-down sprint replaces with `auth.uid() = user_id` owner policies. Messages additionally scoped to sender or recipient profile.