defmodule Rediex.Commands.StringsTest do
  @moduledoc false
  use ExUnit.Case
  import Rediex.Commands.Dispatcher
  alias Rediex.Commands.Strings.Impl

  test "get command should return nil for unset key" do
    assert nil == dispatch("get", ["unset-key"])
  end

  test "set command should set the given value for the key" do
    assert "OK" == dispatch("set", ["key", "value"])
    assert "value" == dispatch("get", ["key"])
  end

  test "incr command should set unset key to 1" do
    dispatch("incr", ["unsetkey1"])
    assert 1 == dispatch("get", ["unsetkey1"])
  end

  test "decr command should set unset key to -1" do
    dispatch("incr", ["unsetkey2"])
    assert 1 == dispatch("get", ["unsetkey2"])
  end

  test "incr should increment a key by 1" do
    dispatch("set", ["incr_key", 10])
    dispatch("incr", ["incr_key"])

    assert 11 == dispatch("get", ["incr_key"])
  end

  test "decr should decrement a key by 1" do
    dispatch("set", ["decr_key", 20])
    dispatch("decr", ["decr_key"])

    assert 19 == dispatch("get", ["decr_key"])
  end

  test "incryby should increment a key by given step" do
    dispatch("set", ["incr_by_key", "10"])
    dispatch("incrby", ["incr_by_key", "10"])

    assert 20 == dispatch("get", ["incr_by_key"])
  end

  test "decrby should increment a key by given step" do
    dispatch("set", ["decr_by_key", "10"])
    dispatch("decrby", ["decr_by_key", "10"])

    assert 0 == dispatch("get", ["decr_by_key"])
  end

  test "incr should not increment in case of strings and throw an error" do

    dispatch("set", ["incr_error_key", "string"])
    error = dispatch("incr", ["incr_error_key"])

    assert error == Impl.not_an_integer()
    assert "string" == dispatch("get", ["incr_error_key"])
  end

  test "get_set should get previous value and set new value" do
    dispatch("set", ["my_key", "hello"])
    assert "hello" == dispatch("getset", ["my_key", "world"])
    assert "world" == dispatch("get", ["my_key"])
  end
end
