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
    @State private var showTomorrowOverlay = true
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: TaskViewModel
    var isTodayReadOnly: Bool {
        viewModel.isTodayTaskSet()
    }
    
    var body: some View {
        
        ZStack {
            VStack {
                //廣告
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 50)
                //Tips
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(.yellow)
                        Text("提示：")
                            .font(.custom("JasonHandwriting4-Regular", size: 28))
                            .bold()
                    }
                    Text("✸ 任務可以是一個目標，可以是一個好習慣，例如：運動30分鐘、完成報告的摘要")
                        .font(.custom("JasonHandwriting4-Regular", size: 17))
                        .tracking(3)
                        .foregroundColor(.secondary)
                    Text("✸ 先後順序很重要，你必須訓練對於任務的輕重緩急認知，才能更好地管理時間")
                        .font(.custom("JasonHandwriting4-Regular", size: 17))
                        .tracking(3)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: 200)
                //任務頁
                HStack(spacing: 48) {
                    ZStack {
                        if isToday {
                            HandwrittenCircle()
                                .frame(width: 80, height: 44)
                        }
                        Text("今天")
                            .font(.custom("JasonHandwriting4-Regular", size: 17))
                            .fontWeight(isToday ? .bold : .regular)
                            .foregroundColor(isToday ? .primary : .secondary)
                    }
                    .onTapGesture { isToday = true }
                    
                    ZStack {
                        if !isToday {
                            HandwrittenCircle()
                                .frame(width: 80, height: 44)
                        }
                        Text("明天")
                            .font(.custom("JasonHandwriting4-Regular", size: 17))
                            .fontWeight(!isToday ? .bold : .regular)
                            .foregroundColor(!isToday ? .primary : .secondary)
                    }
                    .onTapGesture {
                        isToday = false
                        showTomorrowOverlay = true }
                }
                .padding(.vertical, 8)
                VStack {
                    List {
                        let tasks = isToday ? $todayTasks : $tomorrowTasks
                        ForEach(tasks) { $task in
                            HStack {
                                if isToday && isTodayReadOnly {
                                    Text(task.title)
                                        .font(.custom("JasonHandwriting4-Regular", size: 16))
                                } else {
                                    TextField("任務名稱", text: $task.title)
                                        .font(.custom("JasonHandwriting4-Regular", size: 16))
                                        .onChange(of: task.title) {
                                                if task.title.count > 10 {
                                                    task.title = String(task.title.prefix(10))
                                                }
                                            }
                                }
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparatorTint(.gray.opacity(0.4))
                        }
                        .onMove { from, to in
                            if isToday {
                                todayTasks.move(fromOffsets: from, toOffset: to)
                            } else {
                                tomorrowTasks.move(fromOffsets: from, toOffset: to)
                            }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .overlay(alignment: .center) {
                        if !isToday && showTomorrowOverlay && !viewModel.getUnfinishedTasks().isEmpty {
                            Color.black.opacity(0.6)
                                .overlay {
                                    VStack(spacing: 16) {
                                        Text("今日未完成任務會優先出現在上方，先去完成一些任務吧！")
                                            .font(.custom("JasonHandwriting4-Regular", size: 16))
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 32)
                                        Button("我知道了") {
                                            showTomorrowOverlay = false
                                        }
                                        .font(.custom("JasonHandwriting4-Regular", size: 16))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 10)
                                        .background(Color.blue)
                                        .clipShape(Capsule())
                                    }
                                }
                        }
                    }
                }
                .border(Color.black)
                
            }
            .environment(\.editMode, .constant(isToday && isTodayReadOnly ? .inactive : .active))
            .onAppear {
                // 今日
                if viewModel.isTodayTaskSet() {
                    todayTasks = viewModel.todayTasks
                } else {
                    todayTasks = (1...6).map {
                        Task(title: "", priority: $0, isCompleted: false, date: Date())
                    }
                }
                
                // 明日：未完成任務 + 已儲存的明日任務 + 空白補足
                let unfinished = viewModel.getUnfinishedTasks()
                let saved = viewModel.savedTomorrowTasks.filter { task in
                    !unfinished.contains { $0.id == task.id }
                }
                let combined = Array((unfinished + saved).prefix(6)) // 最多只取 6 個
                let remaining = 6 - combined.count
                let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
                let emptyTasks = remaining > 0 ? (1...remaining).map {
                    Task(title: "", priority: combined.count + $0, isCompleted: false, date: tomorrow)
                } : []
                tomorrowTasks = combined + emptyTasks
            }
            
            // 右下角返回按鈕
            Button {
                viewModel.saveTasks(newTodayTasks: todayTasks, newTomorrowTasks: tomorrowTasks)
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
            .disabled(isToday && !isTodayReadOnly && todayTasks.filter { !$0.title.isEmpty }.count < 6)
            .opacity(isToday && !isTodayReadOnly && todayTasks.filter { !$0.title.isEmpty }.count < 6 ? 0.4 : 1.0)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            .padding()
        }
        .padding(.horizontal, 10)
        .navigationBarBackButtonHidden(true)
        
        
    }
    
}

#Preview {
    let vm = TaskViewModel()
    vm.todayTasks = [
        Task(title: "未完成任務", priority: 1, isCompleted: false, date: Date())
    ]
    return TaskEditView(isToday: false)
        .environmentObject(vm)
}
