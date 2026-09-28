//
//  WavyStrikethrough.swift
//  SixThings
//
//  Created by 張閔瑞 on 2026/9/28.
//
import SwiftUI

struct WavyStrikethrough: View {
    var body: some View {
        GeometryReader { geo in
            Path { path in
                let width = geo.size.width
                let midY = geo.size.height / 2
                let waveWidth: CGFloat = 12
                let amplitude: CGFloat = 2.5
                
                path.move(to: CGPoint(x: 0, y: midY))
                
                var x: CGFloat = 0
                while x < width {
                    let nextX = min(x + waveWidth, width)
                    let controlY = (x / waveWidth).truncatingRemainder(dividingBy: 2) < 1
                        ? midY - amplitude
                        : midY + amplitude
                    path.addQuadCurve(
                        to: CGPoint(x: nextX, y: midY),
                        control: CGPoint(x: (x + nextX) / 2, y: controlY)
                    )
                    x = nextX
                }
            }
            .stroke(Color.primary.opacity(0.6), lineWidth: 1.2)
        }
        .frame(height: 8)
    }
}
