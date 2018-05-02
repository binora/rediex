defmodule RediexRouter do
  use Plug.Router
  alias Rediex.Plug.VerifyCommand
  import Rediex.Command.Dispatcher


  plug Plug.Parsers,
    parsers: [:json],
    pass: ["*/*"],
    json_decoder: Jason


  plug(
    VerifyCommand,
    commands: valid_commands()
  )


  plug :match
  plug :dispatch


  post "/" do
    case dispatch_command(conn.body_params) do
      {:ok, result} -> send_resp(conn, 200, result)
      {:err, _}  -> send_resp(conn, 400, "Something went wrong")
    end
  end

end
