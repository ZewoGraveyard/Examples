import PostgreSQL
import CLibpq
import Foundation

final class TodoRepository {
   let db = Connection("postgresql://postgres:postgres@localhost/todos")
   
    init() throws {
        try db.open()
        try db.execute("CREATE TABLE IF NOT EXISTS todos (id SERIAL PRIMARY KEY, title VARCHAR(256), done BOOLEAN)")
    }

    deinit {
        db.close()
    }

    func insert(title: String, done: Bool) -> Todo {
        let result = try! db.execute("INSERT INTO todos (title, done) VALUES('\(title)', \(done ? "TRUE" : "FALSE")) RETURNING id")
        let id = result[0]["id"]!.string!
        return Todo(id: id, title: title, done: done)
    }

    var all: [Todo] {
        let result = try! db.execute("SELECT * FROM todos ORDER BY id")
        return result.map { row in
            return Todo(
                id: row["id"]!.string!,
                title: row["title"]!.string!,
                done: row["done"]!.boolean!
            )   
        }
    }

    subscript(id: String) -> Todo? {
        get {
            let result = try! db.execute("SELECT * FROM todos WHERE id = '\(id)'")
            if result.count > 0 {
                return Todo(
                    id: result[0]["id"]!.string!,
                    title: result[0]["title"]!.string!,
                    done: result[0]["done"]!.boolean!
                )
            }
            return nil
        }
        set {
            if let todo = newValue {
                try! db.execute("UPDATE todos SET title = '\(todo.title)', done = \(todo.done ? "TRUE" : "FALSE") WHERE id = '\(id)'")
            } else {
                try! db.execute("DELETE from todos WHERE id = '\(id)'")
            }
        }
    }
}