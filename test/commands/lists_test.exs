defmodule Rediex.Commands.ListsTest do
  @moduledoc false
  use ExUnit.Case
  import Rediex.Commands.Dispatcher
  alias Rediex.Commands.Helpers

  setup do
    clean_all_databases()
  end

  describe "LPUSH" do
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

  describe "RPUSH" do
    test "RPUSH should append the given list of values to existing list" do
      dispatch("rpush", ["my-list", 4])
      dispatch("rpush", ["my-list", 5, 6, 7, 8])
      assert [4, 5, 6, 7, 8] == get_any_key("my-list")
    end
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

  describe "LRANGE" do
    test "LRANGE should return empty list response for non-existing key" do
      assert Helpers.empty_list_or_set == dispatch("lrange", ["a", "0", "-1"])
    end

    test "LRANGE should return one element for 0 0" do
      dispatch("rpush", ["mylist", "one", "two", "three"])
      assert "1) one" == dispatch("lrange", ["mylist", "0", "0"])
    end

    test "LRANGE should return one element for -3 2" do
      dispatch("rpush", ["mylist", "one", "two", "three"])
      assert "1) one\n2) two\n3) three" == dispatch("lrange", ["mylist", "-3", "2"])
    end

    test "LRANGE should return one element for -100 100" do
      dispatch("rpush", ["mylist", "one", "two", "three"])
      assert "1) one\n2) two\n3) three" == dispatch("lrange", ["mylist", "-100", "100"])
    end

    test "LRANGE should return one element for 5 10" do
      dispatch("rpush", ["mylist", "one", "two", "three"])
      assert Helpers.empty_list_or_set == dispatch("lrange", ["mylist", "5", "10"])
    end

  end
end
