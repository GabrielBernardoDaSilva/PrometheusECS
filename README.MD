# Prometheus ECS

<p align="center">
      <img src='https://raw.githubusercontent.com/GabrielBernardoDaSilva/PrometheusECS/master/prometheus-ecs.png' alt='PrometheuECS'/>
</p>

## Description
- **Improve game performance**: By decoupling game logic from the representation of game objects, ECS can significantly enhance performance through efficient data organization and optimized component updates.
Increase code reusability: Components can be easily reused across different entities, promoting modularity and reducing code duplication.
- **Simplify game development**: The ECS architecture makes it easier to manage and maintain complex game systems, as game logic is organized in a more structured and predictable way.

## Features

- **Entity Creation**: Easily create entities and attach components to them.
- **Event Handling**: Implement event-driven architecture with custom events and event handlers.
- **Coroutines**: Create a coroutine to be executed at specific intervals or delays.
- **Queries**: Efficiently query entities based on their components.
- **Systems**: Implement game logic and behaviors through systems that process entities based on queries.
- **Extensions**: Extend the functionality of the ECS with custom extensions.
- **Chained Building**: World could be create by a chain of methods.

## Example

Demonstrates how to use the `Prometheus` library to create an Entity Component System (ECS) in Swift. The example includes creating components, querying entities, and setting up systems to interact with those components.

## Setup

First, add the `PrometheusECS` dependency to your `Package.swift`:


### Imports

For this example the necessary imports:

```swift
import PrometheusECS

```

### Components

Define your components. Components are data associated with entities.

```swift
class Position : Component {
    public var x: Int
    public var y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

```

### Systems

Define systems to operate on entities that have specific components. Systems are functions that process entities.

```swift
    func mutateCompoentInsideSystem(entityManager: EntityManager) throws {
        try entityManager.addEntity(components: Position(x: 2, y: 2))
    }
    
    func mutateComponentSystem(query: Query<Position>) {
        for position in query {
            position.x += 1
        }
    }
```

### Events

Define events that can be published and subscribed to within the world.

```swift
class SpawnEvent : Event {
    public let entity: Entity
    
    init(entity: Entity) {
        self.entity = entity
    }
}

func spawn(entityManager: EntityManager,eventManager: EventManager, query: Query<Entity, Health, Position>) {
    print("Spawn")
    for q in query{
        try? entityManager.addComponentToEntity(entity: q.0, component: Velocity(dx: 0, dy: 0))
        print(q.0)
        
    }
    
    eventManager.subscribe(SpawnEvent.self) { (world: World, ev: SpawnEvent) in
        
        print("Ev: \(ev.entity)")
    }
    
}

```

### Resources

Define resources that are globally accessible by systems.

```swift
class GameState : Component{
    public enum State {
        case playing
        case paused
    }
    var state: State = .playing
}

func initResource(resourceManager: ResourceManager) {
    resourceManager.createResource(GameState())
}

func getResource(gameState: Resource<GameState>) {
    print(gameState.data.state)
}


```

### Extension

Define easy extensions to your world.

```swift
class ExtensionExample: PluginBuilder {
    func build(_ world: PrometheusECS.World) throws {
        try world.addEntity(components: Velocity(dx: 0, dy: 0))
    }
}
```

### Main Function

Set up the world, create entities, add systems, and run the ECS.

```swift
import PrometheusECS

final class Health: Component {
    var health: Int = 0
    init(health: Int) {
        self.health = health
    }
}

extension Health : CustomStringConvertible {
    var description: String {
        "Health: \(health)"
    }
}

class Position: Component {
    var x: Int = 0
    var y: Int = 0
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

extension Position: CustomStringConvertible{
    var description: String {
        "Position: (\(x),\(y))"
    }
}


class Velocity: Component {
    var dx: Int = 0
    var dy: Int = 0
    
    init(dx: Int, dy: Int) {
        self.dx = dx
        self.dy = dy
    }
}

class GameState : Component{
    public enum State {
        case playing
        case paused
    }
    
    var state: State = .playing
}


class SpawnEvent : Event {
    public let entity: Entity
    
    init(entity: Entity) {
        self.entity = entity
    }
}

extension Velocity: CustomStringConvertible {
    var description: String {
        "Velocity: (\(dx),\(dy))"
    }
}




var world = World()
try world.addEntity(components:  Health(health: 100), Position(x: 0, y: 0))
try world.addEntity(components:  Health(health: 200))
try world.addEntity(components:  Velocity(dx: 20, dy: 0), Health(health: 70))



let q = world.query(requiredAll: Health.self, Position.self)
for (e, p) in q {
    print(p, e.health)
}

func spawn(entityManager: EntityManager,eventManager: EventManager, query: Query<Entity, Health, Position>) {
    print("Spawn")
    for q in query{
        try? entityManager.addComponentToEntity(entity: q.0, component: Velocity(dx: 0, dy: 0))
        print(q.0)
        
    }
    
    eventManager.subscribe(SpawnEvent.self) { (world: World, ev: SpawnEvent) in
        
        print("Ev: \(ev.entity)")
    }
    
}

func checkWithAddComponent(entityManager: EntityManager,eventManager: EventManager, query: Query<Entity, Health, Position, Velocity>) {
    print("Check")
    for q in query{
        _ = try? entityManager.removeComponentFromEntity(entity: q.0) as Velocity.Type
        print("Second \(q.0)")
        eventManager.publish( SpawnEvent(entity: q.0))
        
    }
}

func removeEntity(entityManager: EntityManager, query: QueryWithFilter<QueryBuilder<Entity, Health>, QueryBuilderExclude<Position>>) {
    for (entity,_ ) in query {
        try? entityManager.removeEntity(entity)
        print("Remove entity \(entity)")
    }
}

func initResource(resourceManager: ResourceManager) {
    resourceManager.createResource(GameState())
}

func getResource(gameState: Resource<GameState>) {
    print(gameState.data.state)
}

func coroutineManagerTest(coroutineManager: CoroutineManager){
    coroutineManager.addCoroutine(name: "CoroutineTest", action: [
        (10.0, {(World) in print("CoroutineTest is playing1")}),
        (10.0, {(World) in print("CoroutineTest is playing2")})
    ])
}

_ = Query<Health, Position>.getParam(world)

world.addSystemFunction(schedule: .start, spawn)

world.addSystemFunction(schedule: .start, checkWithAddComponent)

world.addSystemFunction(schedule: .start, removeEntity)

world.addSystemFunction(schedule: .start, initResource)

world.addSystemFunction(schedule: .start, getResource)

world.addSystemFunction(schedule: .start, coroutineManagerTest)


world.executeSystems()
world.entityManager.printAllArchetypes()

```

### Running the Project

To run the project:

```bash
swift run
```

This will compile and run your ECS example, demonstrating how to create and manage entities, components, systems, events, and resources using PrometheusECS library.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
