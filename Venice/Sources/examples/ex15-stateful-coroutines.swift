import Venice

#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif

func random (_ range: ClosedRange<Int>) -> Int {
    let (min, max) = (Int(range.lowerBound), Int(range.upperBound))
    #if os(Linux)
        return min + Int(random() % ((max - min) + 1))
    #else
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    #endif
}

func ex15() {
    print_header(15, "Stateful Coroutines")

    // In this example our state will be owned by a single coroutine. This will guarantee that the data is never corrupted with concurrent access. In order to read or write that state, other coroutines will send messages to the owning coroutine and receive corresponding replies. These ReadOperation and WriteOperation structs encapsulate those requests and a way for the owning coroutine to respond.

    struct ReadOperation {
        let key: Int
        let responses: Channel<Int>
    }

    struct WriteOperation {
        let key: Int
        let value: Int
        let responses: Channel<Void>
    }

    // We'll count how many operations we perform.

    var operations = 0

    // The reads and writes channels will be used by other coroutines to issue read and write requests, respectively.

    let reads = Channel<ReadOperation>()
    let writes = Channel<WriteOperation>()

    // Here is the coroutine that owns the state, which is a dictionary private to the stateful coroutine. This coroutine repeatedly selects on the reads and writes channels, responding to requests as they arrive. A response is executed by first performing the requested operation and then sending a value on the response channel responses to indicate success (and the desired value in the case of reads).

    co {
        var state: [Int: Int] = [:]
        while true {
            select { when in
                when.receive(from: reads) { read in
                    read.responses.send(state[read.key] ?? 0)
                }
                when.receive(from: writes) { write in
                    state[write.key] = write.value
                    write.responses.send()
                }
            }
        }
    }

    // This starts 100 coroutines to issue reads to the state-owning coroutine via the reads channel. Each read requires constructing a ReadOperation, sending it over the reads channel, and then receiving the result over the provided responses channel.

    for _ in 0 ..< 100 {
        co {
            while true {
                let read = ReadOperation(key: random(0...5),
                                         responses: Channel<Int>()
                       )
                reads.send(read)
                read.responses.receive()
                operations += 1
            }
        }
    }

    // We start 10 writes as well, using a similar approach.

    for _ in 0 ..< 10 {
        co {
            while true {
                let write = WriteOperation(key: random(0...5),
                                           value: random(0...100),
                                           responses: Channel<Void>())
                writes.send(write)
                write.responses.receive()
                operations += 1
            }
        }
    }

    // Let the coroutines work for a second.

    nap(for: 1.second)

    // Finally, capture and report the operations count.

    print("operations: \(operations)")
}
