import Foundation


class Todo {
    var title: String
    var content: String
    var priority: Int
    var createDate: Date
    var uid: Int
    static var counter: Int = 0
    
    init(title: String, content: String, priority: Int) {
        self.title = title
        self.content = content
        self.priority = priority
        self.createDate = Date()
        self.uid = Todo.counter
        Todo.counter += 1
    }
    
    func toString() -> String{
        return "\(title), \(content), \(priority), \(createDate)\n"
    }
    
    static func listToString(todos:[Todo]) -> String {
        var result = "Index, Title, Content, Priority, CreateDate\n"
        var i = 0
        for todo in todos {
            result += "i, " + todo.toString()
            i += 1
        }
        return result
    }
    
}

class Group {
    var todos: [Todo] = []
}

enum SortBy {
    case title, createDate, priority
}


class Manager{
    var todoList: [Todo] = []
    var groups: [String: Group] = [:]
    
    func addTodo(todo: Todo) {
        self.todoList.append(todo)
    }
    
    func showTodos() -> [Todo]{
        return self.todoList;
        // return Todo.listToString(todos: self.todoList)
    }
    
    func editTodo(index: Int, newTodo: Todo){
        self.todoList[index].title = newTodo.title
        self.todoList[index].content = newTodo.content
        self.todoList[index].priority = newTodo.priority
        self.todoList[index] = newTodo;
    }
    
    func deleteTodo(index: Int) {
        var todo = self.todoList[index]
        self.todoList.remove(at:index)
        for group in self.groups{
            for i in 0...group.value.todos.count-1 {
                if ((group.value.todos[i]).uid == todo.uid){
                    group.value.todos.remove(at: i)
                    break
                }
            }
        }
            
    }
    func sort(sortBy: SortBy, ascending: Bool) {
        self.todoList.sort {
            switch (sortBy, ascending) {
                case (SortBy.title, true):
                    return $0.title < $1.title
                case (SortBy.title, false):
                    return $0.title > $1.title
                case (SortBy.priority, true):
                    return $0.priority < $1.priority
                case (SortBy.priority, false):
                    return $0.priority > $1.priority
                case (SortBy.createDate, true):
                    return $0.createDate < $1.createDate
                case (SortBy.createDate, false):
                    return $0.createDate > $1.createDate
                    
            }
        }
    }
    func createGroup(name: String){
        if self.groups[name] != nil{
            print("Group with name \(name) already exists")
            return
        }
        self.groups[name] = Group()
    }
    
    
    func addTodoToGroup(index: Int, name: String){
        var todos: [Todo]? = self.groups[name]?.todos
        for todo in todos! {
            if(todo.uid == self.todoList[index].uid){
                print("Todo is already in this group")
                return
            }
        }
        self.groups[name]?.todos.append(self.todoList[index])
    }
    
    func addMultiTodoToGroup(indexes: [Int], name: String) {
        for index in indexes{
            self.addTodoToGroup(index:index, name:name)
        }
    }
    
    func showGroups() -> [String]{
        var result: [String] = []
        for group in self.groups{
            result.append(group.key)
        }
        return result;
    }
    
    func showGroupTodos(name: String) -> [Todo]{
        if self.groups[name] != nil{
            return (self.groups[name]?.todos)!
        }
        
        return []
    }
    
}

func printTodos(todos: [Todo]){
    for todo in todos{
        print(todo.uid, todo.title, todo.content, todo.priority, todo.createDate)
    }
    print("\n\n")
}



var todo = Todo(title: "test", content: "cont", priority: 5)
var todo2 =  Todo(title: "title", content: "some other content", priority: 2)
var delay = readLine()
var todo3 = Todo(title: "poof", content: "blah blah", priority: 1000)
// print(Todo.listToString(todos:[todo, todo2]))
var manager = Manager()

manager.addTodo(todo: todo)
manager.addTodo(todo: todo2)
manager.addTodo(todo: todo3)
print(manager.showTodos(), "\n\n");


manager.sort(sortBy: SortBy.createDate, ascending: true);
printTodos(todos: manager.showTodos());
manager.sort(sortBy: SortBy.createDate, ascending: false);
printTodos(todos: manager.showTodos());


manager.sort(sortBy: SortBy.title, ascending: true);
printTodos(todos: manager.showTodos());
manager.sort(sortBy: SortBy.title, ascending: false);
printTodos(todos: manager.showTodos());


manager.sort(sortBy: SortBy.priority, ascending: true);
printTodos(todos: manager.showTodos());
manager.sort(sortBy: SortBy.priority, ascending: false);
printTodos(todos: manager.showTodos());


manager.createGroup(name: "g1")
manager.createGroup(name: "g2")
print(manager.showGroups(), "\n\n");
manager.addTodoToGroup(index: 0, name: "g2")
manager.addMultiTodoToGroup(indexes: [1, 2], name: "g1")
printTodos(todos: manager.showGroupTodos(name: "g1"))
printTodos(todos: manager.showGroupTodos(name: "g2"))

printTodos(todos: manager.showTodos())
manager.deleteTodo(index: 1)
printTodos(todos:manager.showTodos())

printTodos(todos: manager.showGroupTodos(name: "g1"))
printTodos(todos: manager.showGroupTodos(name: "g2"))

manager.editTodo(index: 0, newTodo: Todo(title: "tnew", content: "cnew", priority: 0))
printTodos(todos: manager.showTodos())

printTodos(todos: manager.showGroupTodos(name: "g1"))
printTodos(todos: manager.showGroupTodos(name: "g2"))





