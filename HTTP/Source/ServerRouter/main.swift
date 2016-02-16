import Zewo

let router = Router { route in
    route.get("/") { _ in
        return Response(status: .OK, body: "hello")
    }
}

try Server(responder: router).start()