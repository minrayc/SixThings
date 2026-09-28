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
    @Published var todayTasks: [Task] = []
    @Published var tomorrowTasks: [Task] = []
    @Published var savedTomorrowTasks: [Task] = []
    @Published var date: Date = Date()
    @Published var errorMessage: String? = ""
    var currentPriority: Int {
        todayTasks.filter { !$0.isCompleted }.min(by: { $0.priority < $1.priority })?.priority ?? 0
    }
    
    func checkAndUpdateDate() {
        // 檢查 todayTasks 的日期是不是今天
        // 如果不是，代表跨日了
        if let firstTask = todayTasks.first, !Calendar.current.isDateInToday(firstTask.date) {
            todayTasks = tomorrowTasks
            tomorrowTasks = []
            savedTomorrowTasks = []
        }
    }
    
    func completeTask(task: Task) {
        if let index = todayTasks.firstIndex(where: { $0.id == task.id }) {
            if !todayTasks[index].isCompleted {
                todayTasks[index].isCompleted = true
            }
        }
    }
    
    func editTask() {
        
    }
    
    func progress() {
        
    }
    
    func isTodayTaskSet() -> Bool {
        return todayTasks.count == 6
    }

    func getUnfinishedTasks() -> [Task] {
        return todayTasks.filter { !$0.isCompleted }
    }

    func saveTasks(newTodayTasks: [Task], newTomorrowTasks: [Task]) {
        todayTasks = newTodayTasks.filter { !$0.title.isEmpty }
        tomorrowTasks = newTomorrowTasks.filter { !$0.title.isEmpty }
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        savedTomorrowTasks = newTomorrowTasks.filter {
            !$0.title.isEmpty && !$0.isCompleted && Calendar.current.isDate($0.date, inSameDayAs: tomorrow)
        }
    }
    
    func getEncouragement(progress: Int) -> String {
        guard progress > 0 && progress <= 6 else { return "今日事今日畢，讓我們趕緊開始吧！" }
        let random = Int.random(in: 1...3)
        return NSLocalizedString("encouragement_\(progress)_\(random)", comment: "")
    }
    
    
    
}
