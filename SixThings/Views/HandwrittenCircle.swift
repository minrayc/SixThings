//
//  HandwrittenCircle.swift
//  SixThings
//
//  Created by 張閔瑞 on 2026/9/29.
//

import SwiftUI

struct HandwrittenCircle: View {
    var body: some View {
        Canvas { context, size in
            let cx = size.width / 2
            let cy = size.height / 2
            let rx = size.width / 2 - 2
            let ry = size.height / 2 - 2
            
            let circles: [(Double, Double, Double, Double)] = [
                (cx, cy, rx, ry),           // 圈1：正常
                (cx+1, cy-1, rx+2, ry-1),  // 圈2：稍微偏移
                (cx-1, cy+1, rx-1, ry+1),  // 圈3：反方向偏移
            ]
            
            let widths: [Double] = [1.2, 1.0, 0.8]
            
            for (i, (x, y, rX, rY)) in circles.enumerated() {
                let path = Path(ellipseIn: CGRect(
                    x: x - rX, y: y - rY,
                    width: rX * 2, height: rY * 2
                ))
                context.stroke(path, with: .color(.primary.opacity(0.8)),
                              style: StrokeStyle(lineWidth: widths[i]))
            }
        }
    }
}
