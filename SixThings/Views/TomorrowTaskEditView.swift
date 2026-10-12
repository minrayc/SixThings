//
//  TomorrowTaskEditView.swift
//  SixThings
//
//  Created by 張閔瑞 on 2026/10/12.
//
import SwiftUI

struct TomorrowTaskEditView: View {
    @EnvironmentObject var viewModel: TaskViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var lockedTasks: [Task] = []
    @State private var editableTasks: [Task] = []
    @State private var showTips = false
    @FocusState private var isEditing: Bool
    // 唯讀：今日 6 個都未完成，沒有空位
    private let tips = [
        "今日未完成任務會優先出現在上方，完成它們才會空出位置",
        "先後順序很重要，你必須訓練對於任務的輕重緩急認知，才能更好地管理時間"
    ]
    
    var isReadOnly: Bool {
        editableTasks.isEmpty
    }
    
    
    var body: some View {
        VStack(spacing: 0) {
            // 廣告
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 50)
            ZStack(alignment: .topTrailing) {
                // 最底層：主要內容
                VStack(spacing: 10) {
                    
                    // 燈泡按鈕列
                    HStack {
                        Spacer()
                        Button {
                            withAnimation { showTips.toggle() }
                        } label: {
                            Image(systemName: showTips ? "lightbulb.fill" : "lightbulb")
                                .font(.title3)
                                .foregroundColor(.yellow)
                                .frame(width: 40, height: 40)
                                .background(
                                    Circle()
                                        .fill(showTips ? Color.yellow.opacity(0.15) : Color.clear)
                                )
                                .overlay(
                                    Circle()
                                        .stroke(Color.yellow, lineWidth: 1.5)
                                )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 15)
                    // 標題
                    Text("明日任務")
                        .font(.title)
                    List {
                        // 鎖定區：只顯示，不能改也不能拖
                        ForEach(lockedTasks) { task in
                            Text(task.title)
                                .foregroundColor(.secondary)
                        }
                        .listRowBackground(Color.clear)
                        
                        // 可編輯區：可輸入、可拖曳
                        ForEach($editableTasks) { $task in
                            TextField("任務名稱", text: $task.title)
                                .focused($isEditing)
                                .onChange(of: task.title) {
                                    if task.title.count > 10 {
                                        task.title = String(task.title.prefix(10))
                                    }
                                }
                        }
                        .onMove { from, to in
                            editableTasks.move(fromOffsets: from, toOffset: to)
                        }
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .environment(\.editMode, .constant(.active))
                    .padding(.top, 30)
                    
                    // 儲存按鈕
                    Button {
                        if !isReadOnly {
                            viewModel.saveTomorrowTasks(newTasks: editableTasks)
                        }
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: isReadOnly ? "arrow.left" : "checkmark")
                            Text(isReadOnly ? "返回" : "儲存並返回")
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                        .background(Color.blue)
                        .clipShape(Capsule())
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal)
                }
                if showTips {
                    // 中間層：透明遮罩，點提示卡以外的地方收合
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation { showTips = false }
                        }
                    
                    // 最上層：提示卡
                    TipsCard(tips: tips)
                        .padding(.top, 56)
                        .padding(.horizontal)
                        .onTapGesture {
                            withAnimation { showTips = false }
                        }
                }
            }
            // 下方廣告：輸入時隱藏，避免被鍵盤推上來誤觸
            if !isEditing {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 50)
                    .padding(.top, 8)
            }
            
        }
        .onAppear {
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
            // 1. lockedTasks = 今日未完成任務
            lockedTasks = viewModel.getUnfinishedTasks()
            // 2. editableTasks = 已存的明日任務 + 空白補足
            let savedTomorrowTasks = viewModel.tomorrowTasks
            let remaining = 6 - lockedTasks.count - savedTomorrowTasks.count
            let emptyTasks = remaining > 0 ? (1...remaining).map { _ in
                Task(title: "", isCompleted: false, date: tomorrow)
            } : []
            editableTasks = savedTomorrowTasks + emptyTasks
            
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    TomorrowTaskEditView()
        .environmentObject(TaskViewModel())
}

