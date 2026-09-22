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
            
            VStack(spacing: 0) {
                //廣告
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 50)
                    .border(Color.black)
                HStack(spacing: 30) {
                    //CircularProgressView + 鼓勵提示詞
                    CircularProgressView(progress: viewModel.todayTasks.filter { $0.isCompleted }.count)
                        .border(Color.black)
                        .frame(maxWidth: 150, maxHeight: 150)
                    Text(viewModel.getEncouragement(progress: viewModel.todayTasks.filter { $0.isCompleted }.count))
                        .border(Color.black)
                    Spacer()
                }
                .padding()
                .border(Color.black)
                .frame(maxWidth: .infinity, maxHeight: 200)
                
                VStack {
                    //六個任務欄位
                    ForEach($viewModel.todayTasks) { $task in
                        TaskRowView(task: $task)
                    }
                }
                .frame(maxHeight: .infinity)
                .border(Color.black)
                
                
            }
            .padding(10)
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

//#Preview {
//    let vm = TaskViewModel()
//    vm.tasks = [
//        Task(title: "測試任務一", priority: 1, isCompleted: true, date: Date()),
//        Task(title: "測試任務二", priority: 2, isCompleted: false, date: Date())
//    ]
//    return MainView()
//        .environmentObject(vm)
//}
