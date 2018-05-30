defmodule Rediex.Database.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: :database_supervisor)
  end


  def init([]) do
    children = [
      worker(Rediex.Database, [])
    ]

    supervise(children, strategy: :simple_one_for_one)
  end

end
