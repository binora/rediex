defmodule Rediex.Cluster do
  @limit 16384
  @size Application.get_env(:rediex, :cluster_size)

  def crc16(key) do
    CRC.crc(:crc_16_xmodem, key)
    |> Integer.mod(@limit)
  end

  def hello do
    IO.inspect('hello')
  end

  def create_cluster when @size > @limit,
    do: {:error, "#{@size} cannot be greater than #{@limit}"}

  def create_cluster when @size == 1, do: create_database("db_#{@size}", %{max_crc: @limit})

  def create_cluster do
    slot_size = round(@limit / @size)

    for i <- 1..(@size - 1) do
      create_database("db_#{i}", %{max_crc: slot_size * i})
    end
    create_database("db_#{@size}", %{max_crc: @limit})
  end

  defp create_database(name, state) do
    Supervisor.start_child(:database_supervisor, [name, state])
  end
end
