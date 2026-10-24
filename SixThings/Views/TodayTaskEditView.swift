//
//  TodayTaskEditView.swift
//  SixThings
//
//  Created by 張閔瑞 on 2026/10/12.
//
import SwiftUI

struct TodayTaskEditView: View {
    @EnvironmentObject var viewModel: TaskViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.openURL) var openURL
    
    @State private var lockedTasks: [Task] = []
    @State private var editableTasks: [Task] = []
    @State private var showTips = false
    @State private var showDeniedAlert: Bool = false
    @State private var showFullAlert: Bool = false
    @State private var importSession: ImportSession?
    
    @FocusState private var isEditing: Bool   // 是否有輸入框正在輸入
    
    private let tips: [LocalizedStringKey] = [
        "任務可以是一個目標，可以是一個好習慣，例如：運動30分鐘、完成報告的摘要",
        "先後順序很重要，你必須訓練對於任務的輕重緩急認知，才能更好地管理時間"
    ]
    
    // 唯讀：今天已經滿 6 個，沒有可編輯的空格
    var isReadOnly: Bool {
        editableTasks.isEmpty
    }
    
    // 可儲存：可編輯區的每一格都填了內容
    var canSave: Bool {
        editableTasks.allSatisfy { !$0.title.isBlank }
    }
    
    var remainingSlots: Int {
        editableTasks.filter { $0.title.isBlank }.count
    }
    
    // 匯入的標題依序填進空白格：A、空、B、空、空 + [X, Y] → A、X、B、Y、空
    private func fillBlankSlots(with titles: [String]) {
        var iterator = titles.makeIterator()
        for index in editableTasks.indices where editableTasks[index].title.isBlank {
            guard let title = iterator.next() else { break }
            editableTasks[index].title = title
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 上方廣告
            AdBannerView()
            
            ZStack(alignment: .topTrailing) {
                // 最底層：主要內容
                VStack(spacing: 10) {
                    // 匯入按鈕、燈泡按鈕列
                    HStack {
                        Spacer()
                        Button {
                            if viewModel.remindersService.isAccessDenied() {
                                showDeniedAlert = true
                            } else if remainingSlots <= 0 {
                                showFullAlert = true
                            } else {
                                _Concurrency.Task {
                                    let granted = await viewModel.remindersService.requestRemindersAccess()
                                    if granted {
                                        let reminders = await viewModel.remindersService.fetchReminders(dueOn: Date())
                                        importSession = ImportSession(reminders: reminders)
                                    }
                                }
                            }
                        } label: {
                            Image(systemName: "square.and.arrow.down")
                                .font(.title3)
                                .foregroundColor(.primary)
                                .frame(width: 40, height: 40)
                                .background(
                                    Circle()
                                        .fill(Color(.systemBackground))
                                )
                                .overlay(
                                    Circle()
                                        .stroke(Color.primary, lineWidth: 1.5)
                                )
                        }
                        .alert("需要提醒事項權限", isPresented: $showDeniedAlert ) {
                            Button("取消", role: .cancel) { }
                            Button("前往設定") {
                                if let url = URL(string: UIApplication.openSettingsURLString) {
                                    openURL(url)
                                }
                            }
                        } message: {
                            Text("請到「設定」開啟提醒事項權限，即可匯入任務")
                        }
                        .alert("任務已滿", isPresented: $showFullAlert) {
                            Button("我知道了", role: .cancel) { }
                        }
                        
                        Button {
                            withAnimation { showTips.toggle() }
                        } label: {
                            Image(systemName: showTips ? "lightbulb.fill" : "lightbulb")
                                .font(.title3)
                                .foregroundColor(.yellow)
                                .frame(width: 40, height: 40)
                                .background(
                                    Circle()
                                        .fill(showTips ? Color.yellow.opacity(0.15) : Color.clear)
                                )
                                .overlay(
                                    Circle()
                                        .stroke(Color.yellow, lineWidth: 1.5)
                                )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 15)
                    
                    
                    // 標題
                    Text("今日任務")
                        .font(.title)
                    
                    // 列表
                    List {
                        // 鎖定區：只顯示，不能改也不能拖
                        ForEach(lockedTasks) { task in
                            Text(task.title)
                                .foregroundColor(.secondary)
                        }
                        .listRowBackground(Color.clear)
                        
                        // 可編輯區：可輸入、可拖曳
                        ForEach($editableTasks) { $task in
                            TextField("任務名稱", text: $task.title)
                                .focused($isEditing)
                                .onChange(of: task.title) {
                                    if task.title.isOverTitleLimit {
                                        task.title = task.title.truncatedToTitleLimit()
                                    }
                                }
                        }
                        .onMove { from, to in
                            editableTasks.move(fromOffsets: from, toOffset: to)
                        }
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .environment(\.editMode, .constant(.active))
                    .padding(.top, 30)
                    
                    // 儲存按鈕
                    Button {
                        if !isReadOnly {
                            viewModel.saveTodayTasks(newTasks: lockedTasks + editableTasks)
                        }
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: isReadOnly ? "arrow.left" : "checkmark")
                            Text(isReadOnly ? "返回" : "儲存並返回")
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                        .background(Color.blue)
                        .clipShape(Capsule())
                    }
                    .disabled(!isReadOnly && !canSave)
                    .opacity(!isReadOnly && !canSave ? 0.4 : 1.0)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal)
                }
                
                if showTips {
                    // 中間層：透明遮罩，點提示卡以外的地方收合
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation { showTips = false }
                        }
                    
                    // 最上層：提示卡
                    TipsCard(tips: tips)
                        .padding(.top, 56)
                        .padding(.horizontal)
                        .onTapGesture {
                            withAnimation { showTips = false }
                        }
                }
            }
            
            // 下方廣告：輸入時隱藏，避免被鍵盤推上來誤觸
            if !isEditing {
                AdBannerView()
                    .padding(.top, 8)
            }
        }
        .onAppear {
            // 1. 鎖定區：目前今天的任務
            lockedTasks = viewModel.todayTasks
            
            // 2. 可編輯區：空白任務，補到兩區合計 6 個，日期是今天
            let remaining = 6 - lockedTasks.count
            editableTasks = remaining > 0 ? (1...remaining).map { _ in
                Task(title: "", isCompleted: false, date: Date())
            } : []
        }
        .sheet(item: $importSession) { session in
            ImportRemindersView(
                reminders: session.reminders,
                remainingSlots: remainingSlots,
                emptyDescription: "提醒事項中沒有今天到期、未完成的項目"
            ) { titles in
                fillBlankSlots(with: titles)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct ImportSession: Identifiable {
    let id = UUID()
    let reminders: [ReminderItem]
}


#Preview {
    TodayTaskEditView()
        .environmentObject(TaskViewModel())
}
