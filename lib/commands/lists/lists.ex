defmodule Rediex.Commands.Lists do
  @moduledoc false

  def lpush(db, args) do
    GenServer.call(db, {:lists, :lpush, args})
  end

  def lrange(db, args) do
    GenServer.call(db, {:lists, :lrange, args})
  end
end
