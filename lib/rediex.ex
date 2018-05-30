defmodule Rediex do
  use Application
  use Supervisor
  alias Rediex.Cluster
  require Logger


  @cluster_upper_limit 16384

  def start(_type, _args) do
    cluster_size = Application.get_env(:rediex, :cluster_size)
    children = [
      supervisor(Registry, [:unique, :database_registry]),
      supervisor(Rediex.Database.Supervisor, []),
      worker(Task, [&Cluster.create/0], restart: :temporary)
    ]
    Logger.info("Started rediex")
    Supervisor.start_link(children, strategy: :one_for_one)
  end

end
