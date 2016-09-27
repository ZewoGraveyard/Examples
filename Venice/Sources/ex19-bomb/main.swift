import Venice

func ex19() {
    let tick = Ticker(period: 100.milliseconds).channel
    let boom = Timer(deadline: 500.milliseconds.fromNow()).channel

    forSelect { when, done in
        when.receive(from: tick) { _ in
            print("tick")
        }
        when.receive(from: boom) { _ in
            print("BOOM!")
            done()
        }
        when.otherwise {
            print("    .")
            nap(for: 50.milliseconds)
        }
    }
}

ex19()
