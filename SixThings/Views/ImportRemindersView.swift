//
//  ImportRemindersView.swift
//  SixThings
//
//  Created by 張閔瑞 on 2026/10/23.
//
import SwiftUI

struct ImportRemindersView: View {
    let reminders: [ReminderItem]   // 從編輯頁傳進來的原始清單（唯讀）
    let remainingSlots: Int         // 編輯頁目前剩幾格空白
    let onImport: ([String]) -> Void  // 按「確定匯入」時，把勾選的標題交回編輯頁

    @Environment(\.dismiss) private var dismiss

    @State private var items: [ReminderItem] = []      // 表單內的副本，改名改在這裡
    @State private var selectedIDs: Set<String> = []   // 已勾選的 id

    // 還能再勾幾個
    private var availableCount: Int {
        remainingSlots - selectedIDs.count
    }

    // 原始標題超過字數的 id（用原始標題判斷，改名到一半輸入框才不會消失）
    private var overLimitIDs: Set<String> {
        Set(reminders.filter { isOverLimit($0.title) }.map { $0.id })
    }

    // 原始標題，列表上固定顯示原名
    private var originalTitles: [String: String] {
        Dictionary(uniqueKeysWithValues: reminders.map { ($0.id, $0.title) })
    }

    // 勾選項目的標題（依清單順序，去掉頭尾空白）
    private var selectedTitles: [String] {
        items
            .filter { selectedIDs.contains($0.id) }
            .map { $0.title.trimmingCharacters(in: .whitespacesAndNewlines) }
    }

    // 可以匯入：至少勾一個，且勾選的每一項都不是空白、也沒超過字數
    private var canImport: Bool {
        let selectedItems = items.filter { selectedIDs.contains($0.id) }
        return !selectedItems.isEmpty
            && selectedItems.allSatisfy { !$0.title.isBlank && !isOverLimit($0.title) }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach($items) { $item in
                        let isSelected = selectedIDs.contains(item.id)
                        // 不能點：還沒勾，而且已經勾滿
                        let isDisabled = !isSelected && availableCount <= 0
                        let isLong = overLimitIDs.contains(item.id)

                        VStack(alignment: .leading, spacing: 8) {
                            // 第一行：勾選圖示 + 原始標題
                            Button {
                                toggle(item)
                            } label: {
                                HStack(spacing: 12) {
                                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                                        .font(.title3)
                                        .foregroundColor(isSelected ? .blue : .secondary)
                                    Text(originalTitles[item.id] ?? item.title)
                                        .foregroundColor(.primary)
                                    Spacer()
                                }
                                .contentShape(Rectangle())   // 整列（含空白處）都能點
                            }
                            .buttonStyle(.plain)
                            .disabled(isDisabled)

                            // 第二行：超過字數時的提示 / 改名欄位
                            if isLong {
                                if isSelected {
                                    HStack {
                                        TextField("請修改任務名稱", text: $item.title)
                                            .textFieldStyle(.roundedBorder)
                                        Text("\(item.title.count)/\(maxTitleLength)")
                                            .font(.caption)
                                            .monospacedDigit()
                                            .foregroundColor(isOverLimit(item.title) ? .red : .secondary)
                                    }
                                    .padding(.leading, 36)
                                } else {
                                    Text("超過 \(maxTitleLength) 字，勾選後需修改名稱")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .padding(.leading, 36)
                                }
                            }
                        }
                        .opacity(isDisabled ? 0.4 : 1.0)
                    }
                } header: {
                    Text("尚可匯入 \(availableCount) 個項目")
                }
            }
            .navigationTitle("匯入提醒事項")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("確定匯入") {
                        onImport(selectedTitles)
                        dismiss()
                    }
                    .disabled(!canImport)
                }
            }
        }
        .onAppear {
            items = reminders
        }
    }

    // 切換勾選：已勾 → 取消；未勾且還有名額 → 勾選
    private func toggle(_ item: ReminderItem) {
        if selectedIDs.contains(item.id) {
            selectedIDs.remove(item.id)
        } else if availableCount > 0 {
            selectedIDs.insert(item.id)
        }
    }

    // 字數判斷集中在這裡，之後改 B 方案（加權計算）只要改這一個函式
    private func isOverLimit(_ title: String) -> Bool {
        title.count > maxTitleLength
    }
}
