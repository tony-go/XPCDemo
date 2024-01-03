//
//  DemoAppApp.swift
//  DemoApp
//
//  Created by Tony Gorez on 21/12/2023.
//

import SwiftUI

@main
struct DemoAppApp: App {
    let xpcClient = XPCClient();
    var body: some Scene {
        WindowGroup {
            ContentView(xpcClient: xpcClient)
                .frame(minWidth: 500, maxWidth: 500, minHeight: 300, maxHeight: 300)
                .onReceive(NotificationCenter.default.publisher(
                    for: NSApplication.willTerminateNotification)) { _ in
                    // MARK: this is necessary if you want to avoid zombies
                    // in preview mode
                    xpcClient.close()
                }
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
    }
}
