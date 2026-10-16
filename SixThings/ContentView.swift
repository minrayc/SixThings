//
//  ContentView.swift
//  SixThings
//
//  Created by 張閔瑞 on 2026/8/20.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("appLanguage") var appLanguage = ""
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding = false

    var body: some View {
        Group {
            if appLanguage.isEmpty {
                LanguageSelectionView()
            } else if !hasSeenOnboarding {
                OnboardingView()
            } else {
                NavigationStack {
                    MainView()
                }
            }
        }
        .environment(\.locale, Locale(identifier: appLanguage.isEmpty ? "en" : appLanguage))
    }
}

#Preview {
    ContentView()
        .environmentObject(TaskViewModel())
}
