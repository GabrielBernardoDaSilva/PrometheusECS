//
//  System.swift
//  prometheus-ecs
//
//  Created by Gabriel Bernardo on 23/12/24.
//
protocol SystemBase {
    var world: World { get }
}

public class SystemExecutable {
    open func run() throws{}
}

public class System: SystemBase {

    private let _world: World
    var world: World {
        _world
    }
    
    
    init(world: World) {
        _world = world
    }
    
    open func start() {}
    open func update() {}
    open func dispose() {}
}


