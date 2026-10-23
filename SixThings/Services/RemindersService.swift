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
    
    func fetchReminders(dueOn date: Date) async -> [ReminderItem] {
        let calendar = Calendar.current
        let predicate = store.predicateForIncompleteReminders(
            withDueDateStarting: nil, ending: nil, calendars: nil
        )
        let all = await withCheckedContinuation { continuation in
            store.fetchReminders(matching: predicate) { continuation.resume(returning: $0 ?? []) }
        }
        return all.filter { reminder in
            guard let components = reminder.dueDateComponents,
                  let dueDate = calendar.date(from: components) else {
                return false
            }
            return calendar.isDate(date, inSameDayAs: dueDate)
        }.map { reminder in
            ReminderItem(id: reminder.calendarItemIdentifier, title: reminder.title ?? "")
        }
    }
    
}
