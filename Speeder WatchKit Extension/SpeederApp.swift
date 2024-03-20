//
//  SpeederApp.swift
//  Speeder WatchKit Extension
//
//  Created by Chang Gao on 3/20/24.
//

import SwiftUI

@main
struct SpeederApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
