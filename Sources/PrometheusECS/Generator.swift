//
//  Generator.swift
//  prometheus-ecs
//
//  Created by Gabriel Bernardo on 25/12/24.
//

struct DoubleGenerator: AsyncSequence {
    typealias Element = Int
    
    struct AsyncIterator: AsyncIteratorProtocol {
        var current = 1
        
        mutating func next() -> Element? {
            defer { current &*= 2}
            
            if current < 0 {
                return nil
            }else {
                return current
            }
        }
    
    }
    
    
    func makeAsyncIterator() -> AsyncIterator {
        AsyncIterator()
    }
}
