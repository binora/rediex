defmodule Rediex.Database do
  use GenServer
  alias Rediex.Commands.Strings.Impl, as: StringsImpl
  alias Rediex.Commands.Lists.Impl, as: ListsImpl

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: :database)
  end

  def init(%{}) do
    {:ok, %{}}
  end

  def handle_call({:strings, cmd, args}, _from, state) do
    {:ok, return_value, new_state} = StringsImpl.execute(cmd, args, state)
    {:reply, return_value, new_state}
  end

  def handle_call({:lists, cmd, args}, _from, state) do
    {:ok, return_value, new_state} = ListsImpl.execute(cmd, args, state)
    {:reply, return_value, new_state}
  end

  def handle_call({:get_any_key, key}, _from, state) do
    {:reply, state[key], state}
  end

end
