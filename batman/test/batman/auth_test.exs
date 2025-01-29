defmodule Batman.AuthTest do
  use BatmanWeb.ConnCase
  alias Batman.Users
  alias Batman.Auth

  describe "Authentication Flow Tests" do
    @valid_user_attrs %{
      email: "test@example.com",
      password: "password123",
      username: "testuser",
      first_name: "Test",
      last_name: "User"
    }

    @invalid_user_attrs %{
      email: "invalid",
      password: "short",
      username: "",
      first_name: "",
      last_name: ""
    }

    test "complete authentication flow", %{conn: conn} do
      # 1. Test Sign Up
      conn = post(conn, ~p"/api/users/sign_up", user: @valid_user_attrs)
      response = json_response(conn, 201)

      assert response["user_id"]
      assert response["role"] == "user"
      assert response["xsrf_token"]

      # Save tokens for later use
      xsrf_token = response["xsrf_token"]
      jwt = conn.resp_cookies["jwt"].value

      # 2. Test Sign Out
      conn =
        build_conn()
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> put_req_header("x-xsrf-token", xsrf_token)
        |> post(~p"/api/users/sign_out")

      assert json_response(conn, 200)["message"] == "Successfully signed out"

      # 3. Test Sign In
      conn = post(build_conn(), ~p"/api/users/sign_in", %{
        "email" => @valid_user_attrs.email,
        "password" => @valid_user_attrs.password
      })

      response = json_response(conn, 200)
      assert response["user_id"]
      assert response["role"] == "user"
      assert response["xsrf_token"]

      # 4. Test Invalid Login
      conn = post(build_conn(), ~p"/api/users/sign_in", %{
        "email" => @valid_user_attrs.email,
        "password" => "wrongpassword"
      })

      assert json_response(conn, 401)["error"] == "Invalid credentials"

      # 5. Test Invalid Registration
      conn = post(build_conn(), ~p"/api/users/sign_up", user: @invalid_user_attrs)
      response = json_response(conn, 422)

      assert response["errors"]["email"]
      assert response["errors"]["password"]
      assert response["errors"]["username"]
    end

    test "protected route access", %{conn: conn} do
      # 1. Create a user and get tokens
      {:ok, user} = Users.create_user(@valid_user_attrs)
      {:ok, token, xsrf_token} = Auth.generate_token(user)

      # 2. Test accessing protected route with valid tokens
      conn =
        build_conn()
        |> put_req_header("authorization", "Bearer #{token}")
        |> put_req_header("x-xsrf-token", xsrf_token)
        |> get(~p"/api/protected/test")

      assert json_response(conn, 200)

      # 3. Test accessing protected route without tokens
      conn = build_conn() |> get(~p"/api/protected/test")
      assert json_response(conn, 401)["error"] == "Unauthorized"

      # 4. Test accessing protected route with invalid XSRF token
      conn =
        build_conn()
        |> put_req_header("authorization", "Bearer #{token}")
        |> put_req_header("x-xsrf-token", "invalid_token")
        |> get(~p"/api/protected/test")

      assert json_response(conn, 401)["error"] == "Unauthorized"
    end

    test "token expiration", %{conn: conn} do
      # Create expired token
      {:ok, user} = Users.create_user(@valid_user_attrs)
      expired_claims = %{
        "user_id" => user.id,
        "role" => user.role,
        "exp" => DateTime.utc_now() |> DateTime.add(-1, :day) |> DateTime.to_unix()
      }
      {:ok, expired_token, _claims} = Auth.generate_token_with_claims(expired_claims)

      # Try to access protected route with expired token
      conn =
        build_conn()
        |> put_req_header("authorization", "Bearer #{expired_token}")
        |> get(~p"/api/protected/test")

      assert json_response(conn, 401)["error"] == "Unauthorized"
    end
  end
end