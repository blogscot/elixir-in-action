defmodule Todo.Database do
  @pool_size 3

  # Client API

  def start_link(db_folder) do
    IO.puts "Starting database server"
    Todo.PoolSupervisor.start_link(db_folder, @pool_size)
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
    :erlang.phash2(key, @pool_size)
  end

end