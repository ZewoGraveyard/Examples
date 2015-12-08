import PackageDescription

let package = Package(
	name: "Todo",
	dependencies: [
        .Package(url: "https://github.com/Zewo/Epoch.git", majorVersion: 0, minor: 1),
        .Package(url: "https://github.com/Zewo/HTTPRouter.git", majorVersion: 0, minor: 1),
        .Package(url: "https://github.com/Zewo/LoggerMiddleware.git", majorVersion: 0, minor: 1),
        .Package(url: "https://github.com/Zewo/JSONParserMiddleware.git", majorVersion: 0, minor: 1),
        .Package(url: "https://github.com/Zewo/HTTPJSON.git", majorVersion: 0, minor: 1),
        .Package(url: "https://github.com/Zewo/OpenSSL.git", majorVersion: 0, minor: 1)
	]
)