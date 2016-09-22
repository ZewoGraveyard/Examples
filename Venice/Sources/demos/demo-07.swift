import Venice

func demo07() {
    print("\n\ndemo07\n")

    let ticker = Ticker(period: 500.milliseconds)

    co {
        for time in ticker.channel {
            print("Tick at \(time)")
        }
    }

    nap(for: 2.seconds)
    ticker.stop()
}
