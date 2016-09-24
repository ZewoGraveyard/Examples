import Venice

func ex14() {
    // Rate limiting is an important mechanism for controlling resource utilization and maintaining quality of service. Venice elegantly supports rate limiting with coroutines, channels, and tickers.

    // First we'll look at basic rate limiting. Suppose we want to limit our handling of incoming requests. We'll serve these requests off a channel of the same name.

    let requests = Channel<Int>(bufferSize: 5)

    for request in 1...5 {
        requests.send(request)
    }

    requests.close()

    // This limiter channel will receive a value every 200 milliseconds. This is the regulator in our rate limiting scheme.

    let limiter = Ticker(period: 200.milliseconds)

    // By blocking on a receive from the limiter channel before serving each request, we limit ourselves to 1 request every 200 milliseconds.

    for request in requests {
        limiter.channel.receive()
        print("request \(request) \(now())")
    }

    print("")

    // We may want to allow short bursts of requests in our rate limiting scheme while preserving the overall rate limit. We can accomplish this by buffering our limiter channel. This burstyLimiter channel will allow bursts of up to 3 events.

    let burstyLimiter = Channel<Double>(bufferSize: 3)

    // Fill up the channel to represent allowed bursting.

    for _ in 0 ..< 3 {
        burstyLimiter.send(now())
    }

    // Every 200 milliseconds we'll try to add a new value to burstyLimiter, up to its limit of 3.

    co {
        // FIXME: small regression in Venice/Ticker.swift
        // for time in Ticker(period: 200.milliseconds).channel {
        //     burstyLimiter.send(time)
        // }
        for _ in Ticker(period: 200.milliseconds).channel {
            burstyLimiter.send(now())
        }
    }

    // Now simulate 5 more incoming requests. The first 3 of these will benefit from the burst capability of burstyLimiter.

    let burstyRequests = Channel<Int>(bufferSize: 5)

    for request in 1...5 {
        burstyRequests.send(request)
    }

    burstyRequests.close()

    for request in burstyRequests {
        _ = burstyLimiter.receive()!
        print("request \(request) \(now())")
    }

    // Running our program we see the first batch of requests handled once every ~200 milliseconds as desired.

    // For the second batch of requests we serve the first 3 immediately because of the burstable rate limiting, then serve the remaining 2 with ~200ms delays each.
}

ex14()
