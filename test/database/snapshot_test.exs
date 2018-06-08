defmodule Rediex.Database.Persistence.SnapshotTest do
  @moduledoc false
  use ExUnit.Case
  alias Rediex.Commands.Dispatcher
  alias Rediex.Database.Persistence.Snapshot
  @snapshot_path Application.get_env(:rediex, :snapshot_path)

  setup_all do
    Dispatcher.clean_all_databases()
    on_exit(&delete_snapshot/0)
  end

  test "auto backups should be disabled" do
    assert Application.get_env(:rediex, :auto_backups?) == false
  end

  test "snapshot worker should write a file containing all db state" do
    commands = [
      ["set", ["key1", "1"]],
      ["incr", ["key1"]],
      ["incrby", ["key2", "20"]],
      ["lpush", ["my_list", "1", "2", "3"]]
    ]

    expected_result = %{"key1" => 2, "key2" => 20, "my_list" => ["3", "2", "1"]}

    commands |> Enum.each(fn [cmd, args] -> Dispatcher.dispatch(cmd, args) end)
    {:ok, pid} = Snapshot.start_link(@snapshot_path, 100, :once)
    send(pid, :take_snapshot)

    Process.sleep(2000)

    database =
      @snapshot_path
      |> Path.expand()
      |> File.read!()
      |> :erlang.binary_to_term()

    assert expected_result == database
  end

  def delete_snapshot do
    @snapshot_path
    |> Path.expand()
    |> File.rm!()
  end
end
