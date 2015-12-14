import Core
import HTTP
import Middleware

let todoResources = TodoResources()

final class TodoResources {
    let todos = try! TodoRepository()

    func index(request: Request) -> Response {
        let json: JSON = ["todos": JSON.from(todos.all.map(Todo.toJSON))]
        return Response(status: .OK, json: json)
    }

    func create(request: Request) -> Response {
        guard let json = request.JSONBody, title = json["title"]?.stringValue else {
            return Response(status: .BadRequest)
        }
        let todo = todos.insert(title, done: false)
        return Response(status: .OK, json: todo.toJSON())
    }

    func show(request: Request) -> Response {
        guard let id = request.parameters["id"], todo = todos[id] else {
            return Response(status: .NotFound)
        }
        return Response(status: .OK, json: todo.toJSON())
    }

    func update(request: Request) -> Response {
        guard let id = request.parameters["id"] where todos[id] != nil else {
            return Response(status: .NotFound)
        }
        guard let json = request.JSONBody,
            title = json["title"]?.stringValue,
            done = json["done"]?.boolValue else {
                return Response(status: .BadRequest)
        }
        todos[id] = Todo(id: id, title: title, done: done)
        return Response(status: .NoContent)
    }

    func destroy(request: Request) -> Response {
        guard let id = request.parameters["id"] where todos[id] != nil else {
            return Response(status: .NotFound)
        }
        todos[id] = nil
        return Response(status: .NoContent)
    }
}
