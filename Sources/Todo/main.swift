#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif
import CHTTPParser
import CLibvenice

import Epoch
import Router
import Middleware
import OpenSSL
import Venice

OpenSSL.initialize()

co(Server(port: 8081, responder: router) { options in
    options.SSL = try? SSLServerContext(
        certificate: "/absolute/path/to/csr.pem",
        privateKey: "/absoulte/path/to/key.pem"
    )
}.start())

Server(port: 8080, responder: router).start()