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

public final class Resource<T: Component> : ResourceProtocol {
    public typealias DataType = T
    
    private var _data: T
    
    init(data: T) {
        _data = data
    }
    
    public var data: DataType {
        _data
    }
}


extension Resource : SystemParams{
    public static func getParam(_ world: World) -> Resource<DataType>? {
        world.resourceManager.getResource(Resource<DataType>.self)
    }
    
    
}
