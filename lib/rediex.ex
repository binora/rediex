defmodule Rediex do
  use Application
  require Logger

  def start(_type, _args) do
    port = Application.get_env(:rediex, :cowboy_port, 8080)
    children = [
      Plug.Adapters.Cowboy.child_spec(:http, RediexRouter, [], port: 8080)
    ]

    Logger.info("Started rediex")

    Supervisor.start_link(children, strategy: :one_for_one)
  end

end
