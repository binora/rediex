defmodule Rediex.Dispatcher do
  alias Rediex.Commands.Strings

  def valid_commands do
    [
      {:set, &Strings.set/2},
      {:get, &Strings.get/1},
      {:get_set, &Strings.get_set/2},
      {:incr, &Strings.incr/1},
      {:incrby, &Strings.incr_by/2},
      {:decr, &Strings.decr/1},
      {:decrby, &Strings.decr_by/2},
    ]
  end

  def dispatch_command(%{"command" => command, "args" => _args}) do
    {:ok, command}
  end

end
