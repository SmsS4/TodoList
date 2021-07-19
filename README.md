# TodoList

97110144: Seyed Mahdi Sadegh Shobeiri
96109866: Majid Graooci

## run

run ``run.sh`` for running program in linux.  
```
cat core.swift commands.swift ui.swift main.swift > all.swift
swift all.swift
rm all.swift
```

## Comamnds

### help
Show list of comamnds
```
Available commands:
        create todo: Create a new todo
        edit <todo-id>: Edit todo
        delete <todo-id>: Delete todo
        list [<group>]: List available todos
        sort by title/creation/priority az/za: Sort todos
        create group <name>: Create a new group
        add <group> <todo-id> [<todo-id> ...]: Add todos to group
        glist: List groups
        exit: Exit
```

### create todo
Create a new todo  
after that programm ask you for Title, Priority, Desceription.
```
> create todo
Enter title: 
Test
Enter priority: 
4
Enter description: 
rr
New item added successfully
```

### list [<group>]
List available todos.  
group is optional.  
first coloum is id of todo, second is priority, third is Title and last coloum is description.
```
> list  
0 - 4 - Test : rr
```

### edit <todo-id>
Edit todo  
```
> edit 0
Enter title: 
new title
Enter priority: 
2 
Enter description: 
new desc
Todo edited successfully
```

### delete <todo-id>
Delete todo
```
> delete 0
Todo deleted successfully
```
### sort by title/creation/priority az/za
Sort todos.  
you have to call list for showing todos.  
creation is for sorting by create time.  
and az/za specify thay sorting should be increasing or decreasing.
```
> sort by title az
> list
2 - 1 - t1 : d1
3 - 2 - t2 : d2
> sort by creation za
> list
3 - 2 - t2 : d2
2 - 1 - t1 : d1
> list name_of_group
0 - 1 - t1 : d1
1 - 2 - t2 : d2
```
### create group <name>
Create a new group.
Note: name can't have space
```
> create group name_of_group
Group created successfully
```
### add <group> <todo-id> [<todo-id> ...]
Add todos to group
```
> add name_of_group 2 3
Items added to group successfully
> add name_of_group 4
Items added to group successfully
```
### glist
Show list groups
```
> glist
List of groups:
name_of_group
```
### exit
Exits programm.
