defmodule Rediex.Plug.VerifyCommandTest do
  use ExUnit.Case
  use Plug.Test

  alias Rediex.Plug.VerifyCommand

  @opts VerifyCommand.init(%{commands: [:command]})

  test "raises BadRequestError for invalid command" do
    data = %{command: "invalid-command", args: ["key", "value"]}
    conn = conn(:post, "/", data)
    assert_raise Plug.BadRequestError, fn ->
      VerifyCommand.call(conn, @opts)
    end
  end


end
