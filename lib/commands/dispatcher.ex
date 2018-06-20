defmodule Rediex.Commands.Dispatcher do
  @moduledoc false

  alias Rediex.Cluster
  alias Rediex.Commands.Strings
  alias Rediex.Commands.Lists

  import Rediex.Commands.Helpers

  @not_implemented "(Error) command not implemented"

  @available_commands %{
    "get" => [Strings, :get, n_args: 1],
    "set" => [Strings, :set, n_args: 2],
    "getset" => [Strings, :get_set, n_args: 2],
    "incr" => [Strings, :incr, n_args: 1],
    "incrby" => [Strings, :incr_by, n_args: 2],
    "decr" => [Strings, :decr, n_args: 1],
    "decrby" => [Strings, :decr_by, n_args: 2],
    "append" => [Strings, :append, n_args: 2],
    "lpush" => [Lists, :lpush, n_args: :infinity, min_args: 2],
    "rpush" => [Lists, :rpush, n_args: :infinity, min_args: 2],
    "rpop" => [Lists, :rpop, n_args: 1],
    "lpop" => [Lists, :lpop, n_args: 1],
    "lrange" => [Lists, :lrange, n_args: 3]
  }

  def dispatch(command, args) do
    db =
      case args do
        [] -> nil
        [key | _] -> get_db(key)
      end

    @available_commands
    |> Map.get(command)
    |> validate(args)
    |> execute(db, args)
  end

  defp validate(nil, _), do: @not_implemented

  defp validate([_, fun | opts] = cmd_spec, args) do
    valid? =
      case(opts) do
        [{:n_args, :infinity}, {:min_args, n} | _] -> length(args) >= n
        [{:n_args, n} | _] -> length(args) == n
      end

    if valid? do
      cmd_spec
    else
      fun |> to_string |> wrong_args_error
    end
  end

  defp execute([module, fun | _], db, args), do: apply(module, fun, [db, args])
  defp execute(error, _, _), do: error

  def get_any_key(key) do
    db = get_db(key)
    GenServer.call(db, {:get_any_key, key})
  end

  def parse(input) do
    input
    |> String.trim()
    |> String.split()
  end

  defp get_db(key) do
    db_slot = Cluster.decide_database(key)
    [{pid, _}] = Registry.lookup(:database_registry, "db_#{db_slot}")
    pid
  end

  def clean_all_databases do
    Supervisor.which_children(:database_supervisor)
    |> Enum.map(&get_pid/1)
    |> Enum.each(&clean_database/1)
  end

  defp get_pid({_, pid, _, _}), do: pid

  defp clean_database pid do
    GenServer.call(pid, :clean)
  end
end
