//
//  Collection+Extensions.swift
//  prometheus-ecs
//
//  Created by Gabriel Bernardo on 23/12/24.
//



extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
