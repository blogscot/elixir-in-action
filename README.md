
## Starting the application

```
Todo.Supervisor.start_link
Starting database server
Starting database worker
Starting database worker
Starting database worker
Starting to-do cache.
{:ok, #PID<0.125.0>}
```

## Create or retrieve a list

```
 bobs_list = Todo.Cache.server_process("bobs_list")
#PID<0.132.0>
 ```

 ## Viewing a list's entries

 ```
 Todo.Server.entries(bobs_list, {2013, 12, 19})
 [%{date: {2013, 12, 19}, id: 1, title: "Dentist"},
 %{date: {2013, 12, 19}, id: 2, title: "Football"}]
 ```