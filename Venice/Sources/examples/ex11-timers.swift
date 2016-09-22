import Venice

func ex11() {
    print_header(11, "Timers")

    // We often want to execute code at some point in the future, or repeatedly at some interval. Timer and ticker features make both of these tasks easy. We'll look first at timers and then at tickers.

    // Timers represent a single event in the future. You tell the timer how long you want to wait, and it provides a channel that will be notified at that time. This timer will wait 2 seconds.

    let timer1 = Timer(deadline: 2.seconds.fromNow())

    // The timer1.channel.receive() blocks on the timer's channel until it sends a value indicating that the timer expired.

    timer1.channel.receive()
    print("Timer 1 expired")

    // If you just wanted to wait, you could have used nap. One reason a timer may be useful is that you can cancel the timer before it expires. Here's an example of that.

    let timer2 = Timer(deadline: 1.second.fromNow())

    co {
        timer2.channel.receive()
        print("Timer 2 expired")
    }

    if timer2.stop() {
        print("Timer 2 stopped")
    }

    // The first timer will expire ~2s after we start the program, but the second should be stopped before it has a chance to expire.
}
