defmodule Rediex.Commands.Strings do
  @moduledoc false

  def get(db, [key]) do
    GenServer.call(db, {:strings, :get, [key]})
  end

  def set(db, [key, value]) do
    GenServer.call(db, {:strings, :set, [key, value]})
    "OK"
  end

  def get_set(db, [key, value]) do
    GenServer.call(db, {:strings, :get_set, [key, value]})
  end

  def incr(db, [key]) do
    GenServer.call(db, {:strings, :incr, [key, 1]})
  end

  def decr(db, [key]) do
    GenServer.call(db, {:strings, :incr, [key, -1]})
  end

  def incr_by(db, [key, step]) do
    GenServer.call(db, {:strings, :incr, [key, String.to_integer(step)]})
  end

  def decr_by(db, [key, step]) do
    GenServer.call(db, {:strings, :incr, [key, -String.to_integer(step)]})
  end

  def append(db, [key, value]) do
    GenServer.call(db, {:strings, :append, [key, value]})
  end

end
