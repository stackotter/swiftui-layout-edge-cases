## SwiftUI layout edge cases

This repository hosts a few SwiftUI layouts that test some edge cases in SwiftUI's layout system. The `scrollView` example is probably the only one that could be objectively classed as a bug. The others could be classed as unsupported usecases or expected behaviour, I'm not sure.

All examples live in a single app. Each example comes with a detailed description of my understanding of the bug, and what we can infer about SwiftUI's layout system from the exhibited behaviour.

This repository is related to [the layout correctness tracking issue on the SwiftCrossUI repository](https://github.com/stackotter/swift-cross-ui/issues/266).

### Running the app

Install [Swift Bundler](https://swiftbundler.dev/documentation/swift-bundler/installation), and then use it to run the app.

```swift
swift bundler run
```

Alternatively, you may be able to run the app via `swift run` in a pinch, but it'll act like a child of your terminal rather than a standalone app, which will cause keyboard shortcuts to stop working and the terminal may occasionally steal focus from the app.
