defmodule Rediex.Plug.VerifyCommand do
  alias Plug.BadRequestError

  def init(options), do: options

  def call(%Plug.Conn{body_params: %{"command" => command}} = conn, options) do
    if String.to_atom(command) not in options[:commands] do
      raise BadRequestError.exception("Command not implemented")
    end
    conn
  end

end
