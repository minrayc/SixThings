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
    // 唯讀：今日 6 個都未完成，沒有空位
    var isReadOnly: Bool {
        editableTasks.isEmpty
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
            .padding()
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

