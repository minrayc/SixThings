//
//  LanguageSelectionView.swift
//  SixThings
//
//  Created by 張閔瑞 on 2026/10/16.
//
import SwiftUI

struct LanguageSelectionView: View {
    
    @AppStorage("appLanguage") var appLanguage = ""
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 30) {
                Button {
                    appLanguage = "zh-Hant"
                } label: {
                    Text("中文")
                        .font(.title2)
                        .foregroundColor(.primary)
                        .frame(width: 200)
                        .padding(.vertical, 16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.primary, lineWidth: 1.5)
                        )
                        .contentShape(RoundedRectangle(cornerRadius: 12))
                }
                Button {
                    appLanguage = "en"
                } label: {
                    Text("English")
                        .font(.title2)
                        .foregroundColor(.primary)
                        .frame(width: 200)
                        .padding(.vertical, 16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.primary, lineWidth: 1.5)
                        )
                        .contentShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            Spacer()
        }
    }
}

#Preview {
    LanguageSelectionView()
}
