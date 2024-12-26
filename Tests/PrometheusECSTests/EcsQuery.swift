import Testing
@testable import PrometheusECS

fileprivate class Position : Component {
    public var x: Int
    public var y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

fileprivate class Velocity : Component {
    public var dx: Float32
    public var dy: Float32
    
    init(dx: Float32, dy: Float32) {
        self.dx = dx
        self.dy = dy
    }
}

fileprivate class Health : Component {
    public var value: Int32
    
    init(value: Int32) {
        self.value = value
    }
}


@Test func ecsAddEntityQuery2() async throws {
    let world = World()
    
    try world.addEntity(components: Position(x: 0, y: 0), Velocity(dx: 12, dy: 12))
    
    let query = world.query(requiredAll: Position.self, Velocity.self)
    
    for (position, velocity) in query {
        #expect(position.x == 0 && position.y == 0)
        #expect(velocity.dx == 12 && velocity.dy == 12)
    }
}

@Test func ecsAddEntityQuery1() async throws {
    let world = World()
    
    try world.addEntity(components: Position(x: 0, y: 0))
    
    let query = world.query(requiredAll: Position.self)
    
    for position in query {
        #expect(position.x == 0 && position.y == 0)
    }
}



@Test func ecsAddEntity2Query2() async throws {
    let world = World()
    
    try world.addEntity(components: Position(x: 0, y: 0), Health(value: 100))
    try world.addEntity(components: Velocity(dx: 32, dy: 32), Position(x: 55, y: 55))
    
    let query = world.query(requiredAll: Position.self, excludeAll: Velocity.self)
    
    for position in query {
        #expect(position.x == 0 && position.y == 0)
    }
}



@Test func ecsAddEntityMutateComponentSystem() async throws {
    func mutateComponentSystem(query: Query<Position>) {
        for position in query {
            position.x += 1
        }
    }
    
    let world = World()
    
    try world.addEntity(components: Position(x: 0, y: 0))
    
    try world.addSystemFunction(schedule: .start, mutateComponentSystem)
    
    try world.singleExecuteSystems()
    
    let query = world.query(requiredAll: Position.self)
    
    for position in query {
        #expect(position.x == 1 && position.y == 0)
    }
}


@Test func ecsAddEntityMutateComponentInsideSystem() async throws {
    func mutateCompoentInsideSystem(entityManager: EntityManager) throws {
        try entityManager.addEntity(components: Position(x: 2, y: 2))
    }
    
    func mutateComponentSystem(query: Query<Position>) {
        for position in query {
            position.x += 1
        }
    }
    
    let world = World()
    
    try world.addEntity(components: Position(x: 0, y: 0))
    
    try world.addSystemFunction(schedule: .start, mutateCompoentInsideSystem)
    try world.addSystemFunction(schedule: .start, mutateComponentSystem)
    
    try world.singleExecuteSystems()
    
    let query = world.query(requiredAll: Position.self)
    
    
    
    let result = ["x": 1, "y": 0]
    let result2 = ["x": 3, "y": 2]

    let list = [result, result2]
    
    for (index, position) in query.enumerated() {
        #expect(position.x == list[index]["x"]! && position.y == list[index]["y"]!)
    }
    

}



