//
//  RemindersService.swift
//  SixThings
//
//  Created by 張閔瑞 on 2026/10/21.
//
import EventKit

class RemindersService {
    let store = EKEventStore()


    func requestRemindersAccess() async -> Bool {
        do {
            return try await store.requestFullAccessToReminders()
        } catch {
            return false
        }
    }
    
    func isAccessDenied() -> Bool {
        let status = EKEventStore.authorizationStatus(for: .reminder)
        return status == .denied || status == .restricted
    }
}
