defmodule Rediex.Database.Persistence.Snapshot do
  @moduledoc false
  use GenServer

  def start_link(dir, interval) do
    state = %{interval: interval, dir: dir}
    GenServer.start_link(__MODULE__, state, name: :snapshot_worker)
  end

  def init(%{interval: interval} = state) do
    {:ok, state}
  end

  defp get_db_state({_, pid, _, _}) do
    GenServer.call(pid, :get_state)
  end

  defp merge_db_state(db_state, acc) do
    Map.merge(db_state, acc)
  end

  def handle_info(:take_snapshot, %{interval: interval, dir: dir} = state) do
    Supervisor.which_children(:database_supervisor)
    |> Enum.map(&get_db_state/1)
    |> Enum.reduce(&merge_db_state/2)
    |> write_to_file(dir)

    take_snapshot_after(interval)
    {:noreply, state}
  end

  defp write_to_file(all_db_state, dir) do
    with binary <- :erlang.term_to_binary(all_db_state) do
      dir
      |> Path.expand()
      |> File.write!(binary)
    end
  end

  def take_snapshot_after(interval) do
    if interval == :infinity do
      send(self(), :take_snapshot)
    else
      Process.send_after(self(), :take_snapshot, interval)
    end
  end
end
