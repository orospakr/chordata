import Foundation
import CoreData

import FlyingFox

// Chordata is a library for inspecting Core Data models.
// It provides a web interface for inspecting the models and their relationships.
// It is designed to be used in a SwiftUI application.
//
// To use Chordata, you need to initialize it with a persistent container.
// Then you can use the `ChordataManager` singleton to get the HTML content for the dashboard.

/// Implementation class for managing Core Data inspection
final class ChordataManagerImpl: Sendable {
    private let persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    /// Load static file from bundle resources
    func loadStaticFile(named fileName: String) -> Data? {
        guard let url = Bundle.module.url(forResource: fileName, withExtension: nil) else {
            print("Could not find resource: \(fileName)")
            return nil
        }
        
        do {
            return try Data(contentsOf: url)
        } catch {
            print("Error loading resource \(fileName): \(error)")
            return nil
        }
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
            
            // Get object instances (limit to first 100 for performance)
            let instances = await self.getObjectInstances(for: entityName, limit: 100)
            
            let modelData = ModelData(
                name: entityName,
                attributeCount: attributes.count,
                relationshipCount: relationships.count,
                entityCount: entityCount,
                attributes: attributes,
                relationships: relationships,
                instances: instances
            )
            
            modelsData.append(modelData)
        }
        
        return modelsData.sorted { $0.name < $1.name }
    }
    
    /// Get object instances for a specific entity
    func getObjectInstances(for entityName: String, limit: Int = 100) async -> [ObjectInstanceData] {
        let context = persistentContainer.viewContext
        var instances: [ObjectInstanceData] = []
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.fetchLimit = limit
        
        do {
            let objects = try context.fetch(fetchRequest)
            
            for object in objects {
                var attributeValues: [String: String] = [:]
                
                // Get all attribute values
                for (attributeName, _) in object.entity.attributesByName {
                    let value = object.value(forKey: attributeName)
                    attributeValues[attributeName] = self.formatAttributeValue(value)
                }
                
                let instance = ObjectInstanceData(
                    objectID: object.objectID.uriRepresentation().absoluteString,
                    attributeValues: attributeValues
                )
                
                instances.append(instance)
            }
        } catch {
            print("Error fetching instances for \(entityName): \(error)")
        }
        
        return instances
    }
    
    /// Format attribute value for display
    private func formatAttributeValue(_ value: Any?) -> String {
        guard let value = value else { return "nil" }
        
        switch value {
        case let date as Date:
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: date)
        case let decimal as NSDecimalNumber:
            return decimal.stringValue
        case let data as Data:
            return "\(data.count) bytes"
        case let uuid as UUID:
            return uuid.uuidString
        case let url as URL:
            return url.absoluteString
        default:
            return String(describing: value)
        }
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
        self.server = HTTPServer(port: 3290)
    }
    
    func start() async {
        // Main dashboard route - serve index.html
        await server.appendRoute("/") { @Sendable [manager] request in
            guard let htmlData = manager.loadStaticFile(named: "index.html") else {
                return HTTPResponse(
                    statusCode: .notFound,
                    headers: [.contentType: "text/plain"],
                    body: "Frontend not found".data(using: .utf8) ?? Data()
                )
            }
            
            return HTTPResponse(
                statusCode: .ok,
                headers: [.contentType: "text/html; charset=utf-8"],
                body: htmlData
            )
        }
        
        // Serve app.js
        await server.appendRoute("/app.js") { @Sendable [manager] request in
            guard let jsData = manager.loadStaticFile(named: "app.js") else {
                return HTTPResponse(statusCode: .notFound)
            }
            
            return HTTPResponse(
                statusCode: .ok,
                headers: [.contentType: "application/javascript"],
                body: jsData
            )
        }
        
        // Serve app.css
        await server.appendRoute("/app.css") { @Sendable [manager] request in
            guard let cssData = manager.loadStaticFile(named: "app.css") else {
                return HTTPResponse(statusCode: .notFound)
            }
            
            return HTTPResponse(
                statusCode: .ok,
                headers: [.contentType: "text/css"],
                body: cssData
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
