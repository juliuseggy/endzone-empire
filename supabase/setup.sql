-- Einmalige Einrichtung der Tabelle für die Regelvorschläge.
-- Besucher der Website (Rolle "anon") dürfen nur lesen und einreichen.
-- Bearbeiten und Löschen geht nur mit Admin-Zugang (SQL-Editor / Management-API).

create table if not exists public.regelvorschlaege (
  id          bigint generated always as identity primary key,
  created_at  timestamptz not null default now(),
  name        text not null check (char_length(name) between 1 and 60),
  team        text not null check (char_length(team) between 1 and 60),
  vorschlag   text not null check (char_length(vorschlag) between 1 and 2000)
);

alter table public.regelvorschlaege enable row level security;

drop policy if exists "alle duerfen lesen" on public.regelvorschlaege;
create policy "alle duerfen lesen"
  on public.regelvorschlaege for select
  to anon
  using (true);

drop policy if exists "alle duerfen einreichen" on public.regelvorschlaege;
create policy "alle duerfen einreichen"
  on public.regelvorschlaege for insert
  to anon
  with check (true);

-- Keine update/delete-Policies: für Website-Besucher gesperrt.
revoke update, delete, truncate on public.regelvorschlaege from anon, authenticated;
grant select, insert on public.regelvorschlaege to anon;
