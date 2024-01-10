//
//  FrameScreenshotApp.swift
//  FrameScreenshot
//
//  Created by Lukasz on 10/01/2024.
//

import SwiftUI

@main
struct FrameScreenshotApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(width: 300, height: 200)
        }
        .windowResizabilityContentSize()
    }
}

extension Scene {
    func windowResizabilityContentSize() -> some Scene {
        if #available(macOS 13.0, *) {
            return windowResizability(.contentSize)
        } else {
            return self
        }
    }
}
