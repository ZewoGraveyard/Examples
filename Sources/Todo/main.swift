#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif

import CHTTPParser
import CLibvenice

import Epoch
import OpenSSL

OpenSSL.initialize()

Server(port: 8081, responder: router) { options in
    options.SSL = try? SSLServerContext(
        certificate: "/home/paulofaria/csr.pem",
        privateKey: "/home/paulofaria/key.pem"
    )
}.startInBackground()

Server(port: 8080, responder: router).start()