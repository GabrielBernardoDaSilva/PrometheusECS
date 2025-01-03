//
//  Resource+Manager.swift
//  prometheus-ecs
//
//  Created by Gabriel Bernardo on 24/12/24.
//

public final class ResourceManager {
    private var _resources: [Signature: any ResourceProtocol] = [:]
    private unowned var _world: World
    
    public init(world: World) {
        _world = world
    }
}



extension ResourceManager {
    public func createResource<T: Resource>(_ resourceData: T) {
        let resource = ResourceContainer(data: resourceData)
        _resources[resource.signature] = resource
    }
    
    public func getResource<R: ResourceProtocol>(_ type: R.Type) -> R? {
        _resources[R.signature] as? R
    }
    
    @discardableResult
    public func removeResource<R: ResourceProtocol>() -> R? {
        let resource = _resources[R.signature]
        _resources[R.signature] = nil
        return resource as? R
    }
}


extension ResourceManager : SystemParams {
    public static func getParam(_ world: World) -> ResourceManager? {
        world.resourceManager
    }
}
