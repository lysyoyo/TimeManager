import Config

config :batman,
  ecto_repos: [Batman.Repo],
  generators: [timestamp_type: :utc_datetime]

config :batman, BatmanWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: BatmanWeb.ErrorHTML, json: BatmanWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Batman.PubSub,
  live_view: [signing_salt: System.get_env("SIGNING_SALT")]

config :batman, Batman.Mailer, adapter: Swoosh.Adapters.Local

config :esbuild,
  version: "0.17.11",
  batman: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind,
  version: "3.4.3",
  batman: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{config_env()}.exs"
