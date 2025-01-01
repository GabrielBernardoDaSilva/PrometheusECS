//
//  BenchmarkTest.swift
//  PrometheusECS
//
//  Created by Gabriel Bernardo on 31/12/24.
//

import Testing
import Foundation
@testable import PrometheusECS


fileprivate class Position : Component {
    public var x: Int
    public var y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

fileprivate class Name: Component {
    public var name: String
    
    init(name: String) {
        self.name = name
    }
}

fileprivate func spawnPawns(entityManager: EntityManager) throws {
    for i in 0..<1_000_000 {
        try entityManager.addEntity(components: Position(x: i, y: i), Name(name: "Pawn \(i)"))
    }
}

fileprivate func movePawns(query: Query<Position>) throws {
    for position in query {
        position.x += 1
        position.y += 1
    }
}

fileprivate func printPawns(query: Query<Position, Name>) throws {
    
    let result = query.execute()
    #expect(result.count == 1_000_000)
    for (position, name) in query {
        print("\(position.x) \(position.y) \(name.name)")
    }
}

/// Results:
///     With print method (stdout): 52 Secs
///     Only iterate over it : 4.06 Secs

@Test fileprivate func ecsBenchmark() async throws {
    let world = World()
    
    let start = Date()
    
    print("Starting")
    
    try world.addSystemFunction(schedule: .start, spawnPawns)
    try world.addSystemFunction(schedule: .start, movePawns)
    try world.addSystemFunction(schedule: .start, printPawns)
    
    
    try world.singleExecuteSystems()
    
    let duration = Date().timeIntervalSince(start)
    
    print("Duration \(duration)")
}
