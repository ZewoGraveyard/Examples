import Venice

func demo02() {
    print("\n\ndemo02\n")
    co {
        // sleep for one second
        nap(for: 1.second)
        print("after nap")
    }

    after(1.second) {
        print("after 'after'")
    }

    let deadline = 2.seconds.fromNow()
    wake(at: deadline)
    print("woke up")

    var count = 0
    every(1.second) { done in
        print("yoo")
        count += 1
        if count == 3 {
            done()
        }
    }

    let deadline2 = 5.seconds.fromNow()
    wake(at: deadline2)
    print("woke up")


    let messages = Channel<String>()
    co(messages.send("ping"))
    let message = messages.receive()!
    print(message)

    // buffered channels

    let messagesCh = Channel<String>(bufferSize: 2)

    messagesCh.send("buffered")
    messagesCh.send("channel")

    print(messagesCh.receive()!)
    print(messagesCh.receive()!)


    // ReceivingChannel & SendingChannel
    func receiveOnly(channel: ReceivingChannel<String>) {
        // can only receive from channel
        let string = channel.receive()!
        print(string)
    }

    func sendOnly(channel: SendingChannel<String>) {
        // can only send to channel
        channel.send("yo")
    }

    let channel = Channel<String>(bufferSize: 1)
    sendOnly(channel: channel.sendingChannel)
    receiveOnly(channel: channel.receivingChannel)



    // FallibleChannel
    let fallible_channel = FallibleChannel<String>(bufferSize: 2)

    fallible_channel.send("yo")
    fallible_channel.send(MyError(description: "an error"))

    do {
        if let yo = try fallible_channel.receive() {
            print(yo)
        }
        try fallible_channel.receive() // will throw
    } catch {
        print("error")
    }
}
