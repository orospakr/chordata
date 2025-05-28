# Chordata

<div align="center">

<img src="./chordata-logo.png" alt="Chordata Logo" width="400px">

**A powerful Core Data live inspector for iOS, hosted via HTTP**

[![Swift](https://img.shields.io/badge/Swift-6.1+-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS%2017%2B%20%7C%20macOS%2014%2B-blue.svg)](https://developer.apple.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Swift Package Manager](https://img.shields.io/badge/SPM-Compatible-brightgreen.svg)](https://swift.org/package-manager)

*Debug and inspect your Core Data models in real-time with a beautiful web interface*

</div>

---

## Features

- 🔍 **Live Core Data Inspection** - View your data models in real-time
- 🌐 **Web-based Dashboard** - Access via any browser on port 8080
- 📱 **iOS & Simulator Support** - Works on device and simulator
- 🚀 **Easy Integration** - Just one line of code to get started
- 🎨 **Beautiful Interface** - Clean, modern web UI for data exploration

## 🚀 Quick Start

### Installation

Add Chordata to your project using Swift Package Manager:

#### Via Xcode
1. Go to **File** → **Add Package Dependencies**
2. Enter the repository URL: `https://github.com/orospakr/chordata`
3. Select **Up to Next Major Version** starting from `0.0.0`

#### Via Package.swift
```swift
dependencies: [
    .package(url: "https://github.com/orospakr/chordata", from: "0.0.0"),
]
```

### Usage

Initialize Chordata in your app by passing your Core Data persistent container:

```swift
import chordata

// In your app initialization (e.g., AppDelegate or App struct)
ChordataManager.shared.initialize(persistentContainer: myPersistentContainer)
```

That's it! 🎉 Chordata will automatically start serving the dashboard on port 8080.

### Accessing the Dashboard

- **iOS Simulator**: Open `http://localhost:8080` in your browser
- **Physical Device**: Open `http://[device-ip]:8080` in your browser

## 📋 Requirements

- iOS 17.0+ / macOS 14.0+
- Swift 6.1+
- Xcode 15.0+

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [FlyingFox](https://github.com/swhitty/FlyingFox) HTTP server in Swift
- [Tailwind CSS](https://tailwindcss.com/) for styling
- [Alpine.js](https://alpinejs.dev/) for interactivity
