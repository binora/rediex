defmodule Rediex.Commands.ListsTest do
  @moduledoc false
  use ExUnit.Case
  import Rediex.Commands.Dispatcher

  setup do
    clean_all_databases()
  end

  test "LPUSH should create a list and add the given value(s)" do
    dispatch("lpush", ["new-list", 3])
    assert [3] == get_any_key("new-list")
  end

  test "LPUSH should prepend the given list of values to existing list" do
    dispatch("lpush", ["my-list", 4])
    dispatch("lpush", ["my-list", 5, 6, 7, 8])
    assert [8, 7, 6, 5, 4] == get_any_key("my-list")
  end

  test "RPUSH should append the given list of values to existing list" do
    dispatch("rpush", ["my-list", 4])
    dispatch("rpush", ["my-list", 5, 6, 7, 8])
    assert [4, 5, 6, 7, 8] == get_any_key("my-list")
  end

  test "RPOP should remove the last element" do
    dispatch("rpush", ["my-list", 4])
    dispatch("rpush", ["my-list", 5, 6, 7, 8])
    assert 8 == dispatch("rpop", ["my-list"])
    assert [4, 5, 6, 7] == get_any_key("my-list")
  end

  test "LPOP should remove the last element" do
    dispatch("rpush", ["my-list", 4])
    dispatch("rpush", ["my-list", 5, 6, 7, 8])
    assert 4 == dispatch("lpop", ["my-list"])
    assert [5, 6, 7, 8] == get_any_key("my-list")
  end

end
