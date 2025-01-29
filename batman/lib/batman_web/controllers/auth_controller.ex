defmodule BatmanWeb.AuthController do
  use BatmanWeb, :controller
  alias Batman.Auth
  alias Batman.Users

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Auth.authenticate_user(email, password) do
      {:ok, user} ->
        {:ok, token, xsrf_token} = Auth.generate_token(user)

        conn
        |> put_resp_cookie("jwt", token, http_only: true, secure: true, same_site: "Lax")
        |> json(%{
          xsrf_token: xsrf_token,
          user_id: user.id,
          role: user.role
        })

      {:error, _reason} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid credentials"})
    end
  end

  def sign_up(conn, user_params) do
    case Users.create_user(user_params) do
      {:ok, user} ->
        {:ok, token, xsrf_token} = Auth.generate_token(user)

        conn
        |> put_resp_cookie("jwt", token, http_only: true, secure: true, same_site: "Lax")
        |> put_status(:created)
        |> json(%{
          xsrf_token: xsrf_token,
          user_id: user.id,
          role: user.role
        })

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: format_changeset_errors(changeset)})
    end
  end

  def sign_out(conn, _params) do
    conn
    |> fetch_session()
    |> delete_resp_cookie("jwt", path: "/", same_site: "Lax")
    |> clear_session()
    |> configure_session(drop: true)
    |> put_status(:ok)
    |> json(%{message: "Successfully signed out"})
  end

  defp format_changeset_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end