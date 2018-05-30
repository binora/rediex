defmodule Rediex.Commands.ListsTest do
  @moduledoc false
  use ExUnit.Case
  import Rediex.Commands.Dispatcher

  test "LPUSH should create a list and add the given value(s)" do
    dispatch("lpush", ["new-list", 3])
    assert [3] == get_any_key("new-list")
  end

  test "LPUSH should prepend the given list of values to existing list" do
    dispatch("lpush", ["my-list", 4])
    dispatch("lpush", ["my-list", 5, 6, 7, 8])
    assert [8, 7, 6, 5, 4] == get_any_key("my-list")
  end
end
