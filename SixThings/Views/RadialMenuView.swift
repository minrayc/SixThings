//
//  RadialMenuView.swift
//  SixThings
//
//  Created by 張閔瑞 on 2026/9/12.
//
import SwiftUI

struct RadialMenuView: View {
    
    @Binding var isExpanded: Bool
    @Binding var showTodayEdit: Bool
    @Binding var showTomorrowEdit: Bool
    let isTodayTaskSet: Bool
    @Binding var showSettings: Bool
    
    // 三個膠囊按鈕的顯示狀態：0 今日任務、1 明日任務、2 設定
    @State private var itemsVisible: [Bool] = [false, false, false]
    @State private var showTodayNotSetAlert = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            
            // 三個膠囊按鈕
            VStack(alignment: .trailing, spacing: 20) {
                // 今日任務
                Button {
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
                
                // 明日任務：今天已設定 → 進明日頁；未設定 → 跳彈窗
                Button {
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
                
                // 設定
                Button {
                    showSettings = true
                    toggleMenu()
                } label: {
                    Label("設定", systemImage: "gearshape.fill")
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color(.systemBackground))
                        .clipShape(Capsule())
                        .shadow(radius: 3)
                }
                .opacity(itemsVisible[2] ? 1 : 0)
                .offset(y: itemsVisible[2] ? 0 : 12)
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
            .tutorialTarget(.menu)
        }
        .padding()
        // 收合統一在這裡處理：不管是按主按鈕，還是外部把 isExpanded 設成 false，都會執行
        .onChange(of: isExpanded) {
            if !isExpanded {
                for i in itemsVisible.indices {
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
        // 展開：由下往上依序出現（設定先出現）
        if isExpanded {
            let lastIndex = itemsVisible.count - 1
            for i in itemsVisible.indices {
                withAnimation(.spring().delay(Double(i) * 0.08)) {
                    itemsVisible[lastIndex - i] = true
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var isExpanded = false
    @Previewable @State var showToday = false
    @Previewable @State var showTomorrow = false
    @Previewable @State var showSettings = false
    RadialMenuView(isExpanded: $isExpanded, showTodayEdit: $showToday, showTomorrowEdit: $showTomorrow, isTodayTaskSet: false, showSettings: $showSettings)
}
