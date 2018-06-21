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

  def execute(:lrange, [key, start, stop], state) do
    range = lrange(state[key], start, stop)
    {:ok, range, state}
  end

  defp lrange(nil, _, _), do: Helpers.empty_list_or_set
  defp lrange([], _, _), do: Helpers.empty_list_or_set


  defp lrange(list, start, stop) do
    lower = Helpers.parse_int(start)
    upper = Helpers.parse_int(stop)

    try do
      case Enum.slice(list, lower..upper) do
        [] -> Helpers.empty_list_or_set
        result -> format_list(result)
      end
    catch
       _ -> Helpers.not_an_integer()
    end
  end



  defp format_list(list) do
    list
    |> Stream.with_index
    |> Enum.reduce([], fn({item, i}, acc) ->
      acc ++ ["#{i + 1}) #{item}"]
      end)
    |> Enum.join("\n")
  end

  defp reverse([]), do: []
  defp reverse([head | tail]), do: reverse(tail) ++ [head]

  Helpers.empty_list_or_set
end
