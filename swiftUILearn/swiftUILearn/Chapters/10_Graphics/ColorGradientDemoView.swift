//
//  ColorGradientDemoView.swift
//  swiftUILearn
//
//  【知识点】Color & Gradient
//  场景：颜色系统、渐变效果、文字和图片叠加
//

import SwiftUI

struct ColorGradientDemoView: View {
    @State private var hue: Double = 0.6
    @State private var saturation: Double = 0.8
    @State private var brightness: Double = 0.9

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                DemoHeader(
                    title: "Color & Gradient",
                    subtitle: "SwiftUI 提供了丰富的颜色和渐变 API，支持语义化颜色、自定义颜色和多种渐变样式。"
                )

                // ── 1. 颜色系统 ──
                GroupBox("🎨 颜色系统") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("系统颜色")
                            .font(.subheadline.bold())

                        HStack(spacing: 8) {
                            ForEach([Color.red, .orange, .yellow, .green, .blue, .purple, .pink], id: \.self) { color in
                                Circle()
                                    .fill(color)
                                    .frame(width: 30, height: 30)
                            }
                        }

                        Text("语义化颜色")
                            .font(.subheadline.bold())

                        HStack(spacing: 8) {
                            ColorLabel(color: .primary, name: "primary")
                            ColorLabel(color: .secondary, name: "secondary")
                            ColorLabel(color: .accentColor, name: "accent")
                        }

                        Text("自定义 HSB")
                            .font(.subheadline.bold())

                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(hue: hue, saturation: saturation, brightness: brightness))
                            .frame(height: 40)

                        VStack(spacing: 4) {
                            HStack {
                                Text("H: \(String(format: "%.2f", hue))")
                                Slider(value: $hue, in: 0...1)
                            }
                            HStack {
                                Text("S: \(String(format: "%.2f", saturation))")
                                Slider(value: $saturation, in: 0...1)
                            }
                            HStack {
                                Text("B: \(String(format: "%.2f", brightness))")
                                Slider(value: $brightness, in: 0...1)
                            }
                        }
                        .font(.caption.monospaced())
                    }
                    .padding(8)
                }

                // ── 2. LinearGradient ──
                GroupBox("🌈 LinearGradient 线性渐变") {
                    VStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    colors: [.blue, .purple, .pink],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(height: 80)
                            .overlay {
                                Text("topLeading → bottomTrailing")
                                    .font(.caption)
                                    .foregroundStyle(.white)
                            }

                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    stops: [
                                        .init(color: .red, location: 0),
                                        .init(color: .yellow, location: 0.3),
                                        .init(color: .green, location: 0.6),
                                        .init(color: .blue, location: 1.0)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(height: 40)

                        Text("stops 自定义渐变位置")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(8)
                }

                // ── 3. Radial / Angular ──
                GroupBox("☀️ RadialGradient & AngularGradient") {
                    HStack(spacing: 20) {
                        VStack {
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [.yellow, .orange, .red],
                                        center: .center,
                                        startRadius: 5,
                                        endRadius: 50
                                    )
                                )
                                .frame(width: 100, height: 100)
                            Text("Radial")
                                .font(.caption)
                        }

                        VStack {
                            Circle()
                                .fill(
                                    AngularGradient(
                                        colors: [.red, .orange, .yellow, .green, .blue, .purple, .red],
                                        center: .center
                                    )
                                )
                                .frame(width: 100, height: 100)
                            Text("Angular")
                                .font(.caption)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(8)
                }

                // ── 4. 渐变实战 ──
                GroupBox("🖼️ 渐变实战应用") {
                    VStack(spacing: 16) {
                        // 文字渐变
                        Text("SwiftUI 渐变文字")
                            .font(.title.bold())
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.blue, .purple, .pink],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )

                        // 卡片叠加
                        ZStack(alignment: .bottom) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.blue.gradient)
                                .frame(height: 150)
                                .overlay {
                                    Image(systemName: "book.fill")
                                        .font(.system(size: 50))
                                        .foregroundStyle(.white.opacity(0.3))
                                }

                            // 底部渐变遮罩
                            LinearGradient(
                                colors: [.clear, .black.opacity(0.7)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .frame(height: 60)
                            .clipShape(
                                UnevenRoundedRectangle(bottomLeadingRadius: 12, bottomTrailingRadius: 12)
                            )

                            Text("《SwiftUI 实战指南》")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .padding(12)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(8)
                }

                ConceptNote(items: [
                    "Color.red/.blue：系统颜色，自动适配深色模式",
                    ".primary/.secondary：语义化颜色，根据环境变化",
                    "LinearGradient：线性渐变，指定起点和终点",
                    "RadialGradient：径向渐变，从中心向外扩散",
                    "AngularGradient：角度渐变，沿圆周变化",
                    ".foregroundStyle(gradient)：将渐变应用于文字前景"
                ])
            }
            .padding()
        }
        .navigationTitle("Color & Gradient")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct ColorLabel: View {
    let color: Color
    let name: String

    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(color)
                .frame(width: 50, height: 30)
            Text(name)
                .font(.caption2)
        }
    }
}

#Preview {
    NavigationStack {
        ColorGradientDemoView()
    }
}
