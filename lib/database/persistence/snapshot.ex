defmodule Rediex.Database.Persistence.Snapshot do
  @moduledoc false
  use GenServer

  def start_link(snapshot_path, interval, once \\ nil) do
    state = %{interval: interval, snapshot_path: snapshot_path, once: once}
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
    %{interval: interval, snapshot_path: snapshot_path, once: once} = state
    [dir, file] = Path.split(snapshot_path)
    
    dir_exists? = dir |> File.exists?
    if not(dir_exists?) do
      File.mkdir!(dir)
    end

    Supervisor.which_children(:database_supervisor)
    |> Enum.map(&get_db_state/1)
    |> Enum.reduce(&merge_db_state/2)
    |> write_to_file(snapshot_path)

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
