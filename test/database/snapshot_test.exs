defmodule Rediex.Database.Persistence.SnapshotTest do
  @moduledoc false
  use ExUnit.Case
  import Rediex.Commands.Dispatcher
  alias Rediex.Database.Persistence.Snapshot
  @snapshot_path Application.get_env(:rediex, :snapshot_path)

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

    commands |> Enum.each(fn c -> dispatch(hd(c), tl(c)) end)
    {:ok, pid} = Snapshot.start_link(@snapshot_path, :infinity)
    send(pid, :take_snapshot)

    database =
      @snapshot_path
      |> Path.expand()
      |> File.read!()
      |> :erlang.binary_to_term()

    Process.sleep(1000)
    assert expected_result == database
  end

end
