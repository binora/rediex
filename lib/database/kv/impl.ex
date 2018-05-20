defmodule Rediex.Database.KV.Impl do
  @not_an_integer "Value not an integer"

  def not_an_integer, do: @not_an_integer

  def init(), do: %{}

  def set(state, key, value), do: Map.put(state, key, value)

  def get(state, key), do: state[key]

  def incr(state, key, step) do
      case increment(state[key], step) do
          {:ok, value} -> {:ok, nil, set(state, key, value)}
          {:error, error} -> {:ok, error, state}
      end
  end


  defp increment(value, step) when is_number(value), do: {:ok, value + step}
  defp increment(value, step) when is_nil(value), do: {:ok, step}

  defp increment(value, step) do
    case Integer.parse(value) do
      :error -> {:error, @not_an_integer}
      {value, _} -> increment(value, step)
    end
  end
end
