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

    func findTodoIndex(uid: Int) -> Int {
        for (idx, todo) in self.todoList.enumerated() {
            if todo.uid == uid {
                return idx
            }
        }
        return -1
    }

    func isTodoIndexValid(uid: Int) -> Bool {
        return self.findTodoIndex(uid: uid) != -1
    }

    func addTodo(todo: Todo) {
        self.todoList.append(todo)
    }

    func showTodos() -> [Todo]{
        return self.todoList;
        // return Todo.listToString(todos: self.todoList)
    }

    func editTodo(index: Int, newTodo: Todo){
        let idx = self.findTodoIndex(uid: index)
        self.todoList[idx].title = newTodo.title
        self.todoList[idx].content = newTodo.content
        self.todoList[idx].priority = newTodo.priority
        // self.todoList[idx] = newTodo;
    }

    func deleteTodo(index: Int) {
        let idx = self.findTodoIndex(uid: index)
        let todo = self.todoList[idx]
        self.todoList.remove(at:idx)
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
        for (_, group) in self.groups {
            group.todos.sort {
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
    }
    func createGroup(name: String){
        if self.groups[name] != nil{
            print("Group with name \(name) already exists")
            return
        }
        self.groups[name] = Group()
    }


    func addTodoToGroup(index: Int, name: String){
        let idx = self.findTodoIndex(uid: index)
        let todos: [Todo]? = self.groups[name]?.todos
        for todo in todos! {
            if(todo.uid == self.todoList[idx].uid){
                print("Todo is already in this group")
                return
            }
        }
        self.groups[name]?.todos.append(self.todoList[idx])
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

    func isValidGroup(name: String) -> Bool {
        return self.groups[name] != nil
    }

    func showGroupTodos(name: String) -> [Todo]{
        if self.groups[name] != nil {
            return (self.groups[name]?.todos)!
        }

        return []
    }

}

func printTodos(todos: [Todo]){
    for todo in todos{
        print(todo.uid, "-", todo.priority, "-", todo.title, ":", todo.content)
    }
    print("")
}

