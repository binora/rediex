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
      worker(Task, [&Cluster.create/0], restart: :temporary)
    ]
    Logger.info("Started rediex")
    Supervisor.start_link(children, strategy: :one_for_one)
  end

end
