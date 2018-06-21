defmodule Rediex.Commands.Helpers do
  @moduledoc false

  def set(state, key, value), do: Map.put(state, key, value)

  def wrong_args_error(command) do
    "(Error) Wrong number of arguments passed to #{command}"
  end

  def not_an_integer, do: "(error) ERR value is not an integer or out of range"

  def wrong_type_error, do: "(error) WRONGTYPE Operation against a key holding the wrong kind of value(error) WRONGTYPE Operation against a key holding the wrong kind of value"

  def parse_int(value) do
    case Integer.parse(value) do
      {v, ""} -> v
      _ -> :error
    end
  end

  def empty_list_or_set, do: "(empty list or set)"


end
