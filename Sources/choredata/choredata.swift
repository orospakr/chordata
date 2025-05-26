// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import CoreData

import FlyingFox

/// A singleton class for managing long-running state in the choredata library.
/// This class is attributed to the main actor to ensure thread safety for UI operations.
@MainActor
public final class ChoreDataManager {
    
    /// The shared singleton instance
    public static let shared = ChoreDataManager()
    
    /// Private initializer to prevent external instantiation
    private init() {}
    
    /// Indicates whether the manager has been initialized
    private var isInitialized = false

    private var persistentContainer: NSPersistentContainer?
    
    /// Initialize the ChoreDataManager with any required setup
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
                    <title>ChoreData</title>
                    <style>
                        body {
                            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                            display: flex;
                            justify-content: center;
                            align-items: center;
                            height: 100vh;
                            margin: 0;
                            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                            color: white;
                        }
                        .container {
                            text-align: center;
                            padding: 2rem;
                            border-radius: 10px;
                            background: rgba(255, 255, 255, 0.1);
                            backdrop-filter: blur(10px);
                            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
                        }
                        h1 {
                            font-size: 3rem;
                            margin: 0;
                            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
                        }
                    </style>
                </head>
                <body>
                    <div class="container">
                        <h1>Hello World!</h1>
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


        print("ChoreData initialization complete")
    }
}
