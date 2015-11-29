import HTTP
import HTTPRouter
import HTTPJSON
import JSON
import JSONParserMiddleware

final class TodoResource: HTTPResourceType {
    private var todoItems: [String: TodoItem] = [:]

    func index(request: HTTPRequest) -> HTTPResponse {
        let json: JSON = ["todoItems": JSON.from(todoItems.values.map(TodoItem.toJSON))]
        return HTTPResponse(status: .OK, json: json)
    }

    func create(request: HTTPRequest) -> HTTPResponse {
        guard let json = request.JSONBody, title = json["title"]?.stringValue else {
            return HTTPResponse(status: .BadRequest)
        }
        let todoItem = TodoItem(title: title)
        todoItems[todoItem.id] = todoItem
        return HTTPResponse(status: .OK, json: todoItem.toJSON())
    }

    func show(request: HTTPRequest) -> HTTPResponse {
        guard let todoItem = todoItems[request.parameters["id"]!] else {
            return HTTPResponse(status: .NotFound)
        }
        return HTTPResponse(status: .OK, json: todoItem.toJSON())
    }

    func update(request: HTTPRequest) -> HTTPResponse {
        guard let todoItem = todoItems[request.parameters["id"]!] else {
            return HTTPResponse(status: .NotFound)
        }
        guard let json = request.JSONBody,
            title = json["title"]?.stringValue,
            done = json["done"]?.boolValue else {
                return HTTPResponse(status: .BadRequest)
        }
        todoItems[todoItem.id] = TodoItem(id: todoItem.id, title: title, done: done)
        return HTTPResponse(status: .NoContent)
    }

    func destroy(request: HTTPRequest) -> HTTPResponse {
        guard let todoItem = todoItems[request.parameters["id"]!] else {
            return HTTPResponse(status: .NotFound)
        }
        todoItems[todoItem.id] = nil
        return HTTPResponse(status: .NoContent)
    }
}