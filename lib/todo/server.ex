defmodule Todo.Server do
  use GenServer

  def init(_) do
    {:ok, Todo.List.new}
  end

  def handle_cast({:add_entry, new_entry}, todo_list) do
    {:noreply, Todo.List.add_entry(todo_list, new_entry)}
  end

  def handle_cast({:delete, entry_id}, todo_list) do
    {:noreply, Todo.List.delete_entry(todo_list, entry_id)}
  end

  def handle_call({:entries, date}, _from, todo_list) do
    {:reply, Todo.List.entries(todo_list, date), todo_list}
  end

  # Client API

  def start do
    GenServer.start(Todo.Server, nil)
  end
  def add_entry(pid, %{date: _date, title: _title}=new_entry) do
    GenServer.cast(pid, {:add_entry, new_entry})
  end
  def entries(pid, date) do
    GenServer.call(pid, {:entries, date})
  end
  def delete(pid, entry_id) do
    GenServer.cast(pid, {:delete, entry_id})
  end

end