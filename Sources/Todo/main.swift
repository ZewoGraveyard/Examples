import HTTP
import HTTPRouter
import HTTPJSON
import HTTPMiddleware
import LoggerMiddleware
import JSONParserMiddleware
import Epoch
import CHTTPParser
import CLibvenice
import Glibc

let router = HTTPRouter("/api/v1") { route in
    route.get("/version") { _ in
        return HTTPResponse(status: .OK, json: ["version": "1.0.0"])
    }

    let todo = TodoResources()
    route.get("/todos", todo.index)
    route.post("/todos", parseJSON >>> todo.create)
    route.get("/todos/:id", todo.show)
    route.put("/todos/:id", parseJSON >>> todo.update)
    route.delete("/todos/:id", todo.destroy)
} >>> log

HTTPServer(port: 8080, responder: router).start()