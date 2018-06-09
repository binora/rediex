# Rediex
As part of learning elixir and OTP, I decided to implement the functionality of redis in elixir.

# Running Rediex
start the server:
```
mix run --no-halt
```

I haven't written a cli client yet but you can use ```telnet``` to connect to rediex
```
telnet <ip> <port>
```
default ip: `127.0.0.1`

default port: `6380`

# Commands implemented so far

## Strings
- GET
- SET
- GETSET
- INCR
- INCRBY
- DECR
- DECRBY


## Lists

- LPUSH



I'll update the README as and when i add more commands


# Application details

The Application consists of:
- tcp connection supervisor
- database supervisor
- snapshot worker

## TCP Connection supervisor
- rediex uses `:gen_tcp` to spin up a tcp server
- tcp connection supervisor creates a new `Task` for every new  connection from a client
- the code used in this module is reference from the [official mix otp guide](https://elixir-lang.org/getting-started/mix-otp/introduction-to-mix.html)


## Database supervisor
- the database supervisor spins up N databases(genservers) to execute incoming commands
- Each genserver stores a certain range of keys depending the `cluster_size` in `config.exs`

## Database registry
- This uses `Registry` from elixir to register the required databases (genservers)

## Snapshot worker
- This is a genserver that calls itself every `snapshot_interval`, collects state from currently running genservers and saves the merged state in `snapshot_path`


# Supervision tree
![Supervision Tree](assets/images/supervision_tree.png?raw=true "Title")


# Contributing
There are lots of commands to be implemented . You can start with the simple ones and create a PR

## Writing a command
- You need to register the command in `dispatcher.ex` in the `@available_commands` attribute 
- Each command belongs to a Module eg. Strings, Lists
- Each Module is just an API to interact with a particular `db` (genserver). So you need to add a function that wraps a GenServer call for your command
- Each Command is implemented in `ModuleName.Impl` . This is where you actually write some logic for the command
- Write a corresponding test for the command you implemented

## Running tests
```
mix test
```

## static code analysis
```
mix credo --strict
```

Please run tests and credo and make sure everything is fine before submitting a PR since they are part of the build process.



# TODO

- Add persistance (AOF ~~and snapshot~~)
- ~~tcp server to accept multiple clients~~
- sample cli client to interact with rediex




