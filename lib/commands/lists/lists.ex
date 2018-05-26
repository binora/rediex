defmodule Rediex.Commands.Lists do

    def lpush(key, values) do
        GenServer.call(:database, {:lists, :lpush, [key | values]})
    end

    def lrange(key, offsets) do
        GenServer.call(:database, {:lists, :lrange, [key | offsets]})
    end




end