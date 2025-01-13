//
//  File.swift
//  prometheus-ecs
//
//  Created by Gabriel Bernardo on 22/12/24.
//

import Foundation



public class Entity: Component {
    private let _id: Int
    private var _location: Int
    
    init(id: Int, location: Int) {
        self._id = id
        self._location = location
    }
    
    public var id: Int {
        _id
    }
    
    
    public var location: Int {
        set {
            _location = newValue
        }
        get {
            _location
        }
    }
}

extension Entity: Equatable {
    public static func == (lhs: Entity, rhs: Entity) -> Bool {
        lhs.id == rhs.id
    }
}


extension Entity: CustomStringConvertible {
    public var description: String {
        "Entity: Id: \(id), Location: \(location)"
    }
}
