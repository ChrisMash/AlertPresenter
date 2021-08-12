//
//  Queue.swift
//  Created by Chris Mash on 14/03/2021.
//

import Foundation

internal struct Queue<Element> {
    
    private var elements = [Element]()

    mutating func enqueue(_ element: Element) {
        elements.append(element)
    }

    mutating func dequeue() -> Element? {
        guard !elements.isEmpty else {
            return nil
        }

        return elements.removeFirst()
    }
    
}
