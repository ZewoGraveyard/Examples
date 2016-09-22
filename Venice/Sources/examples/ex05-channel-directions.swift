import Venice

func ex05() {
    print_header(5, "Channel Directions")

    // When using channels as function parameters, you can specify if a channel is meant to only send or receive values. This specificity increases the type-safety of the program.

    // This ping function only accepts a channel that receives values. It would be a compile-time error to try to receive values from this channel.

    func ping(message: String, to pingChannel: SendingChannel<String>) {
        pingChannel.send(message)
    }

    // The pong function accepts one channel that only sends values (pings) and a second that only receives values (pongs).

    func pong(from pingChannel: ReceivingChannel<String>, to pongChannel: SendingChannel<String>) {
        let message = pingChannel.receive()!
        pongChannel.send(message)
    }

    let pings = Channel<String>(bufferSize: 1)
    let pongs = Channel<String>(bufferSize: 1)

    ping(message: "passed message", to: pings.sendingChannel)
    pong(from: pings.receivingChannel, to: pongs.sendingChannel)

    print(pongs.receive()!)
}
