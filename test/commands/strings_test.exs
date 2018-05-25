defmodule Rediex.Commands.StringsTest do
  use ExUnit.Case
  alias Rediex.Commands.Strings
  alias Rediex.Commands.Strings.Impl

  test "get command should return nil for unset key" do
    assert nil == Strings.get("unsetkey")
  end

  test "set command should set the given value for the key" do
    assert "OK" == Strings.set("key", "value")
    assert "value" == Strings.get("key")
  end

  test "incr command should set unset key to 1" do
    Strings.incr("unsetkey1")
    assert 1 == Strings.get("unsetkey1")
  end

  test "decr command should set unset key to -1" do
    Strings.incr("unsetkey2")
    assert 1 == Strings.get("unsetkey2")
  end

  test "incr should increment a key by 1" do
    Strings.set("incr_key", 10)
    Strings.incr("incr_key")

    assert 11 == Strings.get("incr_key")
  end

  test "decr should decrement a key by 1" do
    Strings.set("decr_key", 20)
    Strings.decr("decr_key")

    assert 19 == Strings.get("decr_key")
  end

  test "incryby should increment a key by given step" do

    Strings.set("incr_by_key", 10)
    Strings.incr_by("incr_by_key", 10)

    assert 20 == Strings.get("incr_by_key")
  end

  test "decrby should increment a key by given step" do
    Strings.set("decr_by_key", 10)
    Strings.decr_by("decr_by_key", 10)

    assert 0 == Strings.get("decr_by_key")
  end

  test "incr should not increment in case of strings and throw an error" do

    Strings.set("incr_error_key", "string")
    error = Strings.incr("incr_error_key")

    assert error == Impl.not_an_integer()
    assert "string" == Strings.get("incr_error_key")
  end

  test "get_set should get previous value and set new value" do
    Strings.set("my_key", "hello")
    assert "hello" == Strings.get_set("my_key", "world")
    assert "world" == Strings.get("my_key")
  end
end
