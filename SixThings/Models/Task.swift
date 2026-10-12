//
//  Task.swift
//  SixThings
//
//  Created by 張閔瑞 on 2026/8/27.
//
import Foundation


struct Task: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String
    var isCompleted: Bool
    var date: Date
}
