import Foundation

// MARK: - Data Models

struct ModelData: Sendable, Codable {
    let name: String
    let attributeCount: Int
    let relationshipCount: Int
    let entityCount: Int
    let attributes: [AttributeData]
    let relationships: [RelationshipData]
    
    let instances: [ObjectInstanceData]
}

struct AttributeData: Sendable, Codable {
    let name: String
    let type: String
    let optional: Bool
}

struct RelationshipData: Sendable, Codable {
    let name: String
    let destinationEntity: String
    let toMany: Bool
    let optional: Bool
}

struct ObjectInstanceData: Sendable, Codable {
    let objectID: String
    let attributeValues: [String: String]
}
