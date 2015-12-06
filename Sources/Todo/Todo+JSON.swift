import JSON

extension Todo {
    func toJSON() -> JSON {
         return [
            "id": JSON.from(id),
            "title": JSON.from(title),
            "done": JSON.from(done)
        ]
    }

    static func toJSON(todo: Todo) -> JSON {
        return todo.toJSON()
    }
}

