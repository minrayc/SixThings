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
    @StateObject var adsConsentManager = AdsConsentManager()   // 新增
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environmentObject(taskViewModel)
        .environmentObject(adsConsentManager)   // 新增
        .onChange(of: scenePhase) { _, newPhase in
            switch newPhase {
            case .active:
                taskViewModel.checkAndUpdateDate()
                NotificationService.shared.scheduleNotifications(todayTasks: taskViewModel.todayTasks)
            default:
                break
            }
        }
    }
}
