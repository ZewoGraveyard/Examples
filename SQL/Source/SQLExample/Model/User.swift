import SQL

struct User {
  let id: Int?
  let username: String
  let password: String
  let firstName: String?
  let lastName: String?

  init(username: String, password: String, firstName: String? = nil, lastName: String? = nil) {
    self.id = nil
    self.username = username
    self.password = password
    self.firstName = firstName
    self.lastName = lastName
  }
}


enum UserField: String, ModelFieldset {
  case Id = "id"
  case Username = "username"
  case Password = "password"
  case FirstName = "first_name"
  case LastName = "last_name"

  static var tableName: String {
    return "users"
  }
}

extension User: Entity {
  typealias Field = UserField

  var primaryKey: Int? {
    return id
  }

  static var fieldForPrimaryKey: Field {
    return .Id
  }

  init(row: Row) throws {
    id = try row.value(Field.Id)
    username = try row.value(Field.Username)
    password = try row.value(Field.Password)
    firstName = try row.value(Field.FirstName)
    lastName = try row.value(Field.LastName)
  }
}