//
//  Event+Manager.swift
//  prometheus-ecs
//
//  Created by Gabriel Bernardo on 24/12/24.
//


public final class EventManager {
    private var _subscribers: [Signature: [(World, Any) -> Void]] = [:]
    private unowned var _world: World
    
    public init(world: World) {
        _world = world
    }
    
    
    
    public func subscribe<Ev: Event>(_ eventType: Ev.Type, _ function: @escaping (World, Ev) -> Void) {
        let signature = eventType.signature
        
        let wrapper: (World, Any) -> Void = { world, event in
            if let specificEvent = event as? Ev {
                function(world, specificEvent)
            }
        }
        
        if _subscribers[signature] != nil {
            _subscribers[signature]?.append(wrapper)
        } else {
            _subscribers[signature] = [wrapper]
        }
    }
    
    public func publish<Ev: Event>(_ event: Ev) {
        let signature = event.signature
        _subscribers[signature]?.forEach { $0(_world, event) }
    }
    
    public func unsubscribe<Ev: Event>(ev: Ev.Type) {
        _subscribers.removeValue(forKey: ev.signature)
    }
}


extension EventManager: SystemParams {
    public static func getParam(_ world: World) -> EventManager? {
        world.eventManager
    }
    
    
}
