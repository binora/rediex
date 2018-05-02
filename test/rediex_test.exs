defmodule RediexTest do
  use ExUnit.Case
  doctest Rediex

  test "greets the world" do
    assert Rediex.hello() == :world
  end
end
