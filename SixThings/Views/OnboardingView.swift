//
//  OnboardingView.swift
//  SixThings
//
//  Created by 張閔瑞 on 2026/9/27.
//
import SwiftUI

struct OnboardingView: View {
    
    @State var showFirstLine = true
    @State var phase = 0
    let lines: [LocalizedStringKey] = [
        "明天要交作業了卻還沒寫",
        "過了一年還是沒有瘦下來",
        "彷彿在原地踏步"
    ]
    
    @State var visibleLines: Int = 0
    @State var showWhiteFlash = false
    @State var isAnimating = false  // 新增：防止動畫期間重複點擊
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding = false
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                Image("onboarding_spiral_bg")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .offset(x: 0, y: 0) // 調整這個數值
                    .clipped()
            }
            .ignoresSafeArea()
            
            ZStack {
                switch phase {
                case 0:
                    Text("你是否曾有過這種情況？")
                        .font(.title2)
                        .foregroundColor(.black)
                        .opacity(showFirstLine ? 1 : 0)
                        .animation(.easeInOut(duration: 1.0), value: showFirstLine)
                    
                case 1:
                    VStack(spacing: 12) {
                        ForEach(0..<visibleLines, id: \.self) { i in
                            Text(lines[i])
                                .font(.title3)
                                .foregroundColor(.black)
                                .transition(.opacity)
                        }
                    }
                    .animation(.easeIn(duration: 0.5), value: visibleLines)
                    .frame(width: 250)
                    
                case 2:
                    VStack(spacing: 12) {
                        Text("現在開始慢慢改變")
                        Text("就讓我來協助你吧！")
                    }
                    .font(.title2)
                    .foregroundColor(.black)
                    .transition(.opacity)
                    
                default:
                    EmptyView()
                }
                
                // 點擊提示
                let showHint = phase == 0 || (phase == 1 && visibleLines == lines.count) || phase == 2
                if showHint && !showWhiteFlash {
                    Text("〉點擊下一步")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                        .padding()
                }
            }
            .padding()
            
            if showWhiteFlash {
                GeometryReader { geo in
                    ZStack {
                        RadialGradient(
                            colors: [.white, .white.opacity(0.9), .clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: geo.size.width
                        )
                        Color.white.opacity(0.85)
                    }
                }
                .ignoresSafeArea()
                .transition(.opacity)
            }
        }
        .onTapGesture {
            guard !isAnimating else { return }  // 防止重複點擊
            
            switch phase {
            case 0:
                isAnimating = true
                withAnimation {
                    showFirstLine = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation {
                        phase = 1
                    }
                    for i in 0..<lines.count {
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.5) {
                            withAnimation {
                                visibleLines = i + 1
                            }
                        }
                    }
                    // 動畫總時長：1.0 + (7 * 0.5) = 4.5 秒
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(lines.count) * 0.5) {
                        isAnimating = false
                    }
                }
                
            case 1 where visibleLines == lines.count:
                isAnimating = true
                withAnimation(.easeIn(duration: 0.8)) {
                    phase = 2
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    isAnimating = false
                }
                
            case 2:
                isAnimating = true
                withAnimation(.easeIn(duration: 1.5)) {
                    showWhiteFlash = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    hasSeenOnboarding = true
                }
                
            default:
                break
            }
        }
    }
}

#Preview {
    OnboardingView()
}
