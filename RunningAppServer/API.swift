// MARK: - Setup
import Swifter
import Rswift
import Foundation

extension Server {
    
    func setupApi() {
        get["/profile"] = { _ in
            return self.ok(R.file.userJson)
        }
        
        post["/sign_up/"] = { (req) in
            let bodyAsJson = req.parseUrlencodedForm()
            
            guard
                let emailParamQuery = bodyAsJson.first(where: {(key, _) in key == "email" }),
                case ("email", let email) = emailParamQuery
                else {
                    return self.ok(R.file.userJson)
            }
            
            if email == Server.duplicateUserEmail {
                let duplicateAccountErrorJson = "{\"message\": \"We've found a potential duplicate account based on the information you provided: test@gmail.com.\"}"
                
                return .raw(
                    409,
                    "Duplicate account",
                    ["Content-Type" : "application/json"],
                    { writer in
                        try? writer.write([UInt8](duplicateAccountErrorJson.utf8))
                })
            }
            
            return self.ok(R.file.userJson)
        }
        
        post["/sign_in/"] = { (req) in
            let bodyAsJson = req.parseUrlencodedForm()
            
            guard
                let emailParamQuery = bodyAsJson.first(where: {(key, _) in key == "email" }),
                let passwordParamQuery = bodyAsJson.first(where: {(key, _) in key == "password" }),
                case ("email", let email) = emailParamQuery,
                case ("password", let password) = passwordParamQuery
                else {
                    return self.ok(R.file.userJson)
            }
            
            if email != Server.validUserEmail && password != Server.validUserPassword {
                let invalidCredentialsJson = "{\"message\": \"Wrong email or password.\"}"
                
                return .raw(
                    409,
                    "Invalid credentials",
                    ["Content-Type" : "application/json"],
                    { writer in
                        try? writer.write([UInt8](invalidCredentialsJson.utf8))
                })
            }
            
            return self.ok(R.file.userJson)
        }
    }
    
    func ok(_ file: Rswift.FileResource) -> HttpResponse {
        return HttpResponse.ok(HttpResponseBody.file(file))
    }
}
