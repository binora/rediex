defmodule Rediex.Commands.Lists do
  @moduledoc false

  def lpush(db, args) do
    GenServer.call(db, {:lists, :lpush, args})
  end

  def lrange(db, args) do
    GenServer.call(db, {:lists, :lrange, args})
  end

  def rpush(db, args) do
    GenServer.call(db, {:lists, :rpush, args})
  end

  def rpop(db, args) do
    GenServer.call(db, {:lists, :rpop, args})
  end

  def lpop(db, args) do
    GenServer.call(db, {:lists, :lpop, args})
  end

end
