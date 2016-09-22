import Venice

func ex06() {
    print_header(6, "Select")

    // Select lets you wait on multiple channel operations. Combining coroutines and channels with select is an extremely powerful feature.

    // For our example we'll select across two channels.

    let channel1 = Channel<String>()
    let channel2 = Channel<String>()

    // Each channel will receive a value after some amount of time, to simulate e.g. blocking RPC operations executing in concurrent coroutines.

    after(1.second) {
        channel1.send("one")
    }

    after(2.seconds) {
        channel2.send("two")
    }

    // We'll use select to await both of these values simultaneously, printing each one as it arrives.

    for _ in 0 ..< 2 {
        select { when in
            when.receive(from: channel1) { message1 in
                print("received \(message1)")
            }
            when.receive(from: channel2) { message2 in
                print("received \(message2)")
            }
        }
    }
    // We receive the values "one" and then "two" as expected. Note that the total execution time is only ~2 seconds since both the 1 and 2 second naps execute concurrently
}
