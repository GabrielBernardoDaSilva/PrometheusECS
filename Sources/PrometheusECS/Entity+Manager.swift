//
//  Entity+Manager.swift
//  prometheus-ecs
//
//  Created by Gabriel Bernardo on 23/12/24.
//


public final class EntityManager {
    private unowned var _world: World
    private var _archetypes: [Archetype] = []
    private var _entities: [Entity] = []
    
    
    public var archetypes: [Archetype] {
        _archetypes
    }
    
    public var entities: [Entity] {
        _entities
    }
    
    public init(world: World) {
        _world = world
    }
    
    public func addEntity(componentList components: [Component]) throws (ArchetypeError) {
        var types = components.map(\.signature)
        var seen = Set<Signature>()
        if types.contains(where: { !seen.insert($0).inserted }) {
            throw ArchetypeError.componentAlreadyRegistered
        }
        
        
        types.append(Entity.signature)
        if let founded = findArchetype(in: types) {
            let location = founded.1
            let archetype = founded.0
            let entity = Entity(id: _entities.count, location: location)
            archetype.addEntity(entity: entity, components: components)
        } else {
            let location = _archetypes.count
            let entity = Entity(id: _entities.count, location: location)
            let  archetype = createArchetype(entity: entity, components: components)
            _archetypes.append(archetype)
            _entities.append(entity)
            
        }
    }
    
    private func createArchetype(entity: Entity, components: [Component]) ->  Archetype {
        
        let archetype = Archetype(entity, list: components)
        return  archetype
    }
    
    public func addEntity(components: Component...) throws (ArchetypeError) {
        try addEntity(componentList: components)
    }
    
    public func addComponentToEntity<T: Component>(entity: Entity, component: T) throws(ArchetypeError) {
        guard let archetypeIndex = _archetypes.firstIndex(where: { $0.entities.contains(entity) }) else {
            throw .entityNotFound
        }
        
        let entityIndex = _archetypes[archetypeIndex].entities.firstIndex(of: entity)!
        var migratedEntity = _archetypes[archetypeIndex].migrateEntity(entityIndex)
        
        clearEmptyArchetype(archetypeIndex: archetypeIndex)
        
        migratedEntity.1.append(component)
        
        let migratedEntitySignature = migratedEntity.1.map{
            $0.signature
        }
        
        if let destinyArchetype = findArchetype(in: migratedEntitySignature) {
            migratedEntity.0.location = archetypeIndex
            destinyArchetype.0.addEntity(entity: migratedEntity.0, components: migratedEntity.1)
            return
        }
        
        let newLocation = _archetypes.count
        migratedEntity.0.location = newLocation
        let newArchetype = createArchetype(entity: migratedEntity.0, components: migratedEntity.1)
        _archetypes.append(newArchetype)
        
    }
    
    @discardableResult
    public func removeComponentFromEntity<T: Component>(entity: Entity) throws(ArchetypeError) -> T.Type {
        guard let archetypeIndex = _archetypes.firstIndex(where: { $0.entities.contains(entity) }) else {
            throw .entityNotFound
        }
        
        let entityIndex = _archetypes[archetypeIndex].entities.firstIndex(of: entity)!
        var migratedEntity = _archetypes[archetypeIndex].migrateEntity(entityIndex)
        
        clearEmptyArchetype(archetypeIndex: archetypeIndex)
        
        migratedEntity.1.removeAll(where: { $0.signature == T.signature })
        
        let migratedEntitySignature = migratedEntity.1.map{
            $0.signature
        }
        
        if let destinyArchetype = findArchetype(in: migratedEntitySignature) {
            migratedEntity.0.location = archetypeIndex
            destinyArchetype.0.addEntity(entity: migratedEntity.0, components: migratedEntity.1)
            return T.self
        }
        
        let newLocation = _archetypes.count
        migratedEntity.0.location = newLocation
        let newArchetype = createArchetype(entity: migratedEntity.0, components: migratedEntity.1)
        _archetypes.append(newArchetype)
        
        return T.self
        
    }
    
    public func removeEntity(_ entity: Entity) throws (ArchetypeError) {
        guard let archetypeIndex = _archetypes.firstIndex(where: { $0.entities.contains(entity) }) else {
            throw .entityNotFound
        }
        
        let entityIndex = _archetypes[archetypeIndex].entities.firstIndex(of: entity)!
        var migratedEntity = _archetypes[archetypeIndex].migrateEntity(entityIndex)
        
        clearEmptyArchetype(archetypeIndex: archetypeIndex)
        
        if migratedEntity.1.isEmpty {
            migratedEntity.1.removeAll(keepingCapacity: false)
        }
    }
    
    private func findArchetype(in types: [Signature]) -> (Archetype, Int)? {
        for (index, archetype) in _archetypes.enumerated() {
            let archetypeTypes = archetype.getTypes()
            if archetypeTypes.allSatisfy(types.contains) && archetypeTypes.count == types.count {
                return (archetype, index)
            }
        }
        return nil
    }
    
    private func clearEmptyArchetype(archetypeIndex: Int) {
        if _archetypes[archetypeIndex].entities.isEmpty {
            if archetypeIndex < archetypes.count - 1 {
                // change location from entities above it
                for i in archetypeIndex..<archetypes.count {
                    for entity in _archetypes[i].entities {
                        entity.location = i - 1
                    }
                }
            }
            
            _archetypes.remove(at: archetypeIndex)
        }
    }
}



extension EntityManager: SystemParams {
    public static func getParam(_ world: World) -> EntityManager? {
        world.entityManager
    }
}


extension EntityManager {
    public func printAllArchetypes() {
        print("---------------------")
        print("Archetypes:")
        for archetype in archetypes {
            archetype.debugArchetype()
        }
        print("_____________________")
    }
    
}
