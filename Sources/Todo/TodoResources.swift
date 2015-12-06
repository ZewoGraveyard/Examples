import HTTP
import HTTPRouter
import HTTPJSON
import JSON
import JSONParserMiddleware

final class TodoResources: HTTPResourceType {
    private var todos: [String: Todo] = [:]
    private var idCount = 0
    
    private func generateId() -> String {
        return "\(idCount++)"
    }

    func index(request: HTTPRequest) -> HTTPResponse {
        let json: JSON = ["todos": JSON.from(todos.values.map(Todo.toJSON))]
        return HTTPResponse(status: .OK, json: json)
    }

    func create(request: HTTPRequest) -> HTTPResponse {
        guard let json = request.JSONBody, title = json["title"]?.stringValue else {
            return HTTPResponse(status: .BadRequest)
        }
        let id = generateId()
        let todo = Todo(id: id, title: title, done: false)
        todos[id] = todo
        return HTTPResponse(status: .OK, json: todo.toJSON())
    }

    func show(request: HTTPRequest, id: String) -> HTTPResponse {
        guard let todo = todos[id] else {
            return HTTPResponse(status: .NotFound)
        }
        return HTTPResponse(status: .OK, json: todo.toJSON())
    }

    func update(request: HTTPRequest, id: String) -> HTTPResponse {
        guard todos[id] != nil else {
            return HTTPResponse(status: .NotFound)
        }
        guard let json = request.JSONBody,
            title = json["title"]?.stringValue,
            done = json["done"]?.boolValue else {
                return HTTPResponse(status: .BadRequest)
        }
        todos[id] = Todo(id: id, title: title, done: done)
        return HTTPResponse(status: .NoContent)
    }

    func destroy(request: HTTPRequest, id: String) -> HTTPResponse {
        guard todos[id] != nil else {
            return HTTPResponse(status: .NotFound)
        }
        todos[id] = nil
        return HTTPResponse(status: .NoContent)
    }
}