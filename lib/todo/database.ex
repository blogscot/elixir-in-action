defmodule Todo.Database do
  use GenServer

  def init(db_folder) do
    {:ok, start_workers(db_folder)}
  end

  def start_workers(db_folder) do
    for index <- 0..2, into: Map.new do
      {:ok, pid} = Todo.DatabaseWorker.start(db_folder)
      {index, pid}
    end
  end

  def handle_call({:get_worker, key}, _from, workers) do
    index = :erlang.phash2(key, 3) # Index is 0..2
    {:reply, workers[index], workers}
  end

  # Client API

  def start(db_folder) do
    GenServer.start(__MODULE__, db_folder, name: :database_server)
  end

  def store(key, data) do
    key
    |> get_worker
    |> Todo.DatabaseWorker.store(key, data)
  end

  def get(key) do
    key
    |> get_worker
    |> Todo.DatabaseWorker.get(key)
  end

  defp get_worker(key) do
    GenServer.call(:database_server, {:get_worker, key})
  end

end