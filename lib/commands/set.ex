defmodule Rediex.Commands.Set do
  alias Rediex.Database

  def set(key, value) do
    Database.set(key, value)
  end
end
