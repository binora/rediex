defmodule Rediex.Server do
  @moduledoc false

  @port Application.get_env(:rediex, :port)
  @ip Application.get_env(:rediex, :ip)

  def accept do
    {:ok, socket} = :gen_tcp.listen(@port, [:binary, active: false, reuseaddr: true, ip: @ip])
    accept(socket)
  end

  defp accept(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    {:ok, pid} = Task.Supervisor.start_child(:client_supervisor, fn -> serve(client) end)
    :ok = :gen_tcp.controlling_process(client, pid)
    accept(socket)
  end

  defp receive_data(client) do
    {:ok, data} = :gen_tcp.recv(client, 0)
    data
  end

  defp reply(data, client) do
    :gen_tcp.send(client, data)
  end

  defp serve(client) do
    client
    |> receive_data
    |> reply(client)

    serve(client)
  end
end
