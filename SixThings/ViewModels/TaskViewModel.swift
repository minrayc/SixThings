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
    @Published var errorMessage: String? = ""
    
    var todayTasks: [Task] {
        tasks.filter { Calendar.current.isDateInToday($0.date) }
    }
    
    var tomorrowTasks: [Task] {
        tasks.filter { Calendar.current.isDateInTomorrow($0.date) }
    }
    
    var currentTaskID: UUID? {
        todayTasks.first(where: { !$0.isCompleted })?.id
    }
    init() {
        loadTasks()
        checkAndUpdateDate()
    }
    
    func loadTasks() {
        if let data = UserDefaults.standard.data(forKey: "tasks"),
           let decoded = try? JSONDecoder().decode([Task].self, from: data) {
            tasks = decoded
        }
    }

    func persistTasks() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: "tasks")
        }
    }
    
    
    func checkAndUpdateDate() {
        let today = Calendar.current.startOfDay(for: Date())
        tasks.removeAll { $0.date < today && $0.isCompleted }
        tasks = tasks.map { task in
            if task.date < today && !task.isCompleted {
                var updated = task      // 1. 複製一份（task 是 let，不能直接改）
                updated.date = today    // 2. 改日期
                return updated          // 3. 回傳修改後的版本
            }
            return task                 // 不符合條件的原封不動回傳
        }
        persistTasks()
    }
    
    func completeTask(task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            if !tasks[index].isCompleted {
                tasks[index].isCompleted = true
            }
        }
        persistTasks()
    }
    
    
    func isTodayTaskSet() -> Bool {
        return todayTasks.count == 6
    }

    func getUnfinishedTasks() -> [Task] {
        return todayTasks.filter { !$0.isCompleted }
    }

    func saveTodayTasks(newTasks: [Task]) {
        tasks.removeAll { Calendar.current.isDateInToday($0.date) }
        tasks.append(contentsOf: newTasks.filter { !$0.title.isEmpty })
        persistTasks()
    }
    
    func saveTomorrowTasks(newTasks: [Task]) {
        tasks.removeAll { Calendar.current.isDateInTomorrow($0.date) }
        tasks.append(contentsOf: newTasks.filter { !$0.title.isEmpty && Calendar.current.isDateInTomorrow($0.date) })
        persistTasks()
    }
    
    func getEncouragement(progress: Int) -> String {
        guard progress > 0 && progress <= 6 else { return "今日事今日畢，讓我們趕緊開始吧！" }
        let random = Int.random(in: 1...3)
        return NSLocalizedString("encouragement_\(progress)_\(random)", comment: "")
    }
    
    
    
}
