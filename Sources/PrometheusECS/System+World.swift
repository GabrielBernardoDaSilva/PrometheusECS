//
//  System+World.swift
//  prometheus-ecs
//
//  Created by Gabriel Bernardo on 23/12/24.
//

extension World {
    private func startSystems() throws {
        systemManager.start()
        try systemManager.startFunctional()
    }
    
    private func updateSystems() throws {
        systemManager.update()
        try systemManager.updateFunctional()
        coroutineManager.updateAllCoroutines()
    }
    
    private func disposeSystems() throws{
        systemManager.dispose()
        try systemManager.disposeFunctional()
    }
    
    public func executeSystems() throws {
        isRunning = true
        
        try startSystems()
        while isRunning {
            try updateSystems()
        }
        try disposeSystems()
    }
    
    public func singleExecuteSystems() throws{
        try startSystems()
        try updateSystems()
        try disposeSystems()
    }
}


extension World {
    public func addSystem(_ system: System) {
        systemManager.addSystem(system)
    }
}


extension World {
    public func addSystemFunction<each P: SystemParams>(schedule: SystemFunctionExecution, _ systemFunction: @escaping (repeat each P) throws -> ()) throws where repeat each P: SystemParams {
        let function = try SystemFunction<repeat each P>(execute: systemFunction, world: self)
        systemManager.addSystemFunctional(schedule: schedule, action: function)
    }
}
