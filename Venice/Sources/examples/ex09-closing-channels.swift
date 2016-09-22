import Venice

func ex09() {
    print_header(9, "Closing Channels")

    // _Closing_ a channel indicates that no more values
    // can be sent to it. This can be useful to communicate
    // completion to the channel's receivers.

    // In this example we'll use a `jobs` channel to
    // communicate work to be done to a worker coroutine. When we have no more jobs for
    // the worker we'll `close` the `jobs` channel.

    let jobs = Channel<Int>(bufferSize: 5)
    let done = Channel<Void>()

    // Here's the worker coroutine. It repeatedly receives
    // from `jobs` with `j = jobs.receive()`. The return value
    // will be `nil` if `jobs` has been `close`d and all
    // values in the channel have already been received.
    // We use this to notify on `done` when we've worked
    // all our jobs.

    co {
        while true {
            if let job = jobs.receive() {
                print("received job \(job)")
            } else {
                print("received all jobs")
                done.send()
                return
            }
        }
    }

    // This sends 3 jobs to the worker over the jobs channel, then closes it.
    for job in 1...3 {
        print("sent job \(job)")
        jobs.send(job)
    }

    jobs.close()
    print("sent all jobs")

    // We await the worker using the synchronization approach we saw earlier.
    done.receive()
}
