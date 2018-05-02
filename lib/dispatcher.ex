defmodule Rediex.Command.Dispatcher do

  def valid_commands do
    [
      :set,
      :get,
      :inc,
      :decr
    ]
  end

  def dispatch_command(%{"command" => command, "args" => _args} = _body_params) do
    {:ok, command}
  end

end
