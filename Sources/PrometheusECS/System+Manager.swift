//
//  SystemManager.swift
//  prometheus-ecs
//
//  Created by Gabriel Bernardo on 24/12/24.
//

public class SystemManager {
    private var _systems: [System] = []
    private var _systemsFunctional: [SystemFunctionExecution: [SystemExecutable]] = [:]
}

// MARK: System Class
extension SystemManager {
    public func addSystem(_ system: System) {
        _systems.append(system)
    }

    public func start() {
        _systems.forEach { $0.start() }
    }

    public func update() {
        _systems.forEach { $0.update() }
    }

    public func dispose() {
        _systems.forEach { $0.dispose() }
    }
}

// MARK: System Functional
extension SystemManager {
    public func addSystemFunctional(
        schedule: SystemFunctionExecution, action systemFunctional: SystemExecutable
    ) {
        if let _ = _systemsFunctional[schedule] {
            _systemsFunctional[schedule]?.append(systemFunctional)
        } else {
            _systemsFunctional[schedule] = [systemFunctional]
        }
    }

    private func executeSystemFunctional(schedule: SystemFunctionExecution) throws {
       try _systemsFunctional[schedule]?.forEach { try $0.run() }
    }

    public func startFunctional() throws {
        try executeSystemFunctional(schedule: .start)
    }

    public func updateFunctional() throws {
        try executeSystemFunctional(schedule: .update)
    }

    public func disposeFunctional() throws{
        try executeSystemFunctional(schedule: .dispose)
    }
}

// MARK: Run all systems

extension SystemManager {
    public func runAllSystems() throws {
        start()
        try startFunctional()
        update()
        try updateFunctional()
        dispose()
        try disposeFunctional()
    }

    public func runAllForegroundSystems(isRunning: Bool) throws {
        while isRunning {
            update()
            try updateFunctional()
        }

    }
}
