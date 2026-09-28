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
    
    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            print("通知權限：\(granted)")
        }
        for family in UIFont.familyNames {
            for font in UIFont.fontNames(forFamilyName: family) {
                print(font)
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environmentObject(taskViewModel)
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                taskViewModel.checkAndUpdateDate()
                NotificationService.shared.scheduleNotifications(todayTasks: taskViewModel.todayTasks)
            }
        }
    }
}
