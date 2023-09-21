import ProjectDescription

public extension ProjectDescription.Path {
    static func relativeToFeature(_ path: String) -> Self {
        return .relativeToRoot("Projects/Feature/\(path)")
    }
    
    static func relativeToCore(_ path: String) -> Self {
        return .relativeToRoot("Projects/Core/\(path)")
    }
    
    static func relativeToDomain(_ path: String) -> Self {
        return .relativeToRoot("Projects/Domain/\(path)")
    }
    
    static func relativeToShared(_ path: String) -> Self {
        return .relativeToRoot("Projects/Shared/\(path)")
    }
}

public extension TargetDependency {
    static func feature(name: String) -> Self {
        return .project(target: name, path: .relativeToFeature(name))
    }
    
    static func core(name: String) -> Self {
        return .project(target: name, path: .relativeToCore(name))
    }
    
    static func domain(name: String) -> Self {
        return .project(target: name, path: .relativeToDomain(name))
    }
    
    static func shared(name: String) -> Self {
        return .project(target: name, path: .relativeToShared(name))
    }
}
