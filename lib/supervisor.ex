defmodule Rediex.Database.Supervisor do
  @moduledoc false
  use Supervisor

  def start_link(name) do
    Supervisor.start_link(__MODULE__, [], name: name)
  end

  def init([]) do
    children = [
      worker(Rediex.Database, [])
    ]

    supervise(children, strategy: :simple_one_for_one)
  end

end
