defmodule Rediex.Commands.KV do
  alias Rediex.Database.KV



  def get(key) do
    {:ok, value} = GenServer.call(:kv_database, {:get, key})
    value
  end

  def set(key, value) do
    {:ok, _} = GenServer.call(:kv_database, {:set, key, value})
    "OK"
  end

  def get_set(key, value) do
    {:ok, prev_value} = GenServer.call(:kv_database, {:get_set, key, value})
    prev_value
  end

  def incr(key) do
    {:ok, result} = GenServer.call(:kv_database, {:incr, key, 1})
    result
  end

  def decr(key) do
    {:ok, result} = GenServer.call(:kv_database, {:incr, key, -1})
    result
  end

  def incr_by(key, step) do
    {:ok, result} = GenServer.call(:kv_database, {:incr, key, step})
    result
  end

  def decr_by(key, step) do
    {:ok, result} = GenServer.call(:kv_database, {:incr, key, -step})
    result
  end

end
