import XCTest
@testable import AlertPresenter

final class QueueTests: XCTestCase {
    
    func testDequeueEmpty() throws {
        var queue = Queue<NSNumber>()
        XCTAssertNil(queue.dequeue())
    }
    
    func testEnqueueOne() throws {
        var queue = Queue<NSNumber>()
        queue.enqueue(1)
        XCTAssertEqual(queue.dequeue(), 1)
    }
    
    func testEnqueueTwo() throws {
        var queue = Queue<NSNumber>()
        queue.enqueue(1)
        queue.enqueue(2)
        XCTAssertEqual(queue.dequeue(), 1)
        XCTAssertEqual(queue.dequeue(), 2)
    }
    
}

