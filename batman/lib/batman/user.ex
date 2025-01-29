defmodule Batman.Users.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bcrypt

  @derive {Jason.Encoder, only: [:id, :username, :email, :first_name, :last_name, :role, :inserted_at, :updated_at]}
  schema "users" do
    field :username, :string
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :role, :string, default: "user"
    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password, :first_name, :last_name, :role])
    |> validate_required([:username, :email, :password, :first_name, :last_name])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 6)
    |> unique_constraint(:email)
    |> hash_password()
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password_hash: Bcrypt.hash_pwd_salt(password))
  end

  defp hash_password(changeset), do: changeset
end