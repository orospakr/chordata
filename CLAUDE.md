# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Chordata is a Swift Package Manager library that provides a Core Data live inspector for iOS/macOS apps. It creates an HTTP server on port 8080 that serves a web-based dashboard for inspecting Core Data models in real-time.

## Development Commands

### Building and Testing
```bash
# Type-check and build Swift code (iOS/macOS project)
xcodebuild -scheme ChordataExample -project ChordataExample/ChordataExample.xcodeproj -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.4' build
# Note: Build may fail at code signing step, but Swift compilation will complete successfully

# Run tests (using Swift Testing framework)
swift test

# For standalone package builds (limited - this is primarily an iOS/macOS library):
swift build --arch arm64
```

### Frontend Development
The project includes a modern Svelte frontend built with Vite:
```bash
# Build frontend (required before testing Swift code)
cd frontend && yarn install && yarn build

# Develop frontend (optional - for frontend changes)
cd frontend && yarn dev
```

### Example App
The project includes an example iOS app in `ChordataExample/`:
```bash
# Open in Xcode
open ChordataExample/ChordataExample.xcodeproj
```

## Architecture

### Core Components

- **ChordataManager** (`chordata.swift:258-280`): Public singleton API for initialization
- **ChordataManagerImpl** (`chordata.swift:14-170`): Core implementation that interfaces with Core Data
- **ChordataWebServer** (`chordata.swift:173-255`): HTTP server using FlyingFox that serves the dashboard
- **Data Models** (`models.swift`): Codable structs for API responses (ModelData, AttributeData, etc.)
- **Frontend Resources** (`Sources/chordata/Resources/`): Built Svelte application (index.html, app.js, app.css)

### HTTP API Endpoints

- `GET /` - Serves the main dashboard HTML interface (index.html)
- `GET /app.js` - Serves the compiled Svelte application JavaScript
- `GET /app.css` - Serves the compiled Tailwind CSS styles
- `GET /api/models` - Returns JSON with all Core Data models, attributes, relationships, and object instances

### Data Flow

1. App calls `ChordataManager.shared.initialize(persistentContainer:)` with Core Data container
2. ChordataWebServer starts on port 8080 in background Task
3. Browser loads Svelte dashboard from `/` endpoint
4. Svelte app fetches `/api/models` to get live Core Data inspection data
5. ChordataManagerImpl queries the persistent container to extract entity metadata and object instances

### Key Design Patterns

- Uses async/await throughout for Core Data operations
- Sendable conformance for thread safety
- Limits object instances to 100 per entity for performance
- Formats Core Data types for web display (dates, UUIDs, binary data, etc.)

### Dependencies

#### Swift Dependencies
- **FlyingFox**: HTTP server implementation
- **Core Data**: Apple's object graph and persistence framework
- **Swift Testing**: Modern testing framework (not XCTest)

#### Frontend Dependencies
- **Svelte 5**: Reactive UI framework
- **Vite 6**: Build tool and development server
- **Tailwind CSS 3**: Utility-first CSS framework
- **Yarn**: Package manager