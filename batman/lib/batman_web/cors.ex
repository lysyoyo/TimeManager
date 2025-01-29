defmodule BatmanWeb.CORS do
  use Corsica.Router,
      origins: "*",  # En développement. Pour la production, utilisez la liste des domaines autorisés
      allow_credentials: true,
      allow_headers: ["content-type", "authorization", "x-xsrf-token"],
      expose_headers: ["authorization"],
      max_age: 600

  # Routes publiques - autoriser tout le monde
  resource "/api/users/sign_in", origins: "*"
  resource "/api/users/sign_up", origins: "*"
  resource "/api/users/sign_out", origins: "*"
  resource "/api/ping", origins: "*"

  # Routes protégées - utiliser la configuration par défaut
  resource "/api/*"
end
