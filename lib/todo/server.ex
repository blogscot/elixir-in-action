defmodule Todo.Server do
  use GenServer

  def init(name) do
    {:ok, {name, Todo.Database.get(name) || Todo.List.new}}
  end

  def handle_cast({:add_entry, new_entry}, {name, todo_list}) do
    new_state = Todo.List.add_entry(todo_list, new_entry)
    Todo.Database.store(name, new_state)
    {:noreply, {name, new_state}}
  end

  def handle_cast({:delete, entry_id}, {_name, todo_list}) do
    {:noreply, Todo.List.delete_entry(todo_list, entry_id)}
  end

  def handle_call({:entries, date}, _from, {name, todo_list}) do
    {:reply, Todo.List.entries(todo_list, date), {name, todo_list}}
  end

  # Client API

  def start(list_name) do
    GenServer.start(Todo.Server, list_name)
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