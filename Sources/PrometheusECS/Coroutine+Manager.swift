//
//  Coroutine+Manager.swift
//  prometheus-ecs
//
//  Created by Gabriel Bernardo on 24/12/24.
//

public final class CoroutineManager {
    private var _coroutines: [CoroutineSignature: TimedCoroutine] = [:]
    private unowned let _world: World
    
    init(world: World) {
        _world = world
    }
}

extension CoroutineManager {
    @discardableResult
    public func addCoroutine(name: String, action coroutine: Action) -> CoroutineSignature{
        let timedCoroutine = TimedCoroutine(name, coroutine, _world)
        _coroutines[timedCoroutine.signature] = timedCoroutine
        return timedCoroutine.signature
    }
    
    public func removeCoroutine(signature: SignatureType) throws(CoroutineError) {
        switch signature {
        case .coroutine(let signature):
            guard _coroutines[signature] != nil else {
                throw CoroutineError.coroutineNotFounded
            }
            _coroutines[signature] = nil
        case .named(let name):
            guard let coroutine = _coroutines.first(where: { $0.value.name == name }) else {
                throw CoroutineError.coroutineNotFounded
            }
            _coroutines[coroutine.key] = nil
        }
        
        
    }
    
    public func excuteCoroutines() {
        for coroutine in _coroutines.values {
            coroutine.next() == .finished ? _coroutines[coroutine.signature] = nil : ()
        }
    }
    
    public func stopCoroutines(signature: SignatureType) throws (CoroutineError){
        guard let coroutine = searchCoroutine(signature: signature) else { throw CoroutineError.coroutineNotFounded }
        coroutine.isRunning = false
        
    }
    
    public func stopAllCoroutines() {
        _coroutines.values.forEach {
            $0.isRunning = false
        }
    }
    
    public func resumeCoroutines(signature: SignatureType) throws (CoroutineError) {
        guard let coroutine = searchCoroutine(signature: signature) else { throw CoroutineError.coroutineNotFounded }
        if coroutine.next() != .finished { coroutine.isRunning = true }
    }
    
    public func resumeAllCoroutines() {
        _coroutines.values.forEach {
            if $0.next() != .finished { $0.isRunning = true }
        }
    }
    
    private func searchCoroutine(signature: SignatureType) -> TimedCoroutine? {
        switch signature {
        case .coroutine(let signature):
            return _coroutines[signature]
        case .named(let name):
            return _coroutines.first(where: { $0.value.name == name })?.value
        }
    }
    
    public func updateAllCoroutines() {
        _coroutines.values.forEach { $0.next() }
    }

}


extension CoroutineManager: SystemParams {
    public static func getParam(_ world: World) -> CoroutineManager? {
        world.coroutineManager
    }
    
    
}
