import Foundation
import Venice

func demo04() {
    print("\n\ndemo04\n")
    var channelA: Channel<String>? = Channel<String>()
    var channelB: Channel<String>? = Channel<String>()

    if Int(arc4random_uniform(1)) == 0 {
        channelA = nil
        print("disabled channel a")
    } else {
        channelB = nil
        print("disabled channel b")
    }

    co { channelA?.send("a") }
    co { channelB?.send("b") }

    sel { when in
        when.receive(from: channelA) { value in
            print("received \(value) from channel a")
        }
        when.receive(from: channelB) { value in
            print("received \(value) from channel b")
        }
    }
}
