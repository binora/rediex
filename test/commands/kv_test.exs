defmodule Rediex.Commands.KVTest do
  use ExUnit.Case
  alias Rediex.Commands.KV
  alias Rediex.Database.KV.Impl

  test "get command should return nil for unset key" do
    assert nil == KV.get("unsetkey")
  end

  test "set command should set the given value for the key" do
    assert "OK" == KV.set("key", "value")
    assert "value" == KV.get("key")
  end

  test "incr command should set unset key to 1" do
    KV.incr("unsetkey1")
    assert 1 == KV.get("unsetkey1")
  end

  test "decr command should set unset key to -1" do
    KV.incr("unsetkey2")
    assert 1 == KV.get("unsetkey2")
  end

  test "incr should increment a key by 1" do
    KV.set("incr_key", 10)
    KV.incr("incr_key")

    assert 11 == KV.get("incr_key")
  end

  test "decr should decrement a key by 1" do
    KV.set("decr_key", 20)
    KV.decr("decr_key")

    assert 19 == KV.get("decr_key")
  end

  test "incryby should increment a key by given step" do

    KV.set("incr_by_key", 10)
    KV.incr_by("incr_by_key", 10)

    assert 20 == KV.get("incr_by_key")
  end

  test "decrby should increment a key by given step" do
    KV.set("decr_by_key", 10)
    KV.decr_by("decr_by_key", 10)

    assert 0 == KV.get("decr_by_key")
  end

  test "incr should not increment in case of strings and throw an error" do

    KV.set("incr_error_key", "string")
    result  = KV.incr("incr_error_key")

    assert result == Impl.not_an_integer()
    assert "string" == KV.get("incr_error_key")
  end

  test "get_set should get previous value and set new value" do
    KV.set("my_key", "hello")
    assert "hello" == KV.get_set("my_key", "world")
    assert "world" == KV.get("my_key")
  end
end
