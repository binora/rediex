defmodule Rediex.Commands.Strings do

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
    GenServer.call(db, {:strings, :incr, [key, step]})
  end

  def decr_by(db, [key, step]) do
    GenServer.call(db, {:strings, :incr, [key, -step]})
  end
end
