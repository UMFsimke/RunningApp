protocol JSONDecodable {
    static func from(_ json: JSON) throws -> Self
}
