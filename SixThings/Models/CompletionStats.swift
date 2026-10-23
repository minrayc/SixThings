//
//  CompletionStats.swift
//  SixThings
//
//  Created by 張閔瑞 on 2026/10/19.
//
import Foundation

struct CompletionStats: Codable {
    var startDate: Date          // 第一天使用 App，所有結算日都從這天推算
    var lastSettledDate: Date    // 最後結算到哪一天，避免重複計算
    var currentMonthSum: Double  // 這個月目前累積的每日完成度總和（還沒結算）
    var lastMonthSum: Double?    // 上個月結算時的總和（畫面顯示用），nil = 還沒滿一個月
    var yearSum: Double          // 今年「已結算月份」的總和
}
