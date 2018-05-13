defmodule Rediex.Dispatcher do
  alias Rediex.Commands.{Set, Get}

  def valid_commands do
    [
      {:set, &Set.set/2},
      {:get, &Get.get/1}
    ]
  end

  def dispatch_command(%{"command" => command, "args" => _args}) do
    {:ok, command}
  end

end
