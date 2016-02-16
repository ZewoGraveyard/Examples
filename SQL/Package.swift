import PackageDescription

let packge = Package(
	name: "SQLExample",
	dependencies: [
		.Package(url: "https://github.com/ZewoFlux/PostgreSQL", majorVersion: 0, minor: 2)
	]
)