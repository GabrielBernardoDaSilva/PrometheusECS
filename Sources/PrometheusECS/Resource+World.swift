//
//  Resource+World.swift
//  PrometheusECS
//
//  Created by Gabriel Bernardo on 03/01/25.
//

extension World {
    public func addResource<R: Resource>(_ resource: R) {
        resourceManager.createResource(resource)
    }
    
    @discardableResult
    public func removeResource<R: ResourceProtocol>() -> R? {
        return resourceManager.removeResource()
    }
    
    public func getResource<R: ResourceProtocol>(_ type: R.Type) -> R? {
        return resourceManager.getResource(type)
    }
}
