//
//  ShapePathDemoView.swift
//  swiftUILearn
//
//  【知识点】Shape & Path
//  场景：内置形状、自定义路径、书签形状、星形评分
//

import SwiftUI

struct ShapePathDemoView: View {
    @State private var trimEnd: CGFloat = 1.0
    @State private var starRating = 3

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                DemoHeader(
                    title: "Shape & Path",
                    subtitle: "Shape 协议和 Path 是 SwiftUI 绘图的基础，可以创建任意自定义图形。"
                )

                // ── 1. 内置形状 ──
                GroupBox("🔵 内置形状") {
                    VStack(spacing: 12) {
                        HStack(spacing: 16) {
                            VStack {
                                Rectangle()
                                    .fill(Color.blue.gradient)
                                    .frame(width: 50, height: 50)
                                Text("Rectangle")
                                    .font(.caption2)
                            }

                            VStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.green.gradient)
                                    .frame(width: 50, height: 50)
                                Text("Rounded")
                                    .font(.caption2)
                            }

                            VStack {
                                Circle()
                                    .fill(Color.orange.gradient)
                                    .frame(width: 50, height: 50)
                                Text("Circle")
                                    .font(.caption2)
                            }

                            VStack {
                                Capsule()
                                    .fill(Color.purple.gradient)
                                    .frame(width: 70, height: 35)
                                Text("Capsule")
                                    .font(.caption2)
                            }

                            VStack {
                                Ellipse()
                                    .fill(Color.pink.gradient)
                                    .frame(width: 60, height: 40)
                                Text("Ellipse")
                                    .font(.caption2)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(8)
                }

                // ── 2. fill/stroke/trim ──
                GroupBox("📐 fill / stroke / trim") {
                    VStack(spacing: 16) {
                        HStack(spacing: 20) {
                            VStack {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 50, height: 50)
                                Text("fill")
                                    .font(.caption2)
                            }

                            VStack {
                                Circle()
                                    .stroke(Color.blue, lineWidth: 3)
                                    .frame(width: 50, height: 50)
                                Text("stroke")
                                    .font(.caption2)
                            }

                            VStack {
                                Circle()
                                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 3, dash: [5, 3]))
                                    .frame(width: 50, height: 50)
                                Text("虚线")
                                    .font(.caption2)
                            }

                            VStack {
                                Circle()
                                    .trim(from: 0, to: trimEnd)
                                    .stroke(Color.orange, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                                    .frame(width: 50, height: 50)
                                    .rotationEffect(.degrees(-90))
                                Text("trim")
                                    .font(.caption2)
                            }
                        }

                        VStack {
                            Slider(value: $trimEnd, in: 0...1)
                            Text("trim: \(String(format: "%.2f", trimEnd))")
                                .font(.caption.monospaced())
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(8)
                }

                // ── 3. 自定义 Path ──
                GroupBox("✏️ 自定义 Path 画书签") {
                    VStack(spacing: 12) {
                        Text("使用 Path 绘制书签形状")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        HStack(spacing: 20) {
                            BookmarkShape()
                                .fill(Color.red.gradient)
                                .frame(width: 40, height: 60)

                            BookmarkShape()
                                .stroke(Color.blue, lineWidth: 2)
                                .frame(width: 40, height: 60)

                            BookmarkShape()
                                .fill(Color.orange.gradient)
                                .frame(width: 50, height: 70)
                                .shadow(color: .orange.opacity(0.3), radius: 4, y: 2)
                        }

                        Text("Path { path in path.move(to:); path.addLine(to:) }")
                            .font(.caption2.monospaced())
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(8)
                }

                // ── 4. Shape 协议 ──
                GroupBox("⭐️ 自定义 Shape（星形评分）") {
                    VStack(spacing: 12) {
                        Text("实现 Shape 协议绘制星形")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        HStack(spacing: 8) {
                            ForEach(1...5, id: \.self) { star in
                                StarShape(points: 5)
                                    .fill(star <= starRating ? Color.yellow : Color.gray.opacity(0.2))
                                    .frame(width: 36, height: 36)
                                    .overlay {
                                        StarShape(points: 5)
                                            .stroke(Color.orange, lineWidth: 1)
                                    }
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.3)) {
                                            starRating = star
                                        }
                                    }
                                    .scaleEffect(star <= starRating ? 1.1 : 1.0)
                            }
                        }

                        Text("评分：\(starRating) / 5")
                            .font(.subheadline.bold())
                    }
                    .frame(maxWidth: .infinity)
                    .padding(8)
                }

                ConceptNote(items: [
                    "Shape 协议：实现 path(in:) 方法返回 Path",
                    "Path：通过 move(to:)、addLine(to:)、addArc 等方法绘制",
                    ".fill()：填充形状内部颜色",
                    ".stroke(style:)：描边，支持线宽、虚线、线端样式",
                    ".trim(from:to:)：裁剪形状的可见部分，常用于动画进度"
                ])
            }
            .padding()
        }
        .navigationTitle("Shape & Path")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 书签形状
struct BookmarkShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY - rect.height * 0.2))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

// MARK: - 星形
struct StarShape: Shape {
    let points: Int

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let outerRadius = min(rect.width, rect.height) / 2
        let innerRadius = outerRadius * 0.4
        let totalPoints = points * 2

        var path = Path()

        for i in 0..<totalPoints {
            let angle = (Double(i) * .pi / Double(points)) - .pi / 2
            let radius = i.isMultiple(of: 2) ? outerRadius : innerRadius
            let point = CGPoint(
                x: center.x + CGFloat(cos(angle)) * radius,
                y: center.y + CGFloat(sin(angle)) * radius
            )

            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.closeSubpath()
        return path
    }
}

#Preview {
    NavigationStack {
        ShapePathDemoView()
    }
}
