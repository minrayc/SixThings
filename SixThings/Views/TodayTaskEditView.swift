//
//  TodayTaskEditView.swift
//  SixThings
//
//  Created by 張閔瑞 on 2026/10/12.
//
import SwiftUI

struct TodayTaskEditView: View {
    @EnvironmentObject var viewModel: TaskViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var lockedTasks: [Task] = []
    @State private var editableTasks: [Task] = []
    // 唯讀：今天已經滿 6 個，沒有可編輯的空格
    var isReadOnly: Bool {
        editableTasks.isEmpty
    }

    // 可儲存：可編輯區的每一格都填了內容
    var canSave: Bool {
        editableTasks.allSatisfy { !$0.title.isEmpty }
    }
    
    
    var body: some View {
        VStack {
            // 廣告
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 50)
            // TipsView（之後放）

            // List（鎖定區 + 可編輯區）
            VStack(spacing: 0) {
                // 標題
                Text("今日任務")
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
            }
            Button {
                if !isReadOnly {
                    viewModel.saveTodayTasks(newTasks: lockedTasks + editableTasks)
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
            .disabled(!isReadOnly && !canSave)
            .opacity(!isReadOnly && !canSave ? 0.4 : 1.0)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding()
        }
        .onAppear {
            // 1. lockedTasks = 目前今天的任務
            lockedTasks = viewModel.todayTasks
            // 2. editableTasks = 空白任務，補到兩區合計 6 個，日期是今天
            let remaining = 6 - lockedTasks.count
            if remaining > 0 {
                editableTasks = (1...remaining).map { _ in
                    Task(title: "", isCompleted: false, date: Date())
                }
            } else {
                editableTasks = []
            }
            
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    TodayTaskEditView()
        .environmentObject(TaskViewModel())
}
