defmodule BatmanWeb.AuthPlug do
  import Plug.Conn
  alias Batman.Auth

  def init(opts), do: opts

  def call(conn, _opts) do
    with {:ok, token} <- get_token_from_cookies(conn),
         [xsrf_token] <- get_req_header(conn, "x-xsrf-token"),
         {:ok, claims} <- Auth.verify_token(token, xsrf_token) do
      assign(conn, :current_user, %{
        id: claims["user_id"],
        role: claims["role"]
      })
    else
      _error ->
        conn
        |> put_status(:unauthorized)
        |> Phoenix.Controller.json(%{error: "Unauthorized"})
        |> halt()
    end
  end

  defp get_token_from_cookies(conn) do
    case conn.cookies["jwt"] do
      nil -> {:error, :missing_token}
      token -> {:ok, token}
    end
  end
end
