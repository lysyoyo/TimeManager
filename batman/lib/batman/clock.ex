defmodule Batman.Clocks.Clock do
  @moduledoc """
  The Clock context. This module should be used to manage clock.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "clocks" do
    field :time, :utc_datetime
    field :status, :boolean
    belongs_to :user, Batman.Users.User

    timestamps()
  end

  @doc false
  def changeset(clock, attrs) do
    clock
    |> cast(attrs, [:time, :status, :user_id])
    |> validate_required([:time, :status, :user_id])
  end
end
