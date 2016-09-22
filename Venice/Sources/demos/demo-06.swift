import Venice

func demo06() {
    print("\n\ndemo06\n")

    let timer = Timer(deadline: 2.second.fromNow())

    co {
        timer.channel.receive()
        print("Timer expired")
    }

    nap(for: 3.second)

    if timer.stop() {
        print("Timer stopped")
    }
}
