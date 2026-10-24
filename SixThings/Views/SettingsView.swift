//
//  SettingsView.swift
//  SixThings
//
//  Created by 張閔瑞 on 2026/10/19.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: TaskViewModel
    @EnvironmentObject var adsConsentManager: AdsConsentManager
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

            Section {
                // 隱私權政策：Apple 規定 App 內也要能看到
                Link("隱私權政策", destination: URL(string: "https://minrayc.github.io/privacy.html")!)

                // 只有需要時（歐盟／英國等地區）才顯示
                if adsConsentManager.isPrivacyOptionsRequired {
                    Button("隱私權選項") {
                        _Concurrency.Task {
                            await adsConsentManager.presentPrivacyOptions()
                        }
                    }
                }

                #if DEBUG
                // 測試用：清除同意紀錄，重開 App 會再跳一次同意視窗（Release 版不會出現）
                Button("重設同意（測試用）") {
                    adsConsentManager.resetConsentForTesting()
                }
                #endif
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
