defmodule Todo.Cache do
  use GenServer

  # Server

  def init(_) do
    {:ok, nil}
  end

  def handle_call({:server_process, todo_list_name}, _from, state) do
    # Check again if the server exists
    todo_server_pid = case Todo.Server.whereis(todo_list_name) do
      :undefined ->
        case Todo.ServerSupervisor.start_child(todo_list_name) do
          {:ok, pid} -> pid
          error -> throw error  #Oh oh!
        end

      pid -> pid
    end
    {:reply, todo_server_pid, state}
  end

  # Client API

  def start_link do
    IO.puts "Starting to-do cache."
    GenServer.start_link(__MODULE__, nil, name: :todo_cache)
  end

  def server_process(todo_list_name) do
    case Todo.Server.whereis(todo_list_name) do
      :undefined ->
        # Create a new server
        GenServer.call(:todo_cache, {:server_process, todo_list_name})

      pid -> pid
    end
  end

end
