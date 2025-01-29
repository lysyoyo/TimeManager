defmodule Batman.Repo.Migrations.AddAuthFieldsToUsers do
  use Ecto.Migration

  def change do
    execute "ALTER TABLE users ADD COLUMN IF NOT EXISTS first_name varchar"
    execute "ALTER TABLE users ADD COLUMN IF NOT EXISTS last_name varchar"
    execute "ALTER TABLE users ADD COLUMN IF NOT EXISTS password_hash varchar"
    execute "ALTER TABLE users ADD COLUMN IF NOT EXISTS role varchar DEFAULT 'user'"

    # Vérifions si l'index existe en utilisant une requête directe
    execute """
    DO $$
    BEGIN
      IF NOT EXISTS (
        SELECT 1 FROM pg_indexes
        WHERE tablename = 'users'
        AND indexname = 'users_email_index'
      ) THEN
        CREATE UNIQUE INDEX users_email_index ON users(email);
      END IF;
    END
    $$;
    """
  end
end