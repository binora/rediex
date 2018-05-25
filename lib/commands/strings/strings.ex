defmodule Rediex.Commands.Strings do

  def get(key) do
    GenServer.call(:database, {:strings, :get, {key}})
  end

  def set(key, value) do
    GenServer.call(:database, {:strings, :set, {key, value}})
    "OK"
  end

  def get_set(key, value) do
    GenServer.call(:database, {:strings, :get_set, {key, value}})
  end

  def incr(key) do
    GenServer.call(:database, {:strings, :incr, {key, 1}})
  end

  def decr(key) do
    GenServer.call(:database, {:strings, :incr, {key, -1}})
  end

  def incr_by(key, step) do
    GenServer.call(:database, {:strings, :incr, {key, step}})
  end

  def decr_by(key, step) do
    GenServer.call(:database, {:strings, :incr, {key, -step}})
  end
end
