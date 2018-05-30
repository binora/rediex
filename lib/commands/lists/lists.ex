defmodule Rediex.Commands.Lists do

    def lpush(db, args) do
        GenServer.call(db, {:lists, :lpush, args})
    end

    def lrange(db, args) do
        GenServer.call(db, {:lists, :lrange, args})
    end




end