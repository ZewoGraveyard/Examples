import PackageDescription

let package = Package(
    name: "Example",
    dependencies: [
        .Package(url: "https://github.com/Zewo/Zewo.git", majorVersion: 0, minor: 2)
    ]
)
