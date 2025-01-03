//
//  Resource.swift
//  prometheus-ecs
//
//  Created by Gabriel Bernardo on 24/12/24.
//

public protocol ResourceProtocol: SignatureProvider {
    associatedtype DataType
    var data: DataType { get }
}

public protocol Resource: SignatureProvider {}


public final class ResourceContainer<T: Resource> : ResourceProtocol {
    public typealias DataType = T
    
    private var _data: T
    
    init(data: T) {
        _data = data
    }
    
    public var data: DataType {
        _data
    }
}


extension ResourceContainer : SystemParams{
    public static func getParam(_ world: World) -> ResourceContainer<DataType>? {
        world.resourceManager.getResource(ResourceContainer<DataType>.self)
    }
    
    
}
