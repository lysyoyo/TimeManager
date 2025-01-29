defmodule BatmanWeb.Router do
  use BatmanWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  pipeline :auth do
    plug :accepts, ["json"]
    plug BatmanWeb.AuthPlug
  end

  # Routes publiques qui ne nécessitent pas d'authentification
  scope "/api", BatmanWeb do
    pipe_through :api

    # Routes d'authentification
    post "/users/sign_in", AuthController, :sign_in
    post "/users/sign_up", AuthController, :sign_up
    post "/users/sign_out", AuthController, :sign_out

    # Route de test basique
    get "/ping", UserController, :ping_status
  end

  # Routes protégées qui nécessitent une authentification
  scope "/api", BatmanWeb do
    pipe_through [:api, :auth]

    # Routes de working time
    get "/workingtime/:user_id", WorkingTimeController, :index
    post "/workingtime/:user_id", WorkingTimeController, :create
    resources "/workingtime", WorkingTimeController

    # Routes utilisateurs
    resources "/users", UserController
    post "/post", UserController, :ping_action
  end
end