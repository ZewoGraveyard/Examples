var todoItemCount = 0

struct TodoItem {
    let id: String
    let title: String
    let done: Bool

    init(title: String) {
        self.id = "\(++todoItemCount)"
        self.title = title
        self.done = false
    }

    init(id: String, title: String, done: Bool) {
        self.id = id
        self.title = title
        self.done = done
    }
}