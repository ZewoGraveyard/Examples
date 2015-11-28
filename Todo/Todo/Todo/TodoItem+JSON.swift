import JSON

extension TodoItem {
    func toJSON() -> JSON {
        let json: JSON = [
            "id": JSON.from(id),
            "title": JSON.from(title),
            "done": JSON.from(done)
        ]
        return json
    }

    static func toJSON(todoItem: TodoItem) -> JSON {
        return todoItem.toJSON()
    }

    init?(json: JSON) {
        guard let
            title = json["title"]?.stringValue,
            id = json["id"]?.stringValue,
            done = json["done"]?.boolValue else {
                return nil
        }
        self.id = id
        self.title = title
        self.done = done
    }
}

