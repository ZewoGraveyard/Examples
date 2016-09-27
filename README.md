Examples
========

[![Swift 3.0](https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Platforms Linux](https://img.shields.io/badge/Platforms-Linux-lightgray.svg?style=flat)](https://developer.apple.com/swift/)
[![License MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat)](https://tldrlegal.com/license/mit-license)
[![Slack Status](https://zewo-slackin.herokuapp.com/badge.svg)](http://slack.zewo.io)

Examples using Zewo's linux frameworks

## Demos

- [ ] Server (present but not upgraded)
- [ ] Router (present but not upgraded)
- [ ] Middleware (present but not upgraded)
- [ ] File (present but not upgraded)
- [x] Venice

## Usage

#### Server

```swift
import Zewo

let log = Log()
let logger = LogMiddleware(log: log)

try Server(reusePort: true, middleware: logger) { _ in
    return Response(body: "hello")
}.start()
```

#### Router

```swift
import Zewo

let router = Router { route in
    route.get("/") { _ in
        return Response(status: .OK, body: "hello")
    }
}

try Server(responder: router).start()
```

#### Middleware

```swift
import Zewo

let log = Log()
let logger = LogMiddleware(log: log)

let parsers = MediaTypeParserCollection()
parsers.add(JSONMediaType, parser: JSONInterchangeDataParser())
parsers.add(URLEncodedFormMediaType, parser: URLEncodedFormInterchangeDataParser())

let serializers = MediaTypeSerializerCollection()
serializers.add(JSONMediaType, serializer: JSONInterchangeDataSerializer())
serializers.add(URLEncodedFormMediaType, serializer: URLEncodedFormInterchangeDataSerializer())

let contentNegotiation = ServerContentNegotiationMiddleware(
    parsers: parsers,
    serializers: serializers
)

try Server(middleware: logger, contentNegotiation) { _ in
    let content: InterchangeData = [
        "foo": "bar",
        "hello": "world"
    ]

    return Response(content: content)
}.start()
```

#### File

```swift
import Zewo

try Server(responder: FileResponder(basePath: "public")).start()
```

## Community

[![Slack](http://s13.postimg.org/ybwy92ktf/Slack.png)](http://slack.zewo.io)

Join us on [Slack](http://slack.zewo.io).

License
-------

**Examples** are released under the MIT license. See LICENSE for details.
