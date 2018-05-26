defmodule Rediex.Commands.Lists.Impl do
  alias Rediex.Commands.Helpers

  def update_fn(list, values), do: values ++ list

  def execute(:lpush, [key | values], state) do
    list = reverse(values) ++ (state[key] || [])
    {:ok, length(list), Helpers.set(state, key, list)}
  end

  defp reverse([]), do: []
  defp reverse([head | tail]), do: reverse(tail) ++ [head]


end