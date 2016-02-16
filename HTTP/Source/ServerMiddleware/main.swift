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