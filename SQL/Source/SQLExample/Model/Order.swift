import SQL

struct Order {
  struct Error: ErrorType {
    let description: String
  }

  let id: Int?
  let productName: String
  let userId: Int

  init(productName: String, user: User) throws {
    guard let userId = user.id else {
      throw Error(description: "User is not persisted in the database yet")
    }

    self.id = nil
    self.productName = productName
    self.userId = userId
  }
}

enum OrderField: String, ModelFieldset {
  case Id = "id"
  case ProductName = "product_name"
  case UserId = "user_id"

  static var tableName: String {
    return "orders"
  }
}

extension Order: Entity {
  typealias Field = OrderField

  var primaryKey: Int? {
    return id
  }

  static var fieldForPrimaryKey: Field {
    return .Id
  }

  init(row: Row) throws {
    id = try row.value(Field.Id)
    productName = try row.value(Field.ProductName)
    userId = try row.value(Field.UserId)
  }
}