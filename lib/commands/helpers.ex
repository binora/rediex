defmodule Rediex.Commands.Helpers do
  @moduledoc false

  def set(state, key, value), do: Map.put(state, key, value)

  def wrong_args_error(command) do
    "(Error) Wrong number of arguments passed to #{command}"
  end

end
