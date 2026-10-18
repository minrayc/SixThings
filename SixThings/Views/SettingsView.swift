//
//  SettingsView.swift
//  SixThings
//
//  Created by 張閔瑞 on 2026/10/19.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: TaskViewModel
    @AppStorage("appLanguage") var appLanguage = ""
    @AppStorage("notificationsEnabled") var notificationsEnabled = true

    // 從 App 設定檔讀取版本號
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }

    var body: some View {
        Form {
            Section(localized("一般")) {
                Picker(localized("語言"), selection: $appLanguage) {
                    Text("中文").tag("zh-Hant")
                    Text("English").tag("en")
                }
                .onChange(of: appLanguage) {
                    NotificationService.shared.scheduleNotifications(todayTasks: viewModel.todayTasks)
                }
            }

            Section(localized("通知")) {
                Toggle(localized("每日提醒"), isOn: $notificationsEnabled)
                    .onChange(of: notificationsEnabled) {
                        if notificationsEnabled {
                            NotificationService.shared.scheduleNotifications(todayTasks: viewModel.todayTasks)
                        } else {
                            NotificationService.shared.cancelAllNotifications()
                        }
                    }
            }

            Section(localized("關於")) {
                HStack {
                    Text(localized("版本"))
                    Spacer()
                    Text(verbatim: appVersion)
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("設定")
    }
}

#Preview {
    NavigationStack {
        SettingsView()
            .environmentObject(TaskViewModel())
    }
}
