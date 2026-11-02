-- Einmalig im SQL-Editor ausführen.
-- Reine Lesezugriffe haben das Pausieren nicht verhindert. Die GitHub Action
-- ruft deshalb täglich keepalive() auf, das einen Zeitstempel schreibt.
-- Website-Besucher können damit nur diesen einen Zeitstempel aktualisieren.

create table if not exists public.keepalive (
  id         int primary key default 1 check (id = 1),
  pinged_at  timestamptz not null default now()
);
insert into public.keepalive (id) values (1) on conflict do nothing;

-- Keine Policies: direkter Zugriff auf die Tabelle ist für anon gesperrt.
alter table public.keepalive enable row level security;

create or replace function public.keepalive()
returns timestamptz
language sql
security definer
set search_path = public
as $$
  update public.keepalive set pinged_at = now() where id = 1 returning pinged_at;
$$;

revoke all on function public.keepalive() from public;
grant execute on function public.keepalive() to anon;
