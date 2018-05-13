defmodule Rediex.Commands.Get do
  alias Rediex.Database

  def get(key) do
    value = Database.get(key)
    {:ok, value}
  end
end
