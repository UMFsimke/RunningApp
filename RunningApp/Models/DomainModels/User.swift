struct User {
    
    let id: String
    let email: String
    let token: String
}

//MARK: - JSONDecodable

extension User: JSONDecodable {
    
    static func from(_ json: JSON) throws -> User {
        return User(id: json["id"].stringValue,
                    email: json["email"].stringValue,
                    token: json["token"].stringValue)
    }
}
