-- Community Wall table. Paste into Supabase → SQL Editor → Run.
create table if not exists public.wall_notes (
  id bigint generated always as identity primary key,
  message text not null check (char_length(message) between 1 and 90),
  name text check (name is null or char_length(name) <= 24),
  hidden boolean not null default false,
  created_at timestamptz not null default now()
);

alter table public.wall_notes enable row level security;

-- Anyone can read visible notes
create policy "read visible notes" on public.wall_notes
  for select to anon using (hidden = false);

-- Anyone can post, but cannot pre-hide/unhide or edit/delete
create policy "post notes" on public.wall_notes
  for insert to anon with check (hidden = false);

-- Moderation: in the Table Editor, set hidden = true on any note to take it down.
