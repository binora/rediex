defmodule Rediex.Commands.Strings.Impl do
  alias Rediex.Commands.Helpers


  @not_an_integer "Value not an integer"

  def not_an_integer, do: @not_an_integer

  def execute(:set, [key, value], state) do
    {:ok, value, Helpers.set(state, key, value)}
  end

  def execute(:get, [key], state) do
    {:ok, state[key], state}
  end

  def execute(:get_set, [key, value], state) do
    {:ok, state[key], Helpers.set(state, key, value)}
  end

  def execute(:incr, [key, step], state) do
    case increment(state[key], step) do
      {:error, error} -> {:ok, error, state}
      value -> {:ok, value, Helpers.set(state, key, value)}
    end
  end


  defp increment(value, step) when is_number(value), do: value + step
  defp increment(value, step) when is_nil(value), do: step

  defp increment(value, step) do
    case Integer.parse(value) do
      :error -> {:error, @not_an_integer}
      {value, _} -> increment(value, step)
    end
  end
end
