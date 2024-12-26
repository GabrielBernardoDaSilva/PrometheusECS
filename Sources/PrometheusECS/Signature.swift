//
//  Signature.swift
//  prometheus-ecs
//
//  Created by Gabriel Bernardo on 24/12/24.
//


public struct Signature {
    private let _id: Identifier
    
    public var id : Identifier{
        return _id
    }
    
    @usableFromInline init(_ eventType: (some Any).Type) {
         _id = ObjectIdentifier(eventType).hashValue
    }
}


extension Signature : Hashable {}
extension Signature : Equatable {}
extension Signature: CustomStringConvertible {
    public var description: String { "\(id)" }
}



public protocol SignatureProvider {
    /// Unique, immutable identifier of this component type.
    static var signature: Signature { get }

    /// Unique, immutable identifier of this component type.
    var signature: Signature { get }
}


extension SignatureProvider {
    public static var signature: Signature { Signature(Self.self) }
    @inline(__always)
    public var signature: Signature { Self.signature }
}
