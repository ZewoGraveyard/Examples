import HTTP
import Router

let APIv1 = Router("/v1") { route in
    route.get("/version") { _ in
        return Response(status: .OK, json: ["version": "1.0.0"])
    }
}