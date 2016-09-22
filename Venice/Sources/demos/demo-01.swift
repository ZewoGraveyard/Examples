import Venice

func demo01() {
    func doSomething() {
        print("did something")
    }

    doSomething()

    co(doSomething())
}
