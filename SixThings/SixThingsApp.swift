//
//  SixThingsApp.swift
//  SixThings
//
//  Created by 張閔瑞 on 2026/8/20.
//

import SwiftUI
import UserNotifications

@main
struct SixThingsApp: App {
    @StateObject var taskViewModel = TaskViewModel()
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environmentObject(taskViewModel)
        .onChange(of: scenePhase) { _, newPhase in
            switch newPhase {
            case .active:
                taskViewModel.loadTasks()
                taskViewModel.checkAndUpdateDate()
            default:
                break
            }
        }
    }
}
