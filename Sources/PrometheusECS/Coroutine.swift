//
//  Coroutine.swift
//  prometheus-ecs
//
//  Created by Gabriel Bernardo on 23/12/24.
//

import Foundation

public protocol Coroutine {
    func next() -> CoroutineState
}


public struct CoroutineSignature{
    public let id : IdentifierUUID
    
    @usableFromInline init() {
        id = .init()
    }
}

extension CoroutineSignature : Hashable {}
extension CoroutineSignature : Equatable {}
extension CoroutineSignature: CustomStringConvertible {
    public var description: String { "\(id)" }
}

public typealias Action = [ (TimeInterval,(World) -> Void ) ]

public class TimedCoroutine: Coroutine {
    private var _action: Action
    private var _currentStep = 0
    private var _lastExecutionTime: Date
    private var _name: String
    private unowned var _world: World
    private var _isRunning: Bool = false

    
    private let _coroutineSignature: CoroutineSignature = .init()
    
    
    var signature: CoroutineSignature { _coroutineSignature }
    var name : String { _name }
    
    var isRunning: Bool {
        set {
            _isRunning = newValue
        }
        get {
            _isRunning
        }
    }
    
    
    init(_ name: String,_ action: Action,_ world: World) {
        _action = action
        _world = world
        _name = name
        _isRunning = true
        _lastExecutionTime = Date()
    }
    
    @discardableResult
    public func next() -> CoroutineState {
        guard _isRunning else {
            return CoroutineState.suspended
        }
        
        guard _currentStep < _action.count else {
            return CoroutineState.finished
        }
        
        let (delay, step) = _action[_currentStep]
        let now = Date()
        
        
        if  now.timeIntervalSince(_lastExecutionTime) >= delay {
            step(_world) // Execute the current step
            _lastExecutionTime = now
            _currentStep += 1
        }
        
        return _currentStep < _action.count ? .finished : .running
    }
}



public enum SignatureType {
    case coroutine(CoroutineSignature)
    case named(String)
}


public enum CoroutineState {
    case running
    case suspended
    case finished
}
