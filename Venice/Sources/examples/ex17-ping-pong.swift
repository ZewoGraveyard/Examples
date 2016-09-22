import Venice

func ex17() {
    print_header(17, "Ping-pong")

    final class Ball {
        var hits: Int = 0
    }

    func player(name: String, table: Channel<Ball>) {
        while true {
            let ball = table.receive()!
            ball.hits += 1
            print("\(name) \(ball.hits)")
            nap(for: 100.milliseconds)
            table.send(ball)
        }
    }

    let table = Channel<Ball>()

    co(player(name: "ping", table: table))
    co(player(name: "pong", table: table))

    table.send(Ball())
    nap(for: 1.second)
    table.receive()
}
