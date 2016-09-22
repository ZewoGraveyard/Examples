import PackageDescription

let package = Package(
    name: "VeniceExamples",
    dependencies: [
        .Package(url: "https://github.com/Zewo/Venice", majorVersion: 0)
    ]
)
