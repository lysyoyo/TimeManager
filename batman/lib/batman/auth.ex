defmodule Batman.Auth do
  import Ecto.Query
  alias Batman.Repo
  alias Batman.Users.User
  alias Bcrypt

  def authenticate_user(email, password) do
    query = from u in User, where: u.email == ^email
    case Repo.one(query) do
      nil ->
        Bcrypt.no_user_verify()
        {:error, :invalid_credentials}
      user ->
        if Bcrypt.verify_pass(password, user.password_hash) do
          {:ok, user}
        else
          {:error, :invalid_credentials}
        end
    end
  end

  def generate_token(user) do
    xsrf_token = generate_xsrf_token()

    # Obtenir la clé secrète de la configuration et la convertir en binaire
    secret = Application.get_env(:batman, :jwt_secret) |> to_string() |> Base.encode64()
    signer = Joken.Signer.create("HS256", secret)

    # Calculer l'expiration
    expiration = DateTime.utc_now()
                 |> DateTime.add(30 * 24 * 60 * 60, :second)  # 30 jours en secondes
                 |> DateTime.to_unix()

    claims = %{
      "xsrf_token" => xsrf_token,
      "user_id" => user.id,
      "role" => user.role,
      "exp" => expiration
    }

    case Joken.generate_and_sign(%{}, claims, signer) do
      {:ok, token, _claims} -> {:ok, token, xsrf_token}
      {:error, reason} -> {:error, reason}
    end
  end

  defp generate_xsrf_token do
    :crypto.strong_rand_bytes(25)
    |> Base.url_encode64()
    |> binary_part(0, 32)
  end

  def verify_token(token, xsrf_token) do
    # Utiliser la même clé secrète pour la vérification
    secret = Application.get_env(:batman, :jwt_secret) |> to_string() |> Base.encode64()
    signer = Joken.Signer.create("HS256", secret)

    case Joken.verify(token, signer) do
      {:ok, claims} ->
        if claims["xsrf_token"] == xsrf_token do
          {:ok, claims}
        else
          {:error, :invalid_xsrf_token}
        end
      error -> error
    end
  end
end