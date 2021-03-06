import XCTest
@testable import Swiftkiq

class SwiftkiqTests: XCTestCase {
    final class EchoMessageWorker: Worker {
        struct Args: Argument {
            let message: String
            
            static func from(_ dictionary: Dictionary<String, Any>) -> Args {
                return Args(
                    message: dictionary["message"]! as! String
                )
            }
        }

        var jid: String?
        var queue: Queue?
        var retry: Int?

        func perform(_ job: Args) {
            print(job.message)
        }
    }
    
    func testExample() {
        try! EchoMessageWorker.performAsync(.init(message: "Hello, World!"))
        XCTAssertNotNil(try! SwiftkiqCore.store.dequeue([Queue("default")]))
    }
    
    func testRedis() {
        try! SwiftkiqCore.store.enqueue(["hoge": 1], to: Queue("default"))
        do {
            let work = try SwiftkiqCore.store.dequeue([Queue("default")])
            XCTAssertNotNil(work)
        } catch(let error) {
            print(error)
            XCTFail()
        }
    }
    
    func testRedisEmptyDequeue() {
        do {
            let work = try SwiftkiqCore.store.dequeue([Queue("default")])
            XCTAssertNil(work)
        } catch(let error) {
            print(error)
            XCTFail()
        }
    }


    static var allTests : [(String, (SwiftkiqTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
