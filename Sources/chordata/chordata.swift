// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import CoreData

import FlyingFox

// MARK: - Data Models

struct ModelData: Sendable, Codable {
    let name: String
    let attributeCount: Int
    let relationshipCount: Int
    let entityCount: Int
    let attributes: [AttributeData]
    let relationships: [RelationshipData]
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

/// Implementation class for managing Core Data inspection
final class ChordataManagerImpl: Sendable {
    private let persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    /// Generate the main dashboard HTML
    func generateDashboardHTML() async -> String {
//        return ""
        return HTMLTemplate.dashboard
    }
    
    /// Get models data from the persistent container
    func getModelsDataSync() async -> [ModelData] {
        let context = persistentContainer.viewContext
        var modelsData: [ModelData] = []
        
        for entity in persistentContainer.managedObjectModel.entities {
            guard let entityName = entity.name else { continue }
            
            // Get entity count
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
            let entityCount = (try? context.count(for: fetchRequest)) ?? 0
            
            // Process attributes
            var attributes: [AttributeData] = []
            for attribute in entity.attributesByName.values {
                attributes.append(AttributeData(
                    name: attribute.name,
                    type: self.attributeTypeString(for: attribute.attributeType),
                    optional: attribute.isOptional
                ))
            }
            
            // Process relationships
            var relationships: [RelationshipData] = []
            for relationship in entity.relationshipsByName.values {
                relationships.append(RelationshipData(
                    name: relationship.name,
                    destinationEntity: relationship.destinationEntity?.name ?? "Unknown",
                    toMany: relationship.isToMany,
                    optional: relationship.isOptional
                ))
            }
            
            let modelData = ModelData(
                name: entityName,
                attributeCount: attributes.count,
                relationshipCount: relationships.count,
                entityCount: entityCount,
                attributes: attributes,
                relationships: relationships
            )
            
            modelsData.append(modelData)
        }
        
        return modelsData.sorted { $0.name < $1.name }
    }
    
    /// Convert Core Data attribute type to string representation
    private func attributeTypeString(for type: NSAttributeType) -> String {
        switch type {
        case .integer16AttributeType: return "Int16"
        case .integer32AttributeType: return "Int32"
        case .integer64AttributeType: return "Int64"
        case .decimalAttributeType: return "Decimal"
        case .doubleAttributeType: return "Double"
        case .floatAttributeType: return "Float"
        case .stringAttributeType: return "String"
        case .booleanAttributeType: return "Boolean"
        case .dateAttributeType: return "Date"
        case .binaryDataAttributeType: return "Data"
        case .UUIDAttributeType: return "UUID"
        case .URIAttributeType: return "URI"
        case .transformableAttributeType: return "Transformable"
        case .objectIDAttributeType: return "ObjectID"
        @unknown default: return "Unknown"
        }
    }
    

}

/// Web server for the Chordata Core Data inspector
final class ChordataWebServer: Sendable {
    private let manager: ChordataManagerImpl
    private let server: HTTPServer
    
    init(manager: ChordataManagerImpl) {
        self.manager = manager
        self.server = HTTPServer(port: 8080)
    }
    
    func start() async {
        // Main dashboard route
        await server.appendRoute("/") { @Sendable [manager] request in
            let htmlContent = await manager.generateDashboardHTML()
            
            return HTTPResponse(
                statusCode: .ok,
                headers: [.contentType: "text/html; charset=utf-8"],
                body: htmlContent.data(using: .utf8) ?? Data()
            )
        }
        
        // API route to get models data as JSON
        await server.appendRoute("/api/models") { @Sendable [manager] request in
            let modelsData = await manager.getModelsDataSync()
            
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            
            do {
                let jsonData = try encoder.encode(modelsData)
                return HTTPResponse(
                    statusCode: .ok,
                    headers: [.contentType: "application/json"],
                    body: jsonData
                )
            } catch {
                let errorResponse = ["error": "Failed to encode models data"]
                let errorData = try! JSONSerialization.data(withJSONObject: errorResponse)
                return HTTPResponse(
                    statusCode: .internalServerError,
                    headers: [.contentType: "application/json"],
                    body: errorData
                )
            }
        }
        
        do {
            try await server.run()
        } catch {
            print("Failed to start Chordata web server: \(error)")
        }
    }
}

/// A singleton class for managing long-running state in the chordata library.
public final class ChordataManager: Sendable {
    
    /// The shared singleton instance
    public static let shared = ChordataManager()
    
    /// Private initializer to prevent external instantiation
    private init() {}
    
    /// Initialize the ChordataManager with any required setup
    /// - Parameter persistentContainer: The Core Data persistent container to inspect
    public func initialize(persistentContainer: NSPersistentContainer) {
        // Create a new manager instance with the container
        let manager = ChordataManagerImpl(persistentContainer: persistentContainer)
        
        // Create and start the web server
        let webServer = ChordataWebServer(manager: manager)
        Task {
            await webServer.start()
        }

        print("Chordata initialization complete - Core Data Inspector running on http://localhost:8080")
    }
}
