//
//  TutorialAnchor.swift
//  SixThings
//
//  Created by 張閔瑞 on 2026/10/14.
//
import SwiftUI

// 1. 教學要框住的三個目標
enum TutorialTarget {
    case progress   // 進度圈
    case tasks      // 任務列表
    case menu       // 右下角 + 號
}

// 2. 用來「往上回報位置」的通道
struct TutorialAnchorKey: PreferenceKey {
    static var defaultValue: [TutorialTarget: Anchor<CGRect>] = [:]
    
    static func reduce(value: inout [TutorialTarget: Anchor<CGRect>],
                       nextValue: () -> [TutorialTarget: Anchor<CGRect>]) {
        value.merge(nextValue()) { $1 }
    }
}

// 3. 方便使用的修飾符
extension View {
    func tutorialTarget(_ target: TutorialTarget) -> some View {
        anchorPreference(key: TutorialAnchorKey.self, value: .bounds) { [target: $0] }
    }
}
