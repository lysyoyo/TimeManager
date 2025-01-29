defmodule BatmanWeb.WorkingTimeController do
  use BatmanWeb, :controller
  alias Batman.Repo
  alias Batman.WorkingTime
  import Ecto.Query

  def index(conn, %{"user_id" => user_id} = params) do
    query =
      from(wt in WorkingTime,
        where: wt.user_id == ^String.to_integer(user_id)
      )

    query =
      case {Map.get(params, "start"), Map.get(params, "end")} do
        {nil, nil} ->
          query

        {start, nil} ->
          from(wt in query, where: wt.start >= ^NaiveDateTime.from_iso8601!(start))

        {nil, end_time} ->
          from(wt in query, where: wt.end <= ^NaiveDateTime.from_iso8601!(end_time))

        {start, end_time} ->
          from(wt in query,
            where:
              wt.start >= ^NaiveDateTime.from_iso8601!(start) and
                wt.end <= ^NaiveDateTime.from_iso8601!(end_time)
          )
      end

    working_times = Repo.all(query)

    json(conn, working_times)
  end

  def show(conn, %{"user_id" => user_id, "id" => id}) do
    case Repo.get(WorkingTime, id) do
      nil ->
        send_resp(conn, :not_found, "Working time not found")

      working_time ->
        if working_time.user_id == String.to_integer(user_id) do
          json(conn, working_time)
        else
          send_resp(conn, :forbidden, "You are not allowed to access this working time")
        end
    end
  end

  def create(conn, %{"start" => start_str, "end" => end_str, "user_id" => user_id}) do
    case {NaiveDateTime.from_iso8601(start_str), NaiveDateTime.from_iso8601(end_str)} do
      {{:ok, start}, {:ok, end_time}} ->
        changeset =
          %WorkingTime{}
          |> WorkingTime.changeset(%{
            start: start,
            end: end_time,
            user_id: String.to_integer(user_id)
          })

        case Repo.insert(changeset) do
          {:ok, working_time} ->
            conn
            |> put_status(:created)
            |> json(working_time)

          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(changeset)
        end

      _ ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Invalid date format. Use YYYY-MM-DD HH:MM:SS."})
    end
  end

  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    case Repo.get(WorkingTime, id) do
      nil ->
        send_resp(conn, :not_found, "Working time not found")

      working_time ->
        changeset = WorkingTime.changeset(working_time, working_time_params)

        case Repo.update(changeset) do
          {:ok, updated_working_time} -> json(conn, updated_working_time)
          {:error, changeset} -> conn |> put_status(:unprocessable_entity) |> json(changeset)
        end
    end
  end

  def delete(conn, %{"id" => id}) do
    case Repo.get(WorkingTime, id) do
      nil ->
        send_resp(conn, :not_found, "Working time not found")

      working_time ->
        Repo.delete(working_time)
        send_resp(conn, :no_content, "")
    end
  end
end
