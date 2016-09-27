import Venice

func demo07() {
    let ticker = Ticker(period: 500.milliseconds)

    co {
        for time in ticker.channel {
            print("Tick at \(time)")
        }
    }

    nap(for: 2.seconds)
    ticker.stop()
}

demo07()
