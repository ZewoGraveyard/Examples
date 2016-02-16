import PostgreSQL


let log = Log()

let connection = PostgreSQL.Connection("postgres://localhost/sqlexample")
connection.log = log

do {
	try connection.open()
	let migrationManager = try MigrationManager(migrationsDirectory: "./Migrations", connection: connection)
	try migrationManager.migrate(to: 1)

	let users = try User.select().fetch(connection)

	if users.isEmpty {
		try User.insert(
			[
				.Username: "SwiftUser",
				.Password: "12345",
				.FirstName: "Swift",
				.LastName: "User"
			]
		).execute(connection)

		guard let user = try User.select(User.Field.Id).first(connection) else {
			fatalError("Failed to create user")
		}

		try Order.insert(
			[
				.UserId: user.id,
				.ProductName: "Swift example book"
			]
		).execute(connection)
	}

	print(users)
}
catch {
	print(error)
}
