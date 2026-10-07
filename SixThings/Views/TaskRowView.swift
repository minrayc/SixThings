//
//  TaskRowView.swift
//  SixThings
//
//  Created by 張閔瑞 on 2026/9/9.
//
import SwiftUI

struct TaskRowView: View {
    
    @Binding var task: Task
    @EnvironmentObject var viewModel: TaskViewModel
    @State private var showAlert = false
    
    var body: some View {
        
        let currentPriority = viewModel.currentPriority
        
        HStack(alignment: .center, spacing: 14) {
            // 優先順序數字
            Text("\(task.priority)")
                .font(.custom("JasonHandwriting4-Regular", size: task.priority == currentPriority ? 32 : 22))
                .fontWeight(task.priority == currentPriority ? .black : .regular)
                .foregroundColor(task.isCompleted ? .green.opacity(0.5) : (task.priority == currentPriority ? .primary : .gray.opacity(0.5)))
                .frame(minWidth: 28)
            
            // 任務名稱 + 波浪刪除線
            ZStack(alignment: .leading) {
                Text(task.title)
                    .font(.custom("JasonHandwriting4-Regular", size: task.priority == currentPriority ? 32 : 22))
                    .fontWeight(task.priority == currentPriority ? .bold : .regular)
                    .foregroundColor(task.isCompleted ? .green.opacity(0.5) : (task.priority == currentPriority ? .primary : .gray.opacity(0.5)))
                
                if task.isCompleted {
                    WavyStrikethrough()
                }
            }
            
            Spacer()
            
            if task.isCompleted {
                Text("✓")
                    .foregroundColor(.green)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 8)
        .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray.opacity(0.4)),
                alignment: .bottom
            )
        .contentShape(Rectangle())
        .onTapGesture {
            if task.priority == currentPriority {
                showAlert = true
            }
        }
        .alert("此任務已完成？", isPresented: $showAlert) {
            Button("還沒", role: .cancel) { }
            Button("已完成") {
                viewModel.completeTask(task: task)
            }
        }
    }
        
}

#Preview {
    let vm = TaskViewModel()
    vm.todayTasks = [
        Task(title: "測試任務一", priority: 1, isCompleted: true, date: Date()),
        Task(title: "測試任務二", priority: 2, isCompleted: false, date: Date())
    ]
    return VStack {
        TaskRowView(task: .constant(vm.todayTasks[0]))
        TaskRowView(task: .constant(vm.todayTasks[1]))
    }
    .environmentObject(vm)
}
