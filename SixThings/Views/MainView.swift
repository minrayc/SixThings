//
//  MainView.swift
//  SixThings
//
//  Created by 張閔瑞 on 2026/9/9.
//
import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var viewModel: TaskViewModel
    @State var isExpanded = false
    @State var showTodayEdit = false
    @State var showTomorrowEdit = false
    @State var currentEncouragement = ""
    @AppStorage("hasSeenTutorial") var hasSeenTutorial = false
    @State var showTutorial = false
    @State var showSettings = false
    
    var completedCount:Int {
        viewModel.todayTasks.filter { $0.isCompleted }.count
    }
    var body: some View {
        
        ZStack {
            
            VStack(spacing: 10) {
                //廣告
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 50)
                
                VStack {
                    //CircularProgressView + 鼓勵提示詞
                    CircularProgressView(progress: completedCount)
                        .frame(height: 170)
                        .tutorialTarget(.progress)
                    Text(LocalizedStringKey(currentEncouragement))
                        .font(.title3)
                        .frame(maxWidth: .infinity)
                        .frame(height: 80)
                        .padding(.horizontal, 8)
                        .overlay(alignment: .top) {
                            HandwrittenLine()
                        }
                        .overlay(alignment: .bottom) {
                            HandwrittenLine()
                        }
                        .onChange(of: completedCount) {
                            currentEncouragement = viewModel.getEncouragementKey(progress: completedCount)
                        }
                    
                }
                .frame(height: 250)
                .overlay(alignment: .topTrailing) {
                    Button {
                        withAnimation { showTutorial = true }
                    } label: {
                        Image(systemName: "lightbulb")
                            .font(.title3)
                            .foregroundColor(.yellow)
                            .frame(width: 40, height: 40)
                            .overlay(Circle().stroke(Color.yellow, lineWidth: 1.5))
                    }
                }
                VStack {
                    //六個任務欄位
                    ForEach(Array(viewModel.todayTasks.enumerated()), id: \.element.id) { index, task in
                        TaskRowView(
                            task: task,
                            number: index + 1,
                            isCurrent: task.id == viewModel.currentTaskID
                        )
                    }
                    // 補空白行
                    ForEach(viewModel.todayTasks.count..<6, id: \.self) { i in
                        HStack(spacing: 14) {
                            Text(verbatim: "\(i + 1)")
                                .font(.title3)
                                .foregroundColor(.secondary)
                                .frame(minWidth: 28)
                            Spacer()
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 8)
                        .overlay(Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.4)), alignment: .bottom)
                    }
                }
                .tutorialTarget(.tasks)
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, 15)
                
            }
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            if isExpanded {
                Color.black.opacity(0.2)
                    .ignoresSafeArea()
                    .onTapGesture {
                        // 收合選單
                        isExpanded = false
                    }
            }
            RadialMenuView(
                isExpanded: $isExpanded,
                showTodayEdit: $showTodayEdit,
                showTomorrowEdit: $showTomorrowEdit,
                isTodayTaskSet: viewModel.isTodayTaskSet(),
                showSettings: $showSettings
                
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        }
        .navigationDestination(isPresented: $showTodayEdit) {
            TodayTaskEditView()
        }
        .navigationDestination(isPresented: $showTomorrowEdit) {
            TomorrowTaskEditView()
        }
        .navigationDestination(isPresented: $showSettings) {
            SettingsView()
        }
        .overlayPreferenceValue(TutorialAnchorKey.self) { anchors in
            if showTutorial {
                TutorialOverlay(anchors: anchors, isPresented: $showTutorial)
            }
        }
        // 點 + 號展開選單時檢查跨日（處理停在畫面上跨過 00:00 的情況）
        .onChange(of: isExpanded) {
            if isExpanded {
                viewModel.checkAndUpdateDate()
            }
        }
        // 從編輯頁返回主畫面時
        .onAppear {
            viewModel.checkAndUpdateDate()
            currentEncouragement = viewModel.getEncouragementKey(progress: completedCount)
            if !hasSeenTutorial {
                viewModel.addTutorialTask()
                showTutorial = true
                hasSeenTutorial = true
            }
        }
        // 午夜換日時系統自動通知
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.significantTimeChangeNotification)) { _ in
            viewModel.checkAndUpdateDate()
        }
        
    }
}

#Preview {
    let vm = TaskViewModel()
    vm.tasks = [
        Task(title: "完成報告第一章", isCompleted: true, date: Date()),
        Task(title: "回覆客戶信件", isCompleted: false, date: Date()),
        Task(title: "整理會議記錄", isCompleted: false, date: Date())
    ]
    return MainView()
        .environmentObject(vm)
}
