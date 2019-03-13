struct TestConfiguration: ApplicationConfiguration {
    
    var domain: String {
        return "http://localhost:9000"
    }
    
    var apiHost: String {
        return domain + "/"
    }
}
