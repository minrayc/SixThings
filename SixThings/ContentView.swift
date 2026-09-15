//
//  ContentView.swift
//  SixThings
//
//  Created by 張閔瑞 on 2026/8/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            MainView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(TaskViewModel())
}
