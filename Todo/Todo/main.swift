import HTTP
import HTTPRouter
import HTTPJSON
import HTTPMiddleware
import LoggerMiddleware
import JSONParserMiddleware
import Epoch

let router = HTTPRouter(basePath: "/api/v1") { route in
    route.get("/version") { _ in
        return HTTPResponse(status: .OK, json: ["version": "1.0.0"])
    }

    route.resources("/todo") { resources in
        let todo = TodoResource()
        resources.index(todo.index)
        resources.create(parseJSON >>> todo.create)
        resources.show(todo.show)
        resources.update(parseJSON >>> todo.update)
        resources.destroy(todo.destroy)
    }
} >>> log

let server = HTTPServer(port: 8080, responder: router)
server.start()