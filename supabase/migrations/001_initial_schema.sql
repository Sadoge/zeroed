-- ============================================================
-- Zeroed — Initial Schema
-- ============================================================

-- ─── Custom types ────────────────────────────────────────────
create type invoice_status as enum (
  'draft', 'sent', 'viewed', 'paid', 'overdue'
);

create type reminder_type as enum (
  '3day', '7day', '14day'
);

-- ─── Profiles ────────────────────────────────────────────────
create table profiles (
  id          uuid primary key references auth.users(id) on delete cascade,
  email       text not null,
  business_name    text,
  logo_url         text,
  address          text,
  tax_id           text,
  default_currency text not null default 'USD',
  default_payment_terms_days int not null default 30,
  stripe_account_id  text,
  stripe_connected   boolean not null default false,
  created_at  timestamptz not null default now()
);

-- ─── Clients ─────────────────────────────────────────────────
create table clients (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references auth.users(id) on delete cascade,
  name        text not null,
  email       text not null,
  phone       text,
  company     text,
  notes       text,
  created_at  timestamptz not null default now()
);

create index idx_clients_user_id on clients(user_id);

-- ─── Invoices ────────────────────────────────────────────────
create table invoices (
  id              uuid primary key default gen_random_uuid(),
  user_id         uuid not null references auth.users(id) on delete cascade,
  client_id       uuid references clients(id) on delete set null,
  invoice_number  text not null,
  status          invoice_status not null default 'draft',
  currency        text not null default 'USD',
  tax_rate        double precision,
  due_date        timestamptz not null,
  sent_at         timestamptz,
  paid_at         timestamptz,
  stripe_payment_link text,
  pdf_url         text,
  notes           text,
  is_recurring    boolean not null default false,
  recurrence_interval text,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

create index idx_invoices_user_id on invoices(user_id);
create index idx_invoices_client_id on invoices(client_id);
create index idx_invoices_status on invoices(status);

-- ─── Line Items ──────────────────────────────────────────────
create table line_items (
  id          uuid primary key default gen_random_uuid(),
  invoice_id  uuid not null references invoices(id) on delete cascade,
  description text not null,
  quantity    double precision not null default 1,
  unit_price  double precision not null,
  sort_order  int not null default 0
);

create index idx_line_items_invoice_id on line_items(invoice_id);

-- ─── Reminders ───────────────────────────────────────────────
create table reminders (
  id            uuid primary key default gen_random_uuid(),
  invoice_id    uuid not null references invoices(id) on delete cascade,
  scheduled_at  timestamptz not null,
  sent_at       timestamptz,
  type          reminder_type not null
);

create index idx_reminders_invoice_id on reminders(invoice_id);

-- ─── Auto-update updated_at ──────────────────────────────────
create or replace function update_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger set_invoices_updated_at
  before update on invoices
  for each row execute function update_updated_at();

-- ─── Invoice number generation ───────────────────────────────
-- Returns the next invoice number for a user, e.g. INV-0001.
create or replace function next_invoice_number(p_user_id uuid)
returns text as $$
declare
  v_count int;
begin
  select count(*) + 1 into v_count
  from invoices
  where user_id = p_user_id;

  return 'INV-' || lpad(v_count::text, 4, '0');
end;
$$ language plpgsql;

-- ─── Row Level Security ──────────────────────────────────────
alter table profiles enable row level security;
alter table clients enable row level security;
alter table invoices enable row level security;
alter table line_items enable row level security;
alter table reminders enable row level security;

-- Profiles: users can only access their own profile
create policy "Users can view own profile"
  on profiles for select
  using (id = auth.uid());

create policy "Users can update own profile"
  on profiles for update
  using (id = auth.uid());

create policy "Users can insert own profile"
  on profiles for insert
  with check (id = auth.uid());

-- Clients: users can only CRUD their own clients
create policy "Users can view own clients"
  on clients for select
  using (user_id = auth.uid());

create policy "Users can insert own clients"
  on clients for insert
  with check (user_id = auth.uid());

create policy "Users can update own clients"
  on clients for update
  using (user_id = auth.uid());

create policy "Users can delete own clients"
  on clients for delete
  using (user_id = auth.uid());

-- Invoices: users can only CRUD their own invoices
create policy "Users can view own invoices"
  on invoices for select
  using (user_id = auth.uid());

create policy "Users can insert own invoices"
  on invoices for insert
  with check (user_id = auth.uid());

create policy "Users can update own invoices"
  on invoices for update
  using (user_id = auth.uid());

create policy "Users can delete own invoices"
  on invoices for delete
  using (user_id = auth.uid());

-- Line items: accessible if user owns the parent invoice
create policy "Users can view own line items"
  on line_items for select
  using (
    exists (
      select 1 from invoices
      where invoices.id = line_items.invoice_id
        and invoices.user_id = auth.uid()
    )
  );

create policy "Users can insert own line items"
  on line_items for insert
  with check (
    exists (
      select 1 from invoices
      where invoices.id = line_items.invoice_id
        and invoices.user_id = auth.uid()
    )
  );

create policy "Users can update own line items"
  on line_items for update
  using (
    exists (
      select 1 from invoices
      where invoices.id = line_items.invoice_id
        and invoices.user_id = auth.uid()
    )
  );

create policy "Users can delete own line items"
  on line_items for delete
  using (
    exists (
      select 1 from invoices
      where invoices.id = line_items.invoice_id
        and invoices.user_id = auth.uid()
    )
  );

-- Reminders: accessible if user owns the parent invoice
create policy "Users can view own reminders"
  on reminders for select
  using (
    exists (
      select 1 from invoices
      where invoices.id = reminders.invoice_id
        and invoices.user_id = auth.uid()
    )
  );

create policy "Users can insert own reminders"
  on reminders for insert
  with check (
    exists (
      select 1 from invoices
      where invoices.id = reminders.invoice_id
        and invoices.user_id = auth.uid()
    )
  );

create policy "Users can update own reminders"
  on reminders for update
  using (
    exists (
      select 1 from invoices
      where invoices.id = reminders.invoice_id
        and invoices.user_id = auth.uid()
    )
  );

create policy "Users can delete own reminders"
  on reminders for delete
  using (
    exists (
      select 1 from invoices
      where invoices.id = reminders.invoice_id
        and invoices.user_id = auth.uid()
    )
  );

-- ─── Auto-create profile on signup ───────────────────────────
create or replace function handle_new_user()
returns trigger as $$
begin
  insert into profiles (id, email)
  values (new.id, new.email);
  return new;
end;
$$ language plpgsql security definer;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function handle_new_user();
