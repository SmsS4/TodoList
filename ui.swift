class Shell {
    var manager: Manager
    var commands: [Command]

    init() {
        self.manager = Manager()
        self.commands = []
        self.commands.append(CreateTodoCommand())
        self.commands.append(EditTodoCommand())
        self.commands.append(DeleteTodoCommand())
        self.commands.append(ListTodosCommand())
        self.commands.append(SortTodosCommand())
        self.commands.append(CreateGroupCommand())
        self.commands.append(AddTodoToGroupCommand())
        self.commands.append(ListGroupsCommand())
        self.commands.append(ExitCommand())
    }

    func run() {
        while true {
            print(">", terminator: " ")
            if self.parseCommand() != 0 {
                break
            }
        }
    }

    func parseCommand() -> Int {
        let cmd = readLine() ?? "exit"
        for command in self.commands {
            if command.matchCommand(command: cmd) {
                return command.run(manager: self.manager, command: cmd)
            }
        }
        print("Invalid command")
        self.showHelp()
        return 0
    }

    func showHelp() {
        print("Available commands:")
        for command in self.commands {
            print("\t", terminator: "")
            command.showHelp()
        }
    }
}
