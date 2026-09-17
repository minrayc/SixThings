//
//  SixThingsApp.swift
//  SixThings
//
//  Created by 張閔瑞 on 2026/8/20.
//

import SwiftUI

@main
struct SixThingsApp: App {
    
    @StateObject var taskViewModel = TaskViewModel()
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environmentObject(taskViewModel)
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                taskViewModel.checkAndUpdateDate()
            }
        }
    }
}
