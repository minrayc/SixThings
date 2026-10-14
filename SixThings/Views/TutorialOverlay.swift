//
//  TutorialOverlay.swift
//  SixThings
//
//  Created by 張閔瑞 on 2026/10/15.
//
import SwiftUI

struct TutorialOverlay: View {
    let anchors: [TutorialTarget: Anchor<CGRect>]
    @Binding var isPresented: Bool

    @State private var step = 1   // 目前顯示到第幾組（1~3）

    private let dash = StrokeStyle(lineWidth: 3, dash: [8, 6])

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // 暗色遮罩
                Color.black.opacity(0.6)
                    .ignoresSafeArea()

                // 1. 進度圈
                if step >= 1, let anchor = anchors[.progress] {
                    let rect = geo[anchor]
                    let size = min(rect.width, rect.height) + 12

                    Circle()
                        .stroke(style: dash)
                        .foregroundColor(.white)
                        .frame(width: size, height: size)
                        .position(x: rect.midX, y: rect.midY)

                    Text("每完成一件\n圓圈前進一格")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .frame(width: 100, alignment: .leading)
                        .position(x: rect.midX + size / 2 + 60, y: rect.midY)
                }

                // 2. 任務列表
                if step >= 2, let anchor = anchors[.tasks] {
                    let rect = geo[anchor]

                    RoundedRectangle(cornerRadius: 12)
                        .stroke(style: dash)
                        .foregroundColor(.white)
                        .frame(width: rect.width + 12, height: rect.height + 12)
                        .position(x: rect.midX, y: rect.midY)

                    Text("由上往下完成，粗體是現在要做的任務，點它就能完成")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .frame(width: rect.width - 20, alignment: .leading)
                        .position(x: rect.midX, y: rect.minY - 30)
                }

                // 3. + 號
                if step >= 3, let anchor = anchors[.menu] {
                    let rect = geo[anchor]
                    let size = max(rect.width, rect.height) + 16

                    Circle()
                        .stroke(style: dash)
                        .foregroundColor(.white)
                        .frame(width: size, height: size)
                        .position(x: rect.midX, y: rect.midY)

                    Text("從這裡設定今日與明日的六件事")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 150, alignment: .trailing)
                        .position(x: rect.minX - 90, y: rect.midY)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                if step < 3 {
                    withAnimation(.easeOut(duration: 0.3)) { step += 1 }
                } else {
                    withAnimation { isPresented = false }
                }
            }
        }
        .transition(.opacity)
    }
}
