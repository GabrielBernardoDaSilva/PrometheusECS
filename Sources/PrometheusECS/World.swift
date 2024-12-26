import Foundation

public typealias Identifier = Int
public typealias IdentifierUUID = UUID

final public class World {

    internal var plugins: [PluginBuilder] = []


    
    internal lazy var systemManager: SystemManager = .init()
    internal lazy var entityManager: EntityManager = .init(world: self)
    internal lazy var eventManager: EventManager = .init(world: self)
    internal lazy var coroutineManager: CoroutineManager = .init(world: self)
    internal lazy var resourceManager: ResourceManager = .init(world: self)
    
    
    public var isRunning: Bool = false
}
