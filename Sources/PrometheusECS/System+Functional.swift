//
//  System+Functional.swift
//  prometheus-ecs
//
//  Created by Gabriel Bernardo on 24/12/24.
//


public final class SystemFunction<each P: SystemParams> : SystemExecutable{
    public typealias Param = (repeat each P) throws -> ()
    
    private let _execute: Param
    public unowned let _world: World
    init(execute: @escaping Param, world: World) rethrows {
        _execute = execute
        _world = world
    }
    
    public override func run() throws {
       try _execute(repeat (each P).getParam(_world)!)
    }
}

public enum SystemFunctionExecution {
    case start
    case update
    case dispose
}
