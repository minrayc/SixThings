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
    @State var showTaskEdit = false
    
    var body: some View {
        
        ZStack {
            
            VStack(spacing: 10) {
                //廣告
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 50)

                VStack {
                    //CircularProgressView + 鼓勵提示詞
                    CircularProgressView(progress: viewModel.todayTasks.filter { $0.isCompleted }.count)
                    
                        .frame(height: 170)
                    Text(viewModel.getEncouragement(progress: viewModel.todayTasks.filter { $0.isCompleted }.count))
                        .font(.custom("JasonHandwriting4-Regular", size: 20))
                        .tracking(5)
                        .frame(maxWidth: .infinity)
                        .frame(height: 80)
                        .padding(.horizontal, 8)
                        .frame(maxWidth: .infinity)
                        .overlay(alignment: .top) {
                            HandwrittenLine()
                        }
                        .overlay(alignment: .bottom) {
                            HandwrittenLine()
                        }
                    
                }
                .frame(height: 250)
                
                VStack {
                    //六個任務欄位
                    ForEach($viewModel.todayTasks) { $task in
                        TaskRowView(task: $task)
                    }
                    // 補空白行
                    ForEach(viewModel.todayTasks.count..<6, id: \.self) { i in
                        HStack(spacing: 14) {
                            Text("\(i + 1)")
                                .font(.custom("JasonHandwriting4-Regular", size: 20))
                                .foregroundColor(.secondary)
                                .frame(minWidth: 28)
                            Spacer()
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 8)
                        .overlay(Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.4)), alignment: .bottom)
                    }
                }
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
            RadialMenuView(isExpanded: $isExpanded, showTaskEdit: $showTaskEdit)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        }
        .navigationDestination(isPresented: $showTaskEdit) {
            TaskEditView()
        }
        
    }
}

#Preview {
    let vm = TaskViewModel()
    vm.todayTasks = [
        Task(title: "完成報告第一章", priority: 1, isCompleted: true, date: Date()),
        Task(title: "回覆客戶信件", priority: 2, isCompleted: false, date: Date()),
        Task(title: "整理會議記錄", priority: 3, isCompleted: false, date: Date()),
        //        Task(title: "回覆客戶信件", priority: 2, isCompleted: false, date: Date()),
        //        Task(title: "回覆客戶信件", priority: 2, isCompleted: false, date: Date()),
        //        Task(title: "回覆客戶信件", priority: 2, isCompleted: false, date: Date())
    ]
    return MainView()
        .environmentObject(vm)
}
