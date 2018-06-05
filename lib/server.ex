defmodule Rediex.Server do
  @moduledoc false
  alias Rediex.Commands.Dispatcher

  @port Application.get_env(:rediex, :port)
  @ip Application.get_env(:rediex, :ip)

  def accept do
    {:ok, socket} =
      :gen_tcp.listen(
        @port,
        [:binary, active: false, reuseaddr: true, ip: @ip]
      )

    do_accept(socket)
  end

  defp do_accept(socket) do
    {:ok, client} = :gen_tcp.accept(socket)

    {:ok, pid} =
      Task.Supervisor.start_child(
        :connection_supervisor,
        fn -> serve(client) end
      )

    :ok = :gen_tcp.controlling_process(client, pid)
    do_accept(socket)
  end

  defp serve(client) do
    client
    |> receive_data
    |> reply(client)

    serve(client)
  end

  defp receive_data(client) do
    :gen_tcp.recv(client, 0)
  end

  defp reply({:error, :closed}, _) do
    exit(:shutdown)
  end

  defp reply({:ok, input}, client) do
    result =
      case Dispatcher.parse(input) do
        [] -> ""
        [command | args] -> Dispatcher.dispatch(command, args)
      end

    :gen_tcp.send(client, to_string(result) <> "\r\n")
  end
end
