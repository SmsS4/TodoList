class Command {
    var base: String
    var help: String
    var argsCount: Int
    var minArgsCount: Int
    var maxArgsCount: Int

    init() {
        self.base = ""
        self.help = ""
        self.argsCount = 0
        self.minArgsCount = 0
        self.maxArgsCount = 0
    }

    func cleanCommand(command: String) -> [String] {
        var result: [String]
        result = []
        for str in command.split(separator: " ") {
            result.append(String(str))
        }
        return result
    }

    func execute(manager: Manager, command: String) -> Int {
        return 0
    }

    func run(manager: Manager, command: String) -> Int {
        if self.basicValidateCommand(command: command) {
            return self.execute(manager: manager, command: command)
        }
        return 0
    }

    func basicValidateCommand(command: String) -> Bool {
        let args = self.cleanCommand(command: command)
        if self.minArgsCount != 0 && args.count < self.minArgsCount {
            print("Invalid number of args")
            return false
        }
        if self.argsCount != 0 && args.count != self.argsCount {
            print("Invalid number of args")
            return false
        }
        if self.maxArgsCount != 0 && args.count > self.maxArgsCount {
            print("Invalid number of args")
            return false
        }
        return true
    }

    func showHelp() {
        print(self.help)
    }

    func matchCommand(command: String) -> Bool {
        return command.prefix(self.base.count) == self.base;
    }
}

class CreateTodoCommand: Command {
    override init() {
        super.init()
        self.base = "create todo"
        self.help = "create todo: Create a new todo"
        self.argsCount = 2
    }

    override func execute(manager: Manager, command: String) -> Int {
        print("Enter title: ")
        let title = readLine() ?? ""
        print("Enter priority: ")
        let priority = Int(readLine() ?? "-1") ?? -1
        if priority == -1 {
            print("Invalid integer")
            return 0
        }
        print("Enter description: ")
        let desc = readLine() ?? ""
        let todo = Todo(title: title, content: desc, priority: priority)
        manager.addTodo(todo: todo)
        print("New item added successfully")
        return 0
    }
}

class EditTodoCommand: Command {
    override init() {
        super.init()
        self.base = "edit "
        self.help = "edit <todo-id>: Edit todo"
        self.argsCount = 2
    }

    override func execute(manager: Manager, command: String) -> Int {
        let cmdParts = self.cleanCommand(command: command)
        let tid = Int(cmdParts[1]) ?? -1
        if manager.isTodoIndexValid(uid: tid) == false {
            print("Invalid id")
            return 0
        }
        print("Enter title: ")
        let title = readLine() ?? ""
        print("Enter priority: ")
        let priority = Int(readLine() ?? "-1") ?? -1
        if priority == -1 {
            print("Invalid integer")
            return 0
        }
        print("Enter description: ")
        let desc = readLine() ?? ""
        let todo = Todo(title: title, content: desc, priority: priority)
        manager.editTodo(index: tid, newTodo: todo)
        print("Todo edited successfully")
        return 0
    }
}

class DeleteTodoCommand: Command {
    override init() {
        super.init()
        self.base = "delete "
        self.help = "delete <todo-id>: Delete todo"
        self.argsCount = 2
    }

    override func execute(manager: Manager, command: String) -> Int {
        let cmdParts = self.cleanCommand(command: command)
        let tid = Int(cmdParts[1]) ?? -1
        if manager.isTodoIndexValid(uid: tid) == false {
            print("Invalid id")
            return 0
        }
        manager.deleteTodo(index: tid)
        print("Todo deleted successfully")
        return 0
    }
}

class ListTodosCommand: Command {
    override init() {
        super.init()
        self.base = "list"
        self.help = "list [<group>]: List available todos"
        self.maxArgsCount = 2
    }

    override func execute(manager: Manager, command: String) -> Int {
        let cmdParts = self.cleanCommand(command: command)
        var todos: [Todo]
        if cmdParts.count == 1 {
            todos = manager.showTodos()
        } else {
            if manager.isValidGroup(name: cmdParts[1]) {
                todos = manager.showGroupTodos(name: cmdParts[1])
            } else {
                print("Invalid group name")
                return 0
            }
        }
        printTodos(todos: todos)
        return 0
    }
}

class SortTodosCommand: Command {
    override init() {
        super.init()
        self.base = "sort by "
        self.help = "sort by title/creation/priority az/za: Sort todos"
        self.argsCount = 4
    }

    override func execute(manager: Manager, command: String) -> Int {
        let cmdParts = self.cleanCommand(command: command)
        var sortBy: SortBy
        if cmdParts[2] == "title" {
            sortBy = SortBy.title
        } else if cmdParts[2] == "creation" {
            sortBy = SortBy.createDate
        } else if cmdParts[2] == "priority" {
            sortBy = SortBy.priority
        } else {
            print("Sort by WHAAAT?!")
            return 0
        }
        if cmdParts[3] == "az" {
            manager.sort(sortBy: sortBy, ascending: true)
        } else if cmdParts[3] == "za" {
            manager.sort(sortBy: sortBy, ascending: false)
        } else {
            print("Invalid order. Enter az/za.")
            return 0
        }
        return 0
    }
}

class CreateGroupCommand: Command {
    override init() {
        super.init()
        self.base = "create group "
        self.help = "create group <name>: Create a new group"
        self.argsCount = 3
    }

    override func execute(manager: Manager, command: String) -> Int {
        let cmdParts = self.cleanCommand(command: command)
        if manager.isValidGroup(name: cmdParts[2]) {
            print("Group alread exists")
            return 0
        }
        manager.createGroup(name: cmdParts[2])
        print("Group created successfully")
        return 0
    }
}

class AddTodoToGroupCommand: Command {
    override init() {
        super.init()
        self.base = "add "
        self.help = "add <group> <todo-id> [<todo-id> ...]: Add todos to group"
        self.minArgsCount = 3
    }

    override func execute(manager: Manager, command: String) -> Int {
        let cmdParts = self.cleanCommand(command: command)
        let group = cmdParts[1]
        if manager.isValidGroup(name: group) == false {
            print("Invalid group")
            return 0
        }
        var tids: [Int]
        tids = []
        for tid_str in cmdParts.suffix(cmdParts.count - 2) {
            let tid = Int(tid_str) ?? -1
            if manager.isTodoIndexValid(uid: tid) == false {
                print("Invalid todo index")
                return 0
            }
            tids.append(tid)
        }
        manager.addMultiTodoToGroup(indexes: tids, name: group)
        print("Items added to group successfully")
        return 0
    }
}

class ListGroupsCommand: Command {
    override init() {
        super.init()
        self.base = "glist"
        self.help = "glist: List groups"
        self.argsCount = 1
    }

    override func execute(manager: Manager, command: String) -> Int {
        print("List of groups:")
        for group in manager.showGroups() {
            print(group)
        }
        return 0
    }
}

class ExitCommand: Command {
    override init() {
        super.init()
        self.base = "exit"
        self.help = "exit: Exit"
        self.argsCount = 1
    }

    override func execute(manager: Manager, command: String) -> Int {
        return 1
    }
}
