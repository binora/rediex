defmodule Rediex.Database do
  use GenServer
  alias Rediex.Commands.Strings.Impl, as: StringsImpl

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

end
