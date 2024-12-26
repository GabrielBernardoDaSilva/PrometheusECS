//
//  QueryBuilders.swift
//  prometheus-ecs
//
//  Created by Gabriel Bernardo on 22/12/24.
//


public struct QueryBuilder<each Comp>: QueryFactory where repeat each Comp: Component {
   
    
    public typealias ComponentTypes = (repeat (each Comp).Type)
    public typealias Components = (repeat each Comp)
    
    public init() {}
    
    public static func getComponentsSignature() -> [Signature] {
        var signatures: [Signature] = []
        for type in repeat (each Comp).signature {
            signatures.append(type)
        }
        return signatures
    }
    
    public static func components(archetype: Archetype, entityId: Int) -> (repeat each Comp) {
        return (repeat try! archetype.getComponent(entityId, of: (each Comp).self)!)
    }
}


public struct QueryBuilderExclude<each Comp>: QueryExcludeFactory where repeat each Comp: Component {
 
    typealias ComponentTypes = (repeat (each Comp).Type)
    
    public init() {}
  
    public static func getExcludedSignatures() -> [Signature] {
        var signatures: [Signature] = []
        for type in repeat (each Comp).signature {
            signatures.append(type)
        }
        return signatures
    }
}





public struct NoExclusions: QueryExcludeFactory {
    public init(){
        
    }
    public static func getExcludedSignatures() -> [Signature] {
        return []
    }
}
