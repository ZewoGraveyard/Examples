import Venice

func ex03() {
    print_header(3, "Channel Buffering")

    // By default channels are unbuffered, meaning that they will only accept values (channel.send(value)) if there is a corresponding receive (let value = channel.receive()) ready to receive the value sent by the channel. Buffered channels accept a limited number of values without a corresponding receiver for those values.

    // Here we make a channel of strings buffering up to 2 values.

    let messages = Channel<String>(bufferSize: 2)

    // Because this channel is buffered, we can send these values into the channel without a corresponding concurrent receive.

    messages.send("buffered")
    messages.send("channel")

    // Later we can receive these two values as usual.

    print(messages.receive()!)
    print(messages.receive()!)
}
