//
//  RadialMenuView.swift
//  SixThings
//
//  Created by 張閔瑞 on 2026/9/12.
//
import SwiftUI

struct RadialMenuView: View {
    
    @Binding var isExpanded: Bool
    @State private var itemsVisible: [Bool] = [false, false, false]
    @Binding var showTaskEdit: Bool
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            
            // 三個膠囊按鈕
            VStack(alignment: .trailing, spacing: 20) {
                // 新增任務
                Button {
                    // action
                    showTaskEdit = true
                    toggleMenu()
                } label: {
                    Label("新增任務", systemImage: "plus.circle.fill")
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color(.systemBackground))
                        .clipShape(Capsule())
                        .shadow(radius: 3)
                }
                .opacity(itemsVisible[0] ? 1 : 0)
                .offset(y: itemsVisible[0] ? 0 : 12)
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
                .opacity(itemsVisible[1] ? 1 : 0)
                .offset(y: itemsVisible[1] ? 0 : 12)
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
        }
        .padding()
        .onChange(of: isExpanded) {
            if !isExpanded {
                for i in 0..<3 {
                    withAnimation(.spring().delay(Double(i) * 0.08)) {
                        itemsVisible[i] = false
                    }
                }
            }
        }
    }
    
    
    func toggleMenu() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        isExpanded.toggle()
        if isExpanded {
            // 展開：設定先出現
            for i in 0..<3 {
                withAnimation(.spring().delay(Double(i) * 0.08)) {
                    itemsVisible[2 - i] = true
                }
            }
        } else {
            // 收合：新增任務先消失
            for i in 0..<3 {
                withAnimation(.spring().delay(Double(i) * 0.08)) {
                    itemsVisible[i] = false
                }
            }
        }
    }
}

//#Preview {
//    @Previewable @State var isExpanded = false
//    return RadialMenuView(isExpanded: $isExpanded)
//}
