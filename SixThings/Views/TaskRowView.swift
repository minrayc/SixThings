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
    
    var body: some View {
        HStack {
            // 左側 checkbox
            Circle()
                .fill(task.isCompleted ? Color.green.opacity(0.2) : Color.clear)
                .frame(width: 24, height: 24)
                .overlay(
                    Circle().stroke(Color.gray, lineWidth: 1.5)
                )
                .overlay(
                    task.isCompleted ? Image(systemName: "checkmark")
                        .foregroundColor(.green)
                        .font(.caption) : nil
                )
            
            // 中間任務名稱
            Text(task.title)
                .foregroundColor(task.isCompleted ? .gray : .primary)
                .strikethrough(task.isCompleted)
            
            Spacer()
            
            // 右側優先順序
            Text("\(task.priority)")
                    .foregroundColor(.gray)
                    .font(.caption)
        }
        .onTapGesture {
            // 點擊完成任務
            viewModel.completeTask(task: task)
        }
    }
}

#Preview {
    TaskRowView(task: .constant(Task(title: "測試任務", priority: 1, isCompleted: false, date: Date())))
        .environmentObject(TaskViewModel())
}
