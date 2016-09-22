import Venice

func ex18() {
    print_header(18, "Fibonacci")

    func fibonacci(n: Int, channel: Channel<Int>) {
        var x = 0
        var y = 1
        for _ in 0..<n {
            channel.send(x)
            (x, y) = (y, x + y)
        }
        channel.close()
    }

    let fibonacciChannel = Channel<Int>(bufferSize: 10)

    co(fibonacci(n: fibonacciChannel.bufferSize, channel: fibonacciChannel))

    for n in fibonacciChannel {
        print(n)
    }
}
