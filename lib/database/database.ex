defmodule Rediex.Database do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: :rediex_database)
  end

  def init(state) do
    {:ok, state}
  end

  def get(key) do
    GenServer.call(:rediex_database, {:get , key})
  end

  def set(key, value) do
    GenServer.call(:rediex_database, {:set, key, value})
  end

  def handle_call({:set, key, value}, _from, state) do
    {:reply, :ok, Map.put(state, key, value)}
  end

  def handle_call({:get, key}, _from, state) do
    {:reply, state[key], state}
  end

end
