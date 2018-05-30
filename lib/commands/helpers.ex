defmodule Rediex.Commands.Helpers do
  @moduledoc false

  def set(state, key, value), do: Map.put(state, key, value)

end
