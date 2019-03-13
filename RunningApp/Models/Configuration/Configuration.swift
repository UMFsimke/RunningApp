import Foundation

public struct Configuration {
    
    fileprivate let configuration: ApplicationConfiguration
    
    init(configuration: ApplicationConfiguration = Configuration.currentConfiguration) {
        self.configuration = configuration
    }
    
}

//MARK: ApplicationConfiguration

extension Configuration: ApplicationConfiguration {
    
    public var domain: String {
        return configuration.domain
    }
    
    public var apiHost: String {
        return configuration.apiHost
    }
    
}

// MARK: - Convenience Properties

extension Configuration {
    
    public static var isTest: Bool {
        return current == .Test
    }
    
    public static var isRelease: Bool {
        switch current {
            
        case .Test:
            return false
        
        default:
            return true
            
        }
    }
    
    static var current: ConfigurationType {
        guard
            let infoDictionary = Bundle.main.infoDictionary,
            let configurationName = infoDictionary["Configuration"] as? String,
            let buildConfiguration = ConfigurationType(rawValue: configurationName)
            else { return .Release }
        
        return buildConfiguration
    }
    
}

// MARK: - Runtime Configuration Determination

fileprivate extension Configuration {
    
    static var currentConfiguration: ApplicationConfiguration {
        switch current {
        case .Test:
            return TestConfiguration()
            
        default:
            return ReleaseConfiguration()
        }
    }
    
}
