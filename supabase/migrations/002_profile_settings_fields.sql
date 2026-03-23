-- Settings fields on profiles
ALTER TABLE profiles ADD COLUMN default_tax_rate double precision NOT NULL DEFAULT 10.0;
ALTER TABLE profiles ADD COLUMN reminders_enabled boolean NOT NULL DEFAULT true;

-- Separate subscription table — users can only READ, only backend/service role can write
CREATE TABLE subscriptions (
  id          uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  is_pro      boolean NOT NULL DEFAULT false,
  updated_at  timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;

-- Users can only read their own subscription status
CREATE POLICY "Users can view own subscription"
  ON subscriptions FOR SELECT
  USING (id = auth.uid());

-- No INSERT/UPDATE/DELETE policies for users — only service_role can modify
-- This prevents users from setting is_pro = true themselves

-- Auto-create subscription row on signup (extend existing trigger)
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO profiles (id, email) VALUES (new.id, new.email);
  INSERT INTO subscriptions (id) VALUES (new.id);
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
