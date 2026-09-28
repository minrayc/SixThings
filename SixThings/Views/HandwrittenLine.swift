//
//  HandwrittenLine.swift
//  SixThings
//
//  Created by 張閔瑞 on 2026/9/28.
//
import SwiftUI

struct HandwrittenLine: View {
    var body: some View {
        Canvas { context, size in
            var path = Path()
            path.move(to: CGPoint(x: 4, y: size.height / 2))
            path.addCurve(
                to: CGPoint(x: size.width - 4, y: size.height / 2),
                control1: CGPoint(x: size.width * 0.3, y: size.height / 2 - 2),
                control2: CGPoint(x: size.width * 0.7, y: size.height / 2 + 2)
            )
            context.stroke(path, with: .color(.primary.opacity(0.5)), lineWidth: 1.5)
        }
        .frame(height: 6)
    }
}
