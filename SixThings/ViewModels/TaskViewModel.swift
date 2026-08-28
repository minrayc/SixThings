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
    @Published var task: [Task] = []
    @Published var date: Date = Date()
    @Published var errorMessage: String? = ""
    
    func completeTask() {
        
    }
    
    func editTask() {
        
    }
    
    func progress() {
        
    }
    
    
    
    
    
}
