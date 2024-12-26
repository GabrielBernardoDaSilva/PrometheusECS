import Foundation

public final class Archetype {
    var components: [Signature: ComponentList] = [:]
    var entities: [Entity] = []
    
    private var _name: String

    init(_ entity: Entity, list componentsList: [Component]) {
        for component in componentsList {
            let signature = component.signature
            let componentList = ComponentList()
            componentList.addComponent(component)
            self.components[signature] = componentList
        }

        let entityHash = entity.signature
        let entityComponentList = ComponentList()
        entityComponentList.addComponent(entity)
        self.components[entityHash] = entityComponentList

        self.entities.append(entity)
        
        _name = componentsList.map{
            String(describing: Mirror(reflecting: $0).description)
        }.joined(separator: ",")
    }
}


extension Archetype {
    public func addEntity(entity: Entity, components: [Component]) {
        for component in components {
            
            if let componentList =  self.components[component.signature] {
                componentList.addComponent(component)
                self.components[component.signature] = componentList
            } else {
                let componentList = ComponentList()
                componentList.addComponent(component)
                self.components[component.signature] = componentList
            }
        }

        self.components[entity.signature]?.addComponent(entity)
        self.entities.append(entity)
    }

    
    public func migrateEntity(_ entityIndex: Int) -> (Entity, [Component]) {
        let entity = entities[entityIndex]
        var components: [Component] = []
        for componentList in self.components.values {
            let removedComponent = componentList.removeComponent(entityIndex) as Component
            components.append(removedComponent)
        }
        
        // remove entity
        entities.remove(at: entityIndex)
        
        return (entity, components)
    }

    public func getComponent<T: Component>(_ entityIndex: Int, of type: T.Type) throws(ArchetypeError) -> T? where T : Component {
        if let componentList = self.components[T.signature] {
            return componentList.getComponent(entityIndex)
        } else {
            throw ArchetypeError.componentNotFound
        }
    }
    
    public func getTypes() -> [Signature] {
        return Array(self.components.keys)
    }
}



extension Archetype {
    public func printComponents() {
        for componentList in self.components.values {
            for component in componentList.getComponents() {
                print(component)
            }
        }
    }

    public var name: String {
        return _name
     }
    
    public func debugArchetype() {
        print("----------------------")
        print(components)
        print(name)
        print(entities)
        print("______________________")
    }
}
