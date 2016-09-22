import Venice

func ex07() {
    print_header(7, "Timeouts")

    // Timeouts are important for programs that connect to external resources or that otherwise need to bound execution time. Implementing timeouts is easy and elegant thanks to channels and select.

    // For our example, suppose we're executing an external call that returns its result on a channel channel1 after 2s.

    let channel1 = Channel<String>(bufferSize: 1) // same as Channel<String>()

    after(2.seconds) {
        channel1.send("result 1")
    }

    // Here's the select implementing a timeout. received(resultFrom: channel1) awaits the result and timeout(1.second.fromNow()) awaits a value to be sent after the timeout of 1s. Since select proceeds with the first receive that's ready, we'll take the timeout case if the operation takes more than the allowed 1s.

    select { when in
        when.receive(from: channel1) { result in
            print(result)
        }
        when.timeout(1.second.fromNow()) {
            print("timeout 1")
        }
    }

    // If we allow a longer timeout of 3s, then the receive from channel2 will succeed and we'll print the result.

    let channel2 = Channel<String>(bufferSize: 1)

    after(2.seconds) {
        channel2.send("result 2")
    }

    select { when in
        when.receive(from: channel2) { result in
            print(result)
        }
        when.timeout(3.seconds.fromNow()) {
            print("timeout 2")
        }
    }

    // Running this program shows the first operation timing out and the second succeeding.

    // Using this select timeout pattern requires communicating results over channels. This is a good idea in general because other important features are based on channels and select. We’ll look at two examples of this next: timers and tickers.
}
