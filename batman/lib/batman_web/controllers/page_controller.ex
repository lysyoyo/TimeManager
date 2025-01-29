defmodule BatmanWeb.PageController do
  use BatmanWeb, :controller

  def home(conn, _params) do
    render(conn, :home, layout: false)
  end
end
