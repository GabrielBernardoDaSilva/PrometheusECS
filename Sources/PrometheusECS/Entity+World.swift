//
//  Entity+Manager+World.swift
//  prometheus-ecs
//
//  Created by Gabriel Bernardo on 24/12/24.
//

extension World {
    public func addEntity(components: Component...) throws (ArchetypeError){
        try entityManager.addEntity(componentList: components)
    }
    
    public func removeComponentFromEntity<T: Component>(entity: Entity) throws (ArchetypeError) -> T.Type{
        try entityManager.removeComponentFromEntity(entity: entity)
    }
    
    public func addComponentToEntity<T: Component>(entity: Entity, component: T) throws (ArchetypeError){
        try entityManager.addComponentToEntity(entity: entity, component: component)
    }
    
}
