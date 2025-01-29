defmodule BatmanWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :batman

  @session_options [
    store: :cookie,
    key: "_batman_key",
    signing_salt: System.get_env("SIGNING_SALT"),
    same_site: "Lax",
    secure: true,
    max_age: 2 * 60 * 60
  ]

  socket "/live", Phoenix.LiveView.Socket,
         websocket: [connect_info: [session: @session_options]],
         longpoll: [connect_info: [session: @session_options]]

  # Ajout de la configuration CORS
  plug Corsica,
       origins: "*",  # En développement. Pour la production, spécifiez les domaines exacts
       allow_credentials: true,
       allow_headers: ["content-type", "authorization", "x-xsrf-token"],
       expose_headers: ["authorization"],
       max_age: 600

  plug Plug.Static,
       at: "/",
       from: :batman,
       gzip: false,
       only: BatmanWeb.static_paths()

  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :batman
  end

  plug Phoenix.LiveDashboard.RequestLogger,
       param_key: "request_logger",
       cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
       parsers: [:urlencoded, :multipart, :json],
       pass: ["*/*"],
       json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug BatmanWeb.Router
end
