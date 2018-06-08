defmodule Rediex.Database.Persistence.Snapshot do
  @moduledoc false
  use GenServer

  def start_link(dir, interval, once \\ nil) do
    state = %{interval: interval, dir: dir, once: once}
    GenServer.start_link(__MODULE__, state, name: :snapshot_worker)
  end

  def init(%{interval: interval} = state) do
    take_snapshot_after(interval)
    {:ok, state}
  end

  defp get_db_state({_, pid, _, _}) do
    GenServer.call(pid, :get_state)
  end

  defp merge_db_state(db_state, acc) do
    Map.merge(db_state, acc)
  end

  def handle_info(:take_snapshot, state) do
    %{interval: interval, dir: dir, once: once} = state

    Supervisor.which_children(:database_supervisor)
    |> Enum.map(&get_db_state/1)
    |> Enum.reduce(&merge_db_state/2)
    |> write_to_file(dir)

    if is_nil(once) do
      take_snapshot_after(interval)
    end

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
    Process.send_after(self(), :take_snapshot, interval)
  end
end
