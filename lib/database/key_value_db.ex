defmodule Rediex.Database.KV do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: :kv_database)
  end

  def init(state) do
    {:ok, state}
  end

  def get(key) do
    GenServer.call(:kv_database, {:get, key})
  end

  def set(key, value) do
    GenServer.call(:kv_database, {:set, key, value})
  end


  def handle_call({:set, key, value}, _from, state) do
    {:reply, {:ok, value}, Map.put(state, key, value)}
  end

  def handle_call({:get, key}, _from, state) do
    {:reply, {:ok, state[key]}, state}
  end

end
