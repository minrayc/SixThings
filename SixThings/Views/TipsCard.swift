//
//  TipsCard.swift
//  SixThings
//
//  Created by 張閔瑞 on 2026/10/12.
//
import SwiftUI

struct TipsCard: View {
    let tips: [LocalizedStringKey]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 用 ForEach 把每條 tips 顯示成「✸ 內容」
            ForEach(tips.indices, id: \.self) { tip in
                HStack(alignment: .top, spacing: 6) {
                        Text(verbatim: "✸")
                        Text(tips[tip])
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 4)
    }
}
#Preview {
    VStack(spacing: 30) {
        TipsCard(tips: [
            "任務可以是一個目標，可以是一個好習慣，例如：運動30分鐘、完成報告的摘要",
            "先後順序很重要，你必須訓練對於任務的輕重緩急認知，才能更好地管理時間",
            "今日未完成任務會優先出現在上方，完成它們才會空出位置"
        ])
    }
    .padding()
}
