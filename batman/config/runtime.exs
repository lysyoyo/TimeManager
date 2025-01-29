import Config

database_url =
  System.get_env("DATABASE_URL") ||
    "ecto://batman:batman_password@db/batman_dev"

config :batman, Batman.Repo,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

if config_env() == :prod do
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      """

  host = System.get_env("PHX_HOST") || "example.com"
  port = String.to_integer(System.get_env("PORT") || "4000")

  config :batman, :dns_cluster_query, System.get_env("DNS_CLUSTER_QUERY")

  config :batman, BatmanWeb.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base
end

if System.get_env("PHX_SERVER") do
  config :batman, BatmanWeb.Endpoint, server: true
end
