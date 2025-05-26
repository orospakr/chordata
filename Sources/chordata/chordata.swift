// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import CoreData

import FlyingFox

/// A singleton class for managing long-running state in the chordata library.
/// This class is attributed to the main actor to ensure thread safety for UI operations.
@MainActor
public final class ChordataManager {
    
    /// The shared singleton instance
    public static let shared = ChordataManager()
    
    /// Private initializer to prevent external instantiation
    private init() {}
    
    /// Indicates whether the manager has been initialized
    private var isInitialized = false

    private var persistentContainer: NSPersistentContainer?
    
    /// Initialize the ChordataManager with any required setup
    /// - Parameter configuration: Optional configuration parameters
    public func initialize(persistentContainer: NSPersistentContainer) {
        
        isInitialized = true

        let server = HTTPServer(port: 8080)

        Task {
            await server.appendRoute("/") { request in
                let htmlContent = """
                <!DOCTYPE html>
                <html lang="en">
                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Chordata</title>
                    <script src="https://cdn.tailwindcss.com"></script>
                </head>
                <body class="font-sans flex justify-center items-center h-screen m-0 bg-gradient-to-br from-indigo-500 to-purple-600 text-white">
                    <div class="text-center p-8 rounded-lg bg-white bg-opacity-10 backdrop-blur-md shadow-2xl">
                        <h1 class="text-5xl m-0 drop-shadow-lg">Hello World!</h1>
                    </div>
                </body>
                </html>
                """
                
                return HTTPResponse(
                    statusCode: .ok,
                    headers: [.contentType: "text/html; charset=utf-8"],
                    body: htmlContent.data(using: .utf8) ?? Data()
                )
            }
            try await server.run()
        }


        print("Chordata initialization complete")
    }
}
