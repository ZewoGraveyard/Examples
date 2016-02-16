import Zewo

let log = Log()
let logger = LogMiddleware(log: log)

try Server(reusePort: true, middleware: logger) { _ in
    return Response(body: "hello")
}.start()