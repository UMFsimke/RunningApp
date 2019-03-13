import Swifter
import Rswift

public typealias Server = HttpServer

//MARK: - Start Server

public extension Server {
    
    public static func start(on port: PortNumber = Server.port) throws -> HttpServer {
        let server = HttpServer()
        server.setupApi()
        try server.start(port)
        return server
    }
    
    public func reset() {
        setupApi()
    }
    
}

// MARK: - HttpResponse from File

public extension HttpResponseBody {
    
    public static var empty: HttpResponseBody {
        return .json([:] as AnyObject)
    }
    
    public static func file(_ file: Rswift.FileResource) -> HttpResponseBody {
        guard let path = file.path() else { fatalError("Path to \(file) could not be found.") }
        guard let data = FileManager.default.contents(atPath: path) else { fatalError("Could not read the contents of file at \(path)") }
        guard let jsonRep = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            else { fatalError("Invalid JSON at \(path)") }
        
        return .json(jsonRep)
    }
    
}
