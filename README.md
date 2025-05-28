# Chordata

Core Data live inspector for iOS, hosted via HTTP.

![Chordata Logo](./chordata-logo.png)

## Usage

Add the library using SwiftPM:

```swift
dependencies: [
    .package(url: "http://github.com/orospakr/chordata", from: "0.0.0"),
]
```

Then, after ensuring that the library is added to your target, initialize it like this, passing it your Core Data persistent container.

```
ChordataManager.shared.initialize(persistentContainer: myPersistentContainer)
```

It will open port 8080 on your device (or your host Mac if you are using the simulator) and serve the dashboard.
