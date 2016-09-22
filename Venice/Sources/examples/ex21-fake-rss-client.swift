import func Foundation.arc4random_uniform
import Venice

struct Item : Equatable {
    let domain: String
    let title: String
    let GUID: String
}

func ==(lhs: Item, rhs: Item) -> Bool {
    return lhs.GUID == rhs.GUID
}

struct FetchResponse {
    let items: [Item]
    let nextFetchTime: Int
}

protocol FetcherType {
    func fetch() -> ChannelResult<FetchResponse>
}

struct Fetcher : FetcherType {
    let domain: String

    func randomItems() -> [Item] {
        let items = [
            Item(domain: domain, title: "Swift 2.0", GUID: "1"),
            Item(domain: domain, title: "Strings in Swift 2", GUID: "2"),
            Item(domain: domain, title: "Swift-er SDK", GUID: "3"),
            Item(domain: domain, title: "Swift 2 Apps in the App Store", GUID: "4"),
            Item(domain: domain, title: "Literals in Playgrounds", GUID: "5"),
            Item(domain: domain, title: "Swift Open Source", GUID: "6")
        ]
        return [Item](items[0..<Int(arc4random_uniform(UInt32(items.count)))])
    }

    func fetch() -> ChannelResult<FetchResponse> {
        if arc4random_uniform(2) == 0 {
            let fetchResponse = FetchResponse(
                items: randomItems(),
                nextFetchTime: Int(300.milliseconds.fromNow())
                )
            return ChannelResult.value(fetchResponse)
        } else {
            struct LocalError : Error, CustomStringConvertible { let description: String }
            return ChannelResult.error(LocalError(description: "Network Error"))
        }
    }
}

protocol SubscriptionType {
    var updates: ReceivingChannel<Item> { get }
    func close() -> Error?
}

struct Subscription : SubscriptionType {
    let fetcher: FetcherType
    let items = Channel<Item>()
    let closing = Channel<Channel<Error?>>()

    init(fetcher: FetcherType) {
        self.fetcher = fetcher
        let copy = self
        co { copy.getUpdates() }
    }

    var updates: ReceivingChannel<Item> {
        return self.items.receivingChannel
    }

    func getUpdates() {
        let maxPendingItems = 10
        let fetchDone = Channel<ChannelResult<FetchResponse>>(bufferSize: 1)

        var lastError: Error?
        var pendingItems: [Item] = []
        var seenItems: [Item] = []
        var nextFetchTime = now()
        var fetching = false

        forSelect { when, done in
            when.receive(from: closing) { errorChannel in
                errorChannel.send(lastError)
                self.items.close()
                done()
            }

            if !fetching && pendingItems.count < maxPendingItems {
                when.timeout(nextFetchTime) {
                    fetching = true
                    co {
                        fetchDone.send(self.fetcher.fetch())
                    }
                }
            }

            when.receive(from: fetchDone) { fetchResult in
                fetching = false
                fetchResult.success { response in
                    for item in response.items {
                        if !seenItems.contains(item) {
                            pendingItems.append(item)
                            seenItems.append(item)
                        }
                    }
                    lastError = nil
                    nextFetchTime = Double(response.nextFetchTime)
                }
                fetchResult.failure { error in
                    lastError = error
                    nextFetchTime = 1.second.fromNow()
                }
            }

            if let item = pendingItems.first {
                when.send(item, to: items) {
                    pendingItems.removeFirst()
                }
            }
        }
    }

    func close() -> Error? {
        let errorChannel = Channel<Error?>()
        closing.send(errorChannel)
        return errorChannel.receive()!
    }
}


func ex21() {
    print_header(21, "Fake RSS Client")


    let fetcher = Fetcher(domain: "developer.apple.com/swift/blog/")
    let subscription = Subscription(fetcher: fetcher)

    after(5.seconds) {
        if let lastError = subscription.close() {
            print("Closed with last error: \(lastError)")
        } else {
            print("Closed with no last error")
        }
    }

    for item in subscription.updates {
        print("\(item.domain): \(item.title)")
    }
}
