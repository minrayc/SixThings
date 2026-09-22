import SwiftUI

struct CircularProgressView: View {
    let progress: Int // 0-6
    
    let baseColors: [Color] = [.red, .orange, .yellow, .green.opacity(0.7), .green, .green.opacity(1.2)]
    
    var currentColor: Color {
        guard progress > 0 else { return Color.gray.opacity(0.3) }
        return baseColors[progress - 1]
    }
    
    var radarSpeed: Double {
        guard progress > 0 else { return 0 }
        let targetAngle = Double.pi * 2 * Double(progress) / 6
        let minTime = 90.0, maxTime = 240.0
        let frames = minTime + (maxTime - minTime) * (1 - Double(progress) / 6)
        return targetAngle / frames
    }
    
    var body: some View {
        
        ZStack {
            TimelineView(.animation) { timeline in
                Canvas { context, size in
                    let cx = size.width / 2
                    let cy = size.height / 2
                    let r = min(cx, cy) - 10
                    let lineWidth: CGFloat = 10
                    let startAngle = Angle.degrees(-90)
                    let progressAngle = Angle.degrees(360 * Double(progress) / 6)
                    let time = timeline.date.timeIntervalSinceReferenceDate
                    
                    // 底圓
                    var bgCircle = Path()
                    bgCircle.addArc(center: CGPoint(x: cx, y: cy), radius: r, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)
                    context.stroke(bgCircle, with: .color(.gray.opacity(0.2)), style: StrokeStyle(lineWidth: lineWidth, lineCap: .butt))
                    
                    guard progress > 0 else { return }
                    
                    // 呼吸底色
                    let breathVal = (sin(time * 2.0) + 1) / 2
                    let arcColor = currentColor.opacity(0.3 + 0.7 * breathVal)
                    
                    var arcPath = Path()
                    arcPath.addArc(center: CGPoint(x: cx, y: cy), radius: r, startAngle: startAngle, endAngle: startAngle + progressAngle, clockwise: false)
                    context.stroke(arcPath, with: .color(arcColor), style: StrokeStyle(lineWidth: lineWidth, lineCap: .butt))
                    
                    // 雷達拖尾
                    let targetAngle = Double.pi * 2 * Double(progress) / 6
                    let radarAngle = (time * radarSpeed * 60).truncatingRemainder(dividingBy: targetAngle)
                    let tailLen = min(1.4, targetAngle)
                    let steps = 60
                    
                    for i in 0..<steps {
                        let frac = Double(i) / Double(steps)
                        let nextFrac = Double(i + 1) / Double(steps)
                        let segStart = radarAngle - tailLen * (1 - frac)
                        let segEnd = radarAngle - tailLen * (1 - nextFrac)
                        let clampedStart = max(0, min(targetAngle, segStart))
                        let clampedEnd = max(0, min(targetAngle, segEnd))
                        if clampedEnd <= clampedStart { continue }
                        
                        var tailPath = Path()
                        tailPath.addArc(
                            center: CGPoint(x: cx, y: cy),
                            radius: r,
                            startAngle: startAngle + .radians(clampedStart),
                            endAngle: startAngle + .radians(clampedEnd),
                            clockwise: false
                        )
                        context.stroke(tailPath, with: .color(.white.opacity(nextFrac * 0.85)), style: StrokeStyle(lineWidth: lineWidth, lineCap: .butt))
                    }
                }
            }
            
            // 中間文字
            VStack(spacing: 2) {
                Text("\(progress)")
                    .font(.title)
                    .bold()
                Text("/6")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        
    }
}

#Preview {
    CircularProgressView(progress: 3)
}
