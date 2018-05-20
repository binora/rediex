defmodule Rediex.Database.KV do
  use GenServer
  alias Rediex.Database.KV.Impl

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: :kv_database)
  end

  def init(%{}) do
    {:ok, Impl.init()}
  end

  def handle_call({:set, key, value}, _from, state) do
    {:reply, {:ok, value}, Impl.set(state, key, value)}
  end

  def handle_call({:get, key}, _from, state) do
    {:reply, {:ok, Impl.get(state, key)}, state}
  end

  def handle_call({:get_set, key, value}, _from, state) do
    {:reply, {:ok, state[key]}, Impl.set(state, key, value)}
  end

  def handle_call({:incr, key, step}, _from, state) do
    {:ok, error, new_state} = Impl.incr(state, key, step)

    return_value = if error, do: error, else: new_state[key]

    {:reply, {:ok, return_value}, new_state}
  end

end
