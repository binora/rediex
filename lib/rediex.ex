defmodule Rediex do
  @moduledoc false
  use Application
  use Supervisor
  alias Rediex.Cluster
  alias Rediex.Server
  require Logger

  @snapshot_path Application.get_env(:rediex, :snapshot_path)
  @backup_interval Application.get_env(:rediex, :snapshot_interval)
  @auto_backups? Application.get_env(:rediex, :auto_backups?)

  def start(_type, _args) do
    snapshot_workers =
      if @auto_backups? do
        [
          worker(
            Rediex.Database.Persistence.Snapshot,
            [@snapshot_path, @snapshot_interval]
          )
        ]
      else
        []
      end

    children =
      [
        supervisor(Registry, [:unique, :database_registry]),
        supervisor(Rediex.Database.Supervisor, [:database_supervisor]),
        worker(Task, [&Cluster.create/0], id: :make_clstr, restart: :temporary),
        {Task.Supervisor, name: :connection_supervisor},
        {Task, &Server.accept/0}
      ] ++ snapshot_workers

    Logger.info("Started rediex")
    Supervisor.start_link(children, strategy: :rest_for_one)
  end
end
