defmodule Batman.Repo do
  use Ecto.Repo,
    otp_app: :batman,
    adapter: Ecto.Adapters.Postgres
end
