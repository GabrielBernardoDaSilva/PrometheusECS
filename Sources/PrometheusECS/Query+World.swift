//
//  Query+World.swift
//  prometheus-ecs
//
//  Created by Gabriel Bernardo on 23/12/24.
//


extension World{
    public func query<each Comp1, each Comp2>(requiredAll: repeat (each Comp1).Type, excludeAll: repeat (each Comp2).Type) -> QueryWithFilter<QueryBuilder< repeat each Comp1>, QueryBuilderExclude<repeat each Comp2>> where repeat each Comp1: Component{
        QueryWithFilter<QueryBuilder< repeat each Comp1>,  QueryBuilderExclude<repeat each Comp2>>(self)
    }
}

