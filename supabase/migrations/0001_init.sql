create table if not exists universities (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  created_at timestamptz not null default now(),
  name text not null,
  city text not null,
  country text not null default 'Malaysia'
);

alter table universities enable row level security;
drop policy if exists "universities_v1_read" on universities;
create policy "universities_v1_read" on universities for select using (true);
drop policy if exists "universities_v1_write" on universities;
create policy "universities_v1_write" on universities for all using (true) with check (true);

create table if not exists profiles (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  created_at timestamptz not null default now(),
  display_name text not null,
  university_id uuid references universities(id),
  bio text,
  photo_url text,
  interests text[],
  gender text,
  looking_for text,
  age int,
  is_premium boolean not null default false
);

alter table profiles enable row level security;
drop policy if exists "profiles_v1_read" on profiles;
create policy "profiles_v1_read" on profiles for select using (true);
drop policy if exists "profiles_v1_write" on profiles;
create policy "profiles_v1_write" on profiles for all using (true) with check (true);

create table if not exists likes (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  created_at timestamptz not null default now(),
  from_profile_id uuid not null references profiles(id),
  to_profile_id uuid not null references profiles(id),
  unique(from_profile_id, to_profile_id)
);

alter table likes enable row level security;
drop policy if exists "likes_v1_read" on likes;
create policy "likes_v1_read" on likes for select using (true);
drop policy if exists "likes_v1_write" on likes;
create policy "likes_v1_write" on likes for all using (true) with check (true);

create table if not exists matches (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  created_at timestamptz not null default now(),
  profile_a_id uuid not null references profiles(id),
  profile_b_id uuid not null references profiles(id),
  compatibility_score numeric,
  compatibility_score_source text,
  compatibility_score_confidence numeric,
  compatibility_score_review_status text default 'unreviewed',
  unique(profile_a_id, profile_b_id)
);

alter table matches enable row level security;
drop policy if exists "matches_v1_read" on matches;
create policy "matches_v1_read" on matches for select using (true);
drop policy if exists "matches_v1_write" on matches;
create policy "matches_v1_write" on matches for all using (true) with check (true);

create table if not exists messages (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  created_at timestamptz not null default now(),
  match_id uuid not null references matches(id),
  sender_profile_id uuid not null references profiles(id),
  body text not null
);

alter table messages enable row level security;
drop policy if exists "messages_v1_read" on messages;
create policy "messages_v1_read" on messages for select using (true);
drop policy if exists "messages_v1_write" on messages;
create policy "messages_v1_write" on messages for all using (true) with check (true);

create table if not exists payments (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  created_at timestamptz not null default now(),
  profile_id uuid not null references profiles(id),
  stripe_session_id text,
  stripe_payment_intent_id text,
  amount_cents int not null,
  currency text not null default 'myr',
  status text not null default 'pending'
);

alter table payments enable row level security;
drop policy if exists "payments_v1_read" on payments;
create policy "payments_v1_read" on payments for select using (true);
drop policy if exists "payments_v1_write" on payments;
create policy "payments_v1_write" on payments for all using (true) with check (true);

create table if not exists audit_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  created_at timestamptz not null default now(),
  actor_profile_id uuid,
  action text not null,
  target_table text,
  target_id uuid,
  payload jsonb
);

alter table audit_logs enable row level security;
drop policy if exists "audit_logs_v1_read" on audit_logs;
create policy "audit_logs_v1_read" on audit_logs for select using (true);
drop policy if exists "audit_logs_v1_write" on audit_logs;
create policy "audit_logs_v1_write" on audit_logs for all using (true) with check (true);

insert into universities (id, name, city) values
  ('a1000000-0000-0000-0000-000000000001', 'Sunway University', 'Petaling Jaya'),
  ('a1000000-0000-0000-0000-000000000002', 'Taylor''s University', 'Subang Jaya'),
  ('a1000000-0000-0000-0000-000000000003', 'HELP University', 'Kuala Lumpur')
on conflict do nothing;

insert into profiles (id, display_name, university_id, bio, photo_url, interests, gender, looking_for, age, is_premium) values
  ('b1000000-0000-0000-0000-000000000001', 'Aisha R.', 'a1000000-0000-0000-0000-000000000001', 'Coffee addict, psych major. Looking for my person 🌙', 'https://i.pravatar.cc/300?img=47', ARRAY['coffee','psychology','hiking','indie music'], 'female', 'male', 21, false),
  ('b1000000-0000-0000-0000-000000000002', 'Marcus T.', 'a1000000-0000-0000-0000-000000000002', 'CS student who loves basketball and bad puns 🏀', 'https://i.pravatar.cc/300?img=12', ARRAY['basketball','coding','memes','cooking'], 'male', 'female', 22, true),
  ('b1000000-0000-0000-0000-000000000003', 'Priya N.', 'a1000000-0000-0000-0000-000000000002', 'Law student. Into K-drama, matcha, and real convos.', 'https://i.pravatar.cc/300?img=45', ARRAY['k-drama','matcha','law','reading'], 'female', 'male', 20, false),
  ('b1000000-0000-0000-0000-000000000004', 'Ethan L.', 'a1000000-0000-0000-0000-000000000003', 'Finance bro trying to be more artsy 🎸', 'https://i.pravatar.cc/300?img=33', ARRAY['guitar','finance','art','travel'], 'male', 'female', 23, true),
  ('b1000000-0000-0000-0000-000000000005', 'Nurul H.', 'a1000000-0000-0000-0000-000000000001', 'Design student. Manifesting a soulmate who bakes 🍰', 'https://i.pravatar.cc/300?img=48', ARRAY['design','baking','yoga','films'], 'female', 'male', 21, false)
on conflict do nothing;

insert into matches (id, profile_a_id, profile_b_id, compatibility_score, compatibility_score_source, compatibility_score_confidence, compatibility_score_review_status) values
  ('c1000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000003', 72, 'rule_based_interests', 0.68, 'unreviewed')
on conflict do nothing;