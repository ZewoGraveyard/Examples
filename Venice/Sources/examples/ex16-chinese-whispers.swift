import Venice

func ex16() {
    print_header(16, "Chinese Whispers")

    func whisper(_ left: SendingChannel<Int>, _ right: ReceivingChannel<Int>) {
        left.send(right.receive()! + 1)
    }

    let n = 100000

    let leftmost = Channel<Int>()
    var right = leftmost
    var left = leftmost

    for _ in 0..<n {
        right = Channel<Int>()
        co(whisper(left.sendingChannel, right.receivingChannel))
        left = right
    }

    co {
        right.send(1)
    }

    print(leftmost.receive()!)
}
