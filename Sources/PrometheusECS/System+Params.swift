//
//  System+Params.swift
//  prometheus-ecs
//
//  Created by Gabriel Bernardo on 23/12/24.
//

public protocol SystemParams: AnyObject {
    static func getParam(_ world: World) -> Self?
}


