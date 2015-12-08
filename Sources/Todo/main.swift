#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif
import HTTP
import HTTPRouter
import HTTPJSON
import HTTPMiddleware
import LoggerMiddleware
import JSONParserMiddleware
import Epoch
import SSL
import OpenSSL
import Venice
import CHTTPParser
import CLibvenice

let router = Router("/api/v1") { route in
    route.get("/version") { _ in
        return Response(status: .OK, json: ["version": "1.0.0"])
    }

    let todo = TodoResources()
    route.get("/todos", todo.index)
    route.post("/todos", parseJSON >>> todo.create)
    route.get("/todos/:id", todo.show)
    route.put("/todos/:id", parseJSON >>> todo.update)
    route.delete("/todos/:id", todo.destroy)
} >>> log

co {
    let server = Server(port: 8081, responder: router) { options in
        OpenSSL.initialize()
        options.SSL = try? SSLServerContext(
            certificate: "absolute path to your certificate",
            privateKey: "absolute path to your private key"
        )
    }
    server.start()
}

Server(port: 8080, responder: router).start()