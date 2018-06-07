defmodule Rediex.Cluster do
  @moduledoc false
  @limit 16_384
  @size Application.get_env(:rediex, :cluster_size)

  def crc16(key) do
    CRC.crc(:crc_16_xmodem, key) |> Integer.mod(@limit)
  end

  def decide_database(key) do
    slot_size = round(@limit / @size)

    key
    |> crc16
    |> (&(&1 / slot_size)).()
    |> Float.ceil()
    |> round
  end

  def create do
    {:ok, do_create(@limit, @size)}
  end

  defp do_create(_, 1), do: create_database("db_1")

  defp do_create(limit, size) when size > limit,
    do: {:error, "#{size} cannot be greater than #{limit}"}

  defp do_create(_, size) do
    1..size |> Enum.each(&create_database/1)
  end

  defp create_database(index) do
    Supervisor.start_child(:database_supervisor, ["db_#{index}", %{}])
  end
end
