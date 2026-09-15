//
//  TaskEditView.swift
//  SixThings
//
//  Created by 張閔瑞 on 2026/9/14.
//
import SwiftUI

struct TaskEditView: View {
    
    @State var isToday: Bool = true
    @State var todayTasks: [Task] = []
    @State var tomorrowTasks: [Task] = []
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: TaskViewModel
    
    var body: some View {
        
        ZStack {
            VStack {
                //廣告
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 50)
                    .border(Color.black)
                //Tips
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(.yellow)
                        Text("提示：")
                            .font(.title)
                            .bold()
                    }
                    Text("✸ 任務可以是一個目標，可以是一個好習慣，例如：運動30分鐘、完成報告的摘要")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("✸ 先後順序很重要，你必須訓練對於任務的輕重緩急認知，才能更好地管理時間")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: 200)
                .border(Color.black)
                //任務頁
                Picker("日期", selection: $isToday) {
                    Text("今天").tag(true)
                    Text("明天").tag(false)
                }
                .pickerStyle(.segmented)
                List {
                    let tasks = isToday ? $todayTasks : $tomorrowTasks
                    ForEach(tasks) { $task in
                        TextField("任務名稱", text: $task.title)
                    }
                    .onMove { from, to in
                        if isToday {
                            todayTasks.move(fromOffsets: from, toOffset: to)
                        } else {
                            tomorrowTasks.move(fromOffsets: from, toOffset: to)
                        }
                    }
                }
            }
            .environment(\.editMode, .constant(.active))
            .onAppear {
                if todayTasks.isEmpty {
                    todayTasks = (1...6).map { Task(title: "", priority: $0, isCompleted: false, date: Date()) }
                }
                if tomorrowTasks.isEmpty {
                    let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
                    tomorrowTasks = (1...6).map { Task(title: "", priority: $0, isCompleted: false, date: tomorrow) }
                }
            }
            // 右下角返回按鈕
            Button {
                viewModel.saveTasks(todayTasks: todayTasks, tomorrowTasks: tomorrowTasks)
                dismiss()
            } label: {
                HStack {
                        Image(systemName: "checkmark")
                        Text("儲存並返回")
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .background(Color.blue)
                    .clipShape(Capsule())
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            .padding()
        }
        .padding(10)
        .navigationBarBackButtonHidden(true)
        
        
    }
    
}

#Preview {
    TaskEditView()
}
