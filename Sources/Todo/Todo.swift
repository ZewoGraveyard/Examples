struct Todo {
    let id: String
    let title: String
    let done: Bool
}

extension Todo: CustomStringConvertible {
	var description: String {
		return "[\(done ? "x" : " ")] \(title)"
	}
}
