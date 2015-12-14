import HTTP
import Router
import Middleware

let APIv2 = Router("/v2") { route in
    route.get("/version") { _ in
        return Response(status: .OK, json: ["version": "2.0.0"])
    }

    route.get("/todos", todoResources.index)
    route.post("/todos", parseJSON >>> todoResources.create)
    route.get("/todos/:id", todoResources.show)
    route.put("/todos/:id", parseJSON >>> todoResources.update)
    route.delete("/todos/:id", todoResources.destroy)
}
