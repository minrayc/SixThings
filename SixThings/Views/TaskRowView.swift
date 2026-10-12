//
//  TaskRowView.swift
//  SixThings
//
//  Created by 張閔瑞 on 2026/9/9.
//
import SwiftUI

struct TaskRowView: View {
    
    @EnvironmentObject var viewModel: TaskViewModel
    @State private var showAlert = false
    let task: Task
    let number: Int
    let isCurrent: Bool
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 14) {
            // 優先順序數字
            Text("\(number)")
                .font(isCurrent ? .title3 : .body)
                .fontWeight(isCurrent ? .black : .regular)
                .foregroundColor(task.isCompleted ? .green.opacity(0.5) : (isCurrent ? .primary : .gray.opacity(0.5)))
                .frame(minWidth: 28)
            
            // 任務名稱 + 波浪刪除線
            ZStack(alignment: .leading) {
                Text(task.title)
                    .font(isCurrent ? .title3 : .body)
                    .fontWeight(isCurrent ? .bold : .regular)
                    .foregroundColor(task.isCompleted ? .green.opacity(0.5) : (isCurrent ? .primary : .gray.opacity(0.5)))
                
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
            if isCurrent {
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
    VStack {
        TaskRowView(task: Task(title: "已完成任務", isCompleted: true, date: Date()), number: 1, isCurrent: false)
        TaskRowView(task: Task(title: "當前任務", isCompleted: false, date: Date()), number: 2, isCurrent: true)
        TaskRowView(task: Task(title: "下一個任務", isCompleted: false, date: Date()), number: 3, isCurrent: false)
    }
    .environmentObject(TaskViewModel())
}
