//
//  Coroutine+World.swift
//  prometheus-ecs
//
//  Created by Gabriel Bernardo on 23/12/24.
//

extension World {
    
    public func addCoroutine(name: String, action coroutine: Action) -> CoroutineSignature{
        coroutineManager.addCoroutine(name: name, action: coroutine)
    }
    
    public func removeCoroutine(signature: SignatureType) throws(CoroutineError) {
        try coroutineManager.removeCoroutine(signature: signature)
    }
    
    public func excuteCoroutines() {
        coroutineManager.excuteCoroutines()
    }
    
    public func stopCoroutines(signature: SignatureType) throws (CoroutineError){
        try coroutineManager.stopCoroutines(signature: signature)
    }
    
    public func stopAllCoroutines(){
        coroutineManager.stopAllCoroutines()
    }
    
    public func resumeCoroutines(signature: SignatureType) throws (CoroutineError){
        try coroutineManager.resumeCoroutines(signature: signature)
    }
    
    public func resumeAllCoroutines(){
        coroutineManager.resumeAllCoroutines()
    }
    
   
}
