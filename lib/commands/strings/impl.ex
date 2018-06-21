defmodule Rediex.Commands.Strings.Impl do
  @moduledoc false
  alias Rediex.Commands.Helpers


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

  def execute(:append, [key, value], state) do
    case append(state[key], value) do
      {:error, error} -> {:error, error}
      result -> {:ok, String.length(result), Helpers.set(state, key, result)}
    end
  end

  defp increment(value, step) when is_number(value), do: value + step
  defp increment(nil, step), do: step

  defp increment(value, step) do
    case Integer.parse(value) do
      :error -> {:error, Helpers.not_an_integer()}
      {value, ""} -> increment(value, step)
      {_value, _} -> {:error, Helpers.not_an_integer()}
    end
  end

  defp append(nil, to_append), do: to_append
  defp append(value, _) when is_list(value), do: {:error, Helpers.wrong_type_error()}
  defp append(value, to_append) do
    value
    |> to_string
    |> Kernel.<>(to_append)
  end
end
