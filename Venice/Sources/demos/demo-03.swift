import Venice

func demo03() {
    print("\n\ndemo03\n")
    let channel = Channel<String>()
    let fallibleChannel = FallibleChannel<String>()

    select { when in
        when.receive(from: channel) { value in
            print("received \(value)")
        }
        when.receive(from: fallibleChannel) { result in
            result.success { value in
                print(value)
            }
            result.failure { error in
                print(error)
            }
        }
        when.send("value", to: channel) {
            print("sent value")
        }
        when.send("value", to: fallibleChannel) {
            print("sent value")
        }
        when.send(MyError(description: "bad error"), to: fallibleChannel) {
            print("threw error")
        }
        when.timeout(1.second.fromNow()) {
            print("timeout")
        }
        when.otherwise {
            print("default case")
        }
    }
}
