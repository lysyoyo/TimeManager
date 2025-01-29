import Config

config :batman, Batman.Repo,
  username: System.get_env("POSTGRES_USER"),
  password: System.get_env("POSTGRES_PASSWORD"),
  hostname: System.get_env("POSTGRES_HOST"),
  database: System.get_env("POSTGRES_DB"),
  port: String.to_integer(System.get_env("POSTGRES_PORT")),
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :batman, :jwt_secret, "your_very_long_secret_key_at_least_32_bytes_long_for_security"

config :batman, BatmanWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: String.to_integer(System.get_env("PHOENIX_PORT"))],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  cors_allowed_origins: ["*"],  # Ajoutez ici vos origines autorisées,
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:batman, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:batman, ~w(--watch)]}
  ]

config :batman, BatmanWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/(?!uploads/).*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/batman_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]

config :batman, dev_routes: true

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime

config :phoenix_live_view,
  debug_heex_annotations: true,
  enable_expensive_runtime_checks: true

config :swoosh, :api_client, false
