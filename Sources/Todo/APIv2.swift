import HTTP
import Router
import Middleware

let APIv2 = Router("/v2") { route in
    route.get("/version") { _ in
        return Response(status: .OK, json: ["version": "2.0.0"])
    }

    route.get("/todos", todo.index)
    route.post("/todos", parseJSON >>> todo.create)
    route.get("/todos/:id", todo.show)
    route.put("/todos/:id", parseJSON >>> todo.update)
    route.delete("/todos/:id", todo.destroy)
}