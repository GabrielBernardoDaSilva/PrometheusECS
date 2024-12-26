public protocol Component: SignatureProvider, AnyObject {}



public class ComponentList {
    public var components: [Component] = []
}


extension ComponentList {
    public func addComponent<T: Component> (_ component: T) where T: AnyObject{
        components.append(component)
    }
    
    public func removeComponent<T: Component>(_ index: Int) -> T? {
        return components.remove(at: index) as? T
    }
    
    public func removeComponent(_ index: Int) -> Component {
        return components.remove(at: index)
    }
    
    public func filterComponents(_ predicate: (Component) -> Bool) -> [Component] {
        return components.filter(predicate)
    }

    public func getComponent<T: Component>(_ index: Int) -> T? {
        return components[index] as? T
    }

    public func getComponents() -> [Component] {
        return components
    }
}



