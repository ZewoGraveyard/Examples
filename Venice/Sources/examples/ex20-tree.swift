import func Foundation.arc4random_uniform
import Venice

extension Collection where Index == Int {
    func shuffled() -> [Iterator.Element] {
        var list = Array(self)
        list.shuffle()
        return list
    }
}

extension MutableCollection where Index == Int {
    mutating func shuffle() {
        if count < 2 { return }

        for i in startIndex..<endIndex - 1 {
            let j = Int(arc4random_uniform(UInt32(endIndex - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}

final class Tree<T> {
    var left: Tree?
    var value: T
    var right: Tree?

    init(left: Tree?, value: T, right: Tree?) {
        self.left = left
        self.value = value
        self.right = right
    }
}

// Traverses a tree depth-first, sending each Value on a channel.

func walk<T>(_ tree: Tree<T>?, channel: Channel<T>) {
    if let tree = tree {
        walk(tree.left, channel: channel)
        channel.send(tree.value)
        walk(tree.right, channel: channel)
    }
}

// Launches a walk in a new coroutine, and returns a read-only channel of values.

func walker<T>(tree: Tree<T>?) -> ReceivingChannel<T> {
    let channel = Channel<T>()
    co {
        walk(tree, channel: channel)
        channel.close()
    }
    return channel.receivingChannel
}

// Reads values from two walkers that run simultaneously, and returns true if tree1 and tree2 have the same contents.

func == <T : Equatable> (tree1: Tree<T>, tree2: Tree<T>) -> Bool {
    let channel1 = walker(tree: tree1)
    let channel2 = walker(tree: tree2)
    while true {
        let value1 = channel1.receive()
        let value2 = channel2.receive()
        if value1 == nil || value2 == nil {
            return value1 == value2
        }
        if value1 != value2 {
            break
        }
    }
    return false
}

// Returns a new, random binary tree holding the values 1k, 2k, ..., n*k.

func newTree(n: Int, k: Int) -> Tree<Int> {
    var tree: Tree<Int>?
    for value in Array(1...n).shuffled() {
        tree = insert(value * k, in: tree)
    }
    return tree!
}

// Inserts a value in the tree

func insert(_ value: Int, in tree: Tree<Int>?) -> Tree<Int> {
    if let tree = tree {
        if value < tree.value {
            tree.left = insert(value, in: tree.left)
            return tree
        } else {
            tree.right = insert(value, in: tree.right)
            return tree
        }
    } else {
        return Tree<Int>(left: nil, value: value, right: nil)
    }
}

func ex20() {
    print_header(20, "Tree")

    let tree = newTree(n: 100, k: 1)

    print("Same contents \(tree == newTree(n: 100, k: 1))")
    print("Differing sizes \(tree == newTree(n: 99, k: 1))")
    print("Differing values \(tree == newTree(n: 100, k: 2))")
    print("Dissimilar \(tree == newTree(n: 101, k: 2))")
}
