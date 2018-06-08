defmodule Rediex.Database do
  @moduledoc false
  use GenServer
  alias Rediex.Commands.Strings.Impl, as: StringsImpl
  alias Rediex.Commands.Lists.Impl, as: ListsImpl


  def start_link(name, state \\ %{}) do
    GenServer.start_link(__MODULE__, state, name: via_tuple(name))
  end

  def init(state), do: {:ok, state}

  def handle_call({:strings, cmd, args}, _from, state) do
    case StringsImpl.execute(cmd, args, state) do
      {:ok, return_value, new_state} -> {:reply, return_value, new_state}
      {:error, :wrong_args_error} -> {:reply, :wrong_args_error, state}
    end
  end

  def handle_call({:lists, cmd, args}, _from, state) do
    case ListsImpl.execute(cmd, args, state) do
      {:ok, return_value, new_state} -> {:reply, return_value, new_state}
      {:error, :wrong_args_error} -> {:reply, :wrong_args_error, state}
    end
  end

  def handle_call({:get_any_key, key}, _from, state) do
    {:reply, state[key], state}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:clean, _from, _) do
    {:reply, :ok, %{}}
  end

  defp via_tuple(name) do
    {:via, Registry, {:database_registry, name}}
  end
end
