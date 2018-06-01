defmodule Rediex do
  @moduledoc false
  use Application
  use Supervisor
  alias Rediex.Cluster
  require Logger

  def start(_type, _args) do
    children = [
      supervisor(Registry, [:unique, :database_registry]),
      supervisor(Rediex.Database.Supervisor, []),
      Supervisor.child_spec({Task, &Cluster.create/0}, restart: :temporary),
      supervisor(Task.Supervisor, [], name: :client_supervisor),
      Supervisor.child_spec({Task, &Rediex.Server.accept/0}, id: :rediex_server)
    ]
    Logger.info("Started rediex")
    Supervisor.start_link(children, strategy: :one_for_one)
  end

end
