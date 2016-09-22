import Venice
import Darwin.C

struct MyError: Error {
    let description: String
}

func demo05() {
    print("\n\ndemo05\n")

    func flipCoin(outcome: FallibleChannel<String>) {
        if Int(arc4random_uniform(1)) == 0 {
            outcome.send("Success")
        } else {
            outcome.send(MyError(description: "Something went wrong"))
        }
    }

    let outcome = FallibleChannel<String>()

    co(flipCoin(outcome: outcome))

    forSelect { when, done in
        when.receive(from: outcome) { result in
            result.success { value in
                print(value)
                done()
            }
            result.failure { error in
                print("\(error). Retrying...")
                co(flipCoin(outcome: outcome))
            }
        }
    }
}
