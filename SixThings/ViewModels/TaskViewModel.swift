//
//  TaskViewModel.swift
//  SixThings
//
//  Created by 張閔瑞 on 2026/8/28.
//
import Foundation
import Combine

@MainActor
class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var date: Date = Date()
    @Published var errorMessage: String? = ""
    
    func completeTask(task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
    }
    
    func editTask() {
        
    }
    
    func progress() {
        
    }
    
    func isTodayTaskSet() -> Bool {
        let todayTasks = tasks.filter { Calendar.current.isDateInToday($0.date) }
        return todayTasks.count == 6
    }

    func getUnfinishedTasks() -> [Task] {
        return tasks.filter { Calendar.current.isDateInToday($0.date) && !$0.isCompleted }
    }

    func saveTasks(todayTasks: [Task], tomorrowTasks: [Task]) {
        // 只加入有填寫內容的新任務
        let newTodayTasks = todayTasks.filter { !$0.title.isEmpty }
        let newTomorrowTasks = tomorrowTasks.filter { !$0.title.isEmpty }
        tasks.append(contentsOf: newTodayTasks)
        tasks.append(contentsOf: newTomorrowTasks)
    }
    
    
    
    
}
