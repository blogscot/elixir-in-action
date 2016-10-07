defmodule Todo.Database do
  use GenServer

  def init(db_folder) do
    # start testing with a single worker
    Todo.DatabaseWorker.start(db_folder)  # returns {:ok, pid}
  end

  def handle_call({:get_worker, _key}, _from, worker) do
    {:reply, worker, worker}
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