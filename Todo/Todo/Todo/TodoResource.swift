import HTTP
import HTTPRouter
import HTTPJSON
import JSON
import JSONParserMiddleware

final class TodoResource: HTTPResourceType {
    private var todoItems: [TodoItem] = []

    func index(request: HTTPRequest) -> HTTPResponse {
        let json: JSON = [
            "todoItems": .ArrayValue(todoItems.map(TodoItem.toJSON))
        ]
        return HTTPResponse(status: .OK, json: json)
    }

    func create(request: HTTPRequest) -> HTTPResponse {
        guard let json = request.JSONBody, title = json["title"]?.stringValue else {
            return HTTPResponse(status: .BadRequest)
        }
        let todoItem = TodoItem(title: title)
        todoItems.append(todoItem)
        return HTTPResponse(status: .OK, json: todoItem.toJSON())
    }

    func show(request: HTTPRequest) -> HTTPResponse {
        guard let todoItem = todoItems.filter({$0.id == request.parameters["id"]!}).first else {
            return HTTPResponse(status: .NotFound)
        }
        return HTTPResponse(status: .OK, json: todoItem.toJSON())
    }

    func update(request: HTTPRequest) -> HTTPResponse {
        guard let (index, todoItem) = todoItems.enumerate().filter({$0.1.id == request.parameters["id"]}).first else {
            return HTTPResponse(status: .NotFound)
        }
        guard let json = request.JSONBody,
            title = json["title"]?.stringValue,
            done = json["done"]?.boolValue else {
            return HTTPResponse(status: .BadRequest)
        }
        let updatedTodoItem = TodoItem(id: todoItem.id, title: title, done: done)
        todoItems.removeAtIndex(index)
        todoItems.append(updatedTodoItem)
        return HTTPResponse(status: .NoContent)
    }

    func destroy(request: HTTPRequest) -> HTTPResponse {
        guard let (index, _) = todoItems.enumerate().filter({$0.1.id == request.parameters["id"]}).first else {
            return HTTPResponse(status: .NotFound)
        }
        todoItems.removeAtIndex(index)
        return HTTPResponse(status: .NoContent)
    }
}