//
//  RadialMenuView.swift
//  SixThings
//
//  Created by 張閔瑞 on 2026/9/12.
//
import SwiftUI

struct RadialMenuView: View {
    
    @Binding var isExpanded: Bool
    @State private var itemsVisible: [Bool] = [false, false, false, false]
    @Binding var showTodayEdit: Bool
    @Binding var showTomorrowEdit: Bool
    let isTodayTaskSet: Bool
    @State private var showTodayNotSetAlert = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            
            // 四個膠囊按鈕
            VStack(alignment: .trailing, spacing: 20) {
                // 今日任務
                Button {
                    // action
                    showTodayEdit = true
                    toggleMenu()
                } label: {
                    Label("今日任務", systemImage: "calendar")
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color(.systemBackground))
                        .clipShape(Capsule())
                        .shadow(radius: 3)
                }
                .opacity(itemsVisible[0] ? 1 : 0)
                .offset(y: itemsVisible[0] ? 0 : 12)
                // 明日任務
                Button {
                    // 今天已設定 → 進明日頁
                    // 今天未設定 → 跳彈窗
                    if isTodayTaskSet {
                        showTomorrowEdit = true
                    } else {
                        showTodayNotSetAlert = true
                    }
                    toggleMenu()
                } label: {
                    Label("明日任務", systemImage: "calendar.badge.plus")
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color(.systemBackground))
                        .clipShape(Capsule())
                        .shadow(radius: 3)
                }
                .opacity(itemsVisible[1] ? 1 : 0)
                .offset(y: itemsVisible[1] ? 0 : 12)
                // 年度目標
                Button {
                    // action
                    toggleMenu()
                } label: {
                    Label("年度目標", systemImage: "target")
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color(.systemBackground))
                        .clipShape(Capsule())
                        .shadow(radius: 3)
                }
                .opacity(itemsVisible[2] ? 1 : 0)
                .offset(y: itemsVisible[2] ? 0 : 12)
                // 設定
                Button {
                    // action
                    toggleMenu()
                } label: {
                    Label("設定", systemImage: "gearshape.fill")
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color(.systemBackground))
                        .clipShape(Capsule())
                        .shadow(radius: 3)
                }
                .opacity(itemsVisible[3] ? 1 : 0)
                .offset(y: itemsVisible[3] ? 0 : 12)
            }
            .padding(.bottom, 72) // 在主按鈕上方
            
            // 主按鈕
            Button {
                toggleMenu()
            } label: {
                Image(systemName: isExpanded ? "xmark" : "plus")
                    .font(Font.system(size: 30, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .background(Color.blue)
                    .clipShape(Circle())
            }
        }
        .padding()
        .onChange(of: isExpanded) {
            if !isExpanded {
                for i in 0..<4 {
                    withAnimation(.spring().delay(Double(i) * 0.08)) {
                        itemsVisible[i] = false
                    }
                }
            }
        }
        .alert("今日任務尚未設定完成", isPresented: $showTodayNotSetAlert) {
            Button("取消", role: .cancel) { }
            Button("設定今日任務") {
                showTodayEdit = true
            }
        }
    }
    
    
    func toggleMenu() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        isExpanded.toggle()
        if isExpanded {
            // 展開：設定先出現
            for i in 0..<4{
                withAnimation(.spring().delay(Double(i) * 0.08)) {
                    itemsVisible[3 - i] = true
                }
            }
        } else {
            // 收合：新增任務先消失
            for i in 0..<4 {
                withAnimation(.spring().delay(Double(i) * 0.08)) {
                    itemsVisible[i] = false
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var isExpanded = false
    @Previewable @State var showToday = false
    @Previewable @State var showTomorrow = false
    RadialMenuView(isExpanded: $isExpanded, showTodayEdit: $showToday, showTomorrowEdit: $showTomorrow, isTodayTaskSet: false)
}
