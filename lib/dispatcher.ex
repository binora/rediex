defmodule Rediex.Dispatcher do
  alias Rediex.Commands.KV

  def valid_commands do
    [
      {:set, &KV.set/2},
      {:get, &KV.get/1},
      {:get_set, &KV.get_set/2},
      {:incr, &KV.incr/1},
      {:incrby, &KV.incr_by/2},
      {:decr, &KV.decr/1},
      {:decrby, &KV.decr_by/2},
    ]
  end

  def dispatch_command(%{"command" => command, "args" => _args}) do
    {:ok, command}
  end

end
