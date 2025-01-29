import Config

config :batman, BatmanWeb.Endpoint,
  url: [host: System.get_env("PHX_HOST") || "example.com", port: 80],
  cache_static_manifest: "priv/static/cache_manifest.json"

config :logger, level: :info

config :swoosh, api_client: Swoosh.ApiClient.Finch, finch_name: Batman.Finch

config :swoosh, local: false

config :batman, Batman.Repo,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  ssl: false
