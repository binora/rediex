defmodule Rediex do
  @moduledoc false
  use Application
  use Supervisor
  alias Rediex.Cluster
  alias Rediex.Server
  require Logger

  def start(_type, _args) do
    children = [
      supervisor(Registry, [:unique, :database_registry]),
      supervisor(Rediex.Database.Supervisor, [:database_supervisor]),
      worker(Task, [&Cluster.create/0], id: :make_cluster, restart: :temporary),
      {Task.Supervisor, name: :connection_supervisor},
      {Task, &Server.accept/0} 
    ]

    Logger.info("Started rediex")
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
