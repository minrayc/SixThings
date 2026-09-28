//
//  NotificationService.swift
//  SixThings
//
//  Created by 張閔瑞 on 2026/9/28.
//

import UserNotifications

class NotificationService {
    static let shared = NotificationService()
    
    func scheduleNotifications(todayTasks: [Task]) {
        cancelAllNotifications()
        
        // 早上 9 點 — 今日任務尚未設定
        let morningContent = UNMutableNotificationContent()
        morningContent.title = "今天的六件事還沒設定！"
        morningContent.body = "現在設定好，讓今天更有方向。"
        morningContent.sound = .default
        
        var morningComponents = DateComponents()
        morningComponents.hour = 9
        morningComponents.minute = 0
        
        let morningTrigger = UNCalendarNotificationTrigger(dateMatching: morningComponents, repeats: true)
        let morningRequest = UNNotificationRequest(identifier: "morning", content: morningContent, trigger: morningTrigger)
        
        UNUserNotificationCenter.current().add(morningRequest)
        
        // 下午 1 點 — 完成度未達 60%
        let afternoonContent = UNMutableNotificationContent()
        afternoonContent.title = "午後提醒"
        afternoonContent.body = "今天的任務完成了幾個？繼續加油！"
        afternoonContent.sound = .default
        
        var afternoonComponents = DateComponents()
        afternoonComponents.hour = 13
        afternoonComponents.minute = 0
        
        let afternoonTrigger = UNCalendarNotificationTrigger(dateMatching: afternoonComponents, repeats: true)
        let afternoonRequest = UNNotificationRequest(identifier: "afternoon", content: afternoonContent, trigger: afternoonTrigger)
        UNUserNotificationCenter.current().add(afternoonRequest)
        
        // 下午 5 點 — 完成度未達 80%
        let eveningContent = UNMutableNotificationContent()
        eveningContent.title = "下午提醒"
        eveningContent.body = "還有任務沒完成，把握最後時間！"
        eveningContent.sound = .default
        
        var eveningComponents = DateComponents()
        eveningComponents.hour = 17
        eveningComponents.minute = 0
        
        let eveningTrigger = UNCalendarNotificationTrigger(dateMatching: eveningComponents, repeats: true)
        let eveningRequest = UNNotificationRequest(identifier: "evening", content: eveningContent, trigger: eveningTrigger)
        UNUserNotificationCenter.current().add(eveningRequest)
        
        // 晚上 9 點 — 提醒設定明日任務
        let nightContent = UNMutableNotificationContent()
        nightContent.title = "準備迎接明天了嗎？"
        nightContent.body = "花 5 分鐘設定明日六件事，讓明天更順利。"
        nightContent.sound = .default
        
        var nightComponents = DateComponents()
        nightComponents.hour = 21
        nightComponents.minute = 0
        
        let nightTrigger = UNCalendarNotificationTrigger(dateMatching: nightComponents, repeats: true)
        let nightRequest = UNNotificationRequest(identifier: "night", content: nightContent, trigger: nightTrigger)
        UNUserNotificationCenter.current().add(nightRequest)
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
