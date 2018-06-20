defmodule Rediex.Commands.Lists.Impl do
  @moduledoc false
  alias Rediex.Commands.Helpers

  def execute(:lpush, [key | values], state) do
    list = reverse(values) ++ (state[key] || [])
    {:ok, length(list), Helpers.set(state, key, list)}
  end

  def execute(:rpush, [key | values], state) do
    list = (state[key] || []) ++ values
    {:ok, length(list), Helpers.set(state, key, list)}
  end

  def execute(:rpop, [key], state) do
    list = state[key] || []
    {last, remaining} = List.pop_at(list, length(list) - 1)
    {:ok, last, Helpers.set(state, key, remaining)}
  end

  def execute(:lpop, [key], state) do
    list = state[key] || []
    {first, remaining} = List.pop_at(list, 0)
    {:ok, first, Helpers.set(state, key, remaining)}
  end

  defp reverse([]), do: []
  defp reverse([head | tail]), do: reverse(tail) ++ [head]

end
