//
//  ContentView.swift
//  FrameScreenshot
//
//  Created by Lukasz on 10/01/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Button("Draw frame around screenshot") {
                if let url = showOpenPanel() {
                    _ = ScreenshotFramer().frameScreenshot(file: url)
                }
            }
            Button("Join screenshots vertically") {
                
            }
            .disabled(true)
            
            Button("Join screenshots horizontally") {
                
            }
            .disabled(true)
        }
        .padding()
    }
    
    func showOpenPanel() -> URL? {
        let openpanel = NSOpenPanel()
        openpanel.title                = "Open screenshot(s)"
        openpanel.isExtensionHidden    = false
        openpanel.canChooseDirectories = false
        openpanel.allowsMultipleSelection = true
        openpanel.canChooseFiles       = true
        openpanel.allowedContentTypes  = [.png]
        
        let response = openpanel.runModal()
        return response == .OK ? openpanel.url : nil
    }
}

#Preview {
    ContentView()
}
