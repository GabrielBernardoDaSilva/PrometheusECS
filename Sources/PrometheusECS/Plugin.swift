//
//  File.swift
//  prometheus-ecs
//
//  Created by Gabriel Bernardo on 23/12/24.
//

public protocol PluginBuilder {
    func build(_ world: World) throws
}


extension World {
    public func buildPlugins() throws {
        try plugins.forEach { try $0.build(self)}
    }
    
    public func addPlugin(_ plugin: PluginBuilder) {
        plugins.append(plugin)
    }
}
