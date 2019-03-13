import Foundation

struct ReleaseConfiguration: ApplicationConfiguration {
    
    var domain: String {
        //TODO: define your own host
        return ""
    }
    
    var apiHost: String {
        return domain + "/"
    }
}
