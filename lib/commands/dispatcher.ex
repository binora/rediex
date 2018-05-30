defmodule Rediex.Commands.Dispatcher do
  alias Rediex.Cluster
  alias Rediex.Commands.Strings
  alias Rediex.Commands.Lists

  def get_available_commands do
    %{
      "get" => [Strings, :get],
      "set" => [Strings, :set],
      "getset" => [Strings, :get_set],
      "incr" => [Strings, :incr],
      "incrby" => [Strings, :incr_by],
      "decr" => [Strings, :decr],
      "decrby" => [Strings, :decr_by],
      "lpush" => [Lists, :lpush]
    }
  end

  def dispatch(command, [key | _] = args) do
    db = get_db(key)
    case Map.get(get_available_commands, command) do
      nil -> raise "Command not implemented"
      [module, fun] -> apply(module, fun, [db, args])
    end
  end

  defp get_db(key) do
    db_slot = Cluster.decide_database(key)
    [{pid, _}] = Registry.lookup(:database_registry, "db_#{db_slot}")
    pid
  end

  def get_any_key(key) do
    db = get_db(key)
    GenServer.call(db, {:get_any_key, key})
  end

end
