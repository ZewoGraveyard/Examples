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

OpenSSL.initialize()

let todo = TodoResources()

let v1 = Router("/v1") { route in
    route.get("/version") { _ in
        return Response(status: .OK, json: ["version": "1.0.0"])
    }
}

let v2 = Router("/v2") { route in
    route.get("/version") { _ in
        return Response(status: .OK, json: ["version": "2.0.0"])
    }

    route.get("/todos", todo.index)
    route.post("/todos", parseJSON >>> todo.create)
    route.get("/todos/:id", todo.show)
    route.put("/todos/:id", parseJSON >>> todo.update)
    route.delete("/todos/:id", todo.destroy)
}

let router = Router { route in
    route.router("/api", v1)
    route.router("/api", v2)
} >>> log

co(Server(port: 8081, responder: router) { options in
    options.SSL = try? SSLServerContext(
        certificate: "absolute path to your certificate",
        privateKey: "absolute path to your private key"
    )
}.start())

Server(port: 8080, responder: router).start()