defmodule Rediex.Commands.KV do
  alias Rediex.Database.KV

  @not_an_integer "Value not an integer"

  def not_an_integer, do: @not_an_integer

  def get(key) do
    {:ok, value} = KV.get(key)
    value
  end

  def set(key, value) do
    {:ok, _} =  KV.set(key, value)
    :ok
  end

  def incr(key) do
    {:ok, value} = KV.get(key)
    {:ok, result} = resize(key, value, 1)
    result
  end

  def decr(key) do
    {:ok, value} = KV.get(key)
    {:ok, result} = resize(key, value, -1)
    result
  end

  def incr_by(key, step) do
    {:ok, value} = KV.get(key)
    {:ok, result} = resize(key, value, step)
    result
  end

  def decr_by(key, step) do
    {:ok, value} = KV.get(key)
    {:ok, result} = resize(key, value, -step)
    result
  end

  defp resize(key, value, step) when is_number(value), do: KV.set(key, value+step)

  defp resize(key, value, step) do
    result =
      case value do
        nil -> 0
        _ -> Integer.parse(value)
      end

    case result do
      :error -> {:ok, @not_an_integer}
      {value, _} -> KV.set(key, value + step)
      value -> KV.set(key, value + step)
    end
  end

end
