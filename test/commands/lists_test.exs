defmodule Rediex.Commands.ListsTest do
  use ExUnit.Case
  alias Rediex.Commands.Lists
  alias Rediex.Commands.Lists.Impl

  def get_any_key(key) do
    GenServer.call(:database, {:get_any_key, key})
  end

  test "LPUSH should create a list and add the given value(s)" do
    Lists.lpush("new-list", [3])
    assert [3] == get_any_key("new-list")
  end

  test "LPUSH should prepend the given list of values to existing list" do
    Lists.lpush("my-list", [4])
    Lists.lpush("my-list", [5, 6, 7, 8])
    assert [8, 7, 6, 5, 4] == get_any_key("my-list")
  end
end
