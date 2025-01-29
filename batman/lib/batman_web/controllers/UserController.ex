defmodule BatmanWeb.UserController do
  use BatmanWeb, :controller
  alias Batman.Users

  def index(conn, %{"email" => email, "username" => username}) do
    users = Users.list_users()

    filtered_users =
      Enum.filter(users, fn user ->
        (email == "" or user.email == email) and (username == "" or user.username == username)
      end)

    json(conn, filtered_users)
  end

  def index(conn, %{"email" => email}) do
    users = Users.list_users()
    filtered_users = Enum.filter(users, fn user -> user.email == email end)
    json(conn, filtered_users)
  end

  def index(conn, %{"username" => username}) do
    users = Users.list_users()
    filtered_users = Enum.filter(users, fn user -> user.username == username end)
    json(conn, filtered_users)
  end

  def index(conn, %{"role" => role}) do
    users = Users.list_users()
    filtered_users = Enum.filter(users, fn user -> user.role == role end)
    json(conn, filtered_users)
  end

  def index(conn, _params) do
    users = Users.list_users()
    json(conn, users)
  end

  def create(conn, %{"username" => username, "email" => email, "role" => role}) do
    case Users.create_user(%{"username" => username, "email" => email, "role" => role}) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> json(user)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    case Users.get_user(id) do
      nil ->
        send_resp(conn, :not_found, "User not found")

      user ->
        json(conn, user)
    end
  end

  def update(conn, %{"id" => id} = params) do
    case Users.get_user(id) do
      nil ->
        send_resp(conn, :not_found, "User not found")

      user ->
        case Users.update_user(user, params) do
          {:ok, user} ->
            json(conn, user)

          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(changeset)
        end
    end
  end

  def delete(conn, %{"id" => id}) do
    case Users.get_user(id) do
      nil ->
        send_resp(conn, :not_found, "User not found")

      user ->
        Users.delete_user(user)
        send_resp(conn, :no_content, "")
    end
  end
end
