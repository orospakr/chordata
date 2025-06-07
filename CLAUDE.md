# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Chordata is a Swift Package Manager library that provides a Core Data live inspector for iOS/macOS apps. It creates an HTTP server on port 8080 that serves a web-based dashboard for inspecting Core Data models in real-time.

## Development Commands

### Building and Testing
```bash
# Build the package
swift build

# Run tests (using Swift Testing framework)
swift test

# Build for specific platform
swift build --arch arm64
```

### Example App
The project includes an example iOS app in `ChordataExample/`:
```bash
# Open in Xcode
open ChordataExample/ChordataExample.xcodeproj
```

## Architecture

### Core Components

- **ChordataManager** (`chordata.swift:213-235`): Public singleton API for initialization
- **ChordataManagerImpl** (`chordata.swift:14-155`): Core implementation that interfaces with Core Data
- **ChordataWebServer** (`chordata.swift:158-210`): HTTP server using FlyingFox that serves the dashboard
- **Data Models** (`models.swift`): Codable structs for API responses (ModelData, AttributeData, etc.)
- **HTMLTemplate** (`HTMLTemplate.swift`): Contains the embedded web dashboard HTML

### HTTP API Endpoints

- `GET /` - Serves the main dashboard HTML interface
- `GET /api/models` - Returns JSON with all Core Data models, attributes, relationships, and object instances

### Data Flow

1. App calls `ChordataManager.shared.initialize(persistentContainer:)` with Core Data container
2. ChordataWebServer starts on port 8080 in background Task
3. Web dashboard fetches `/api/models` to get live Core Data inspection data
4. ChordataManagerImpl queries the persistent container to extract entity metadata and object instances

### Key Design Patterns

- Uses async/await throughout for Core Data operations
- Sendable conformance for thread safety
- Limits object instances to 100 per entity for performance
- Formats Core Data types for web display (dates, UUIDs, binary data, etc.)

### Dependencies

- **FlyingFox**: HTTP server implementation
- **Core Data**: Apple's object graph and persistence framework
- **Swift Testing**: Modern testing framework (not XCTest)