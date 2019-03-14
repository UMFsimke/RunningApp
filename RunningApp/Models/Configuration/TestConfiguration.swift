struct TestConfiguration: ApplicationConfiguration {
    
    var domain: String {
        return "https://localhost:9000"
    }
    
    var apiHost: String {
        return domain + "/"
    }
}
