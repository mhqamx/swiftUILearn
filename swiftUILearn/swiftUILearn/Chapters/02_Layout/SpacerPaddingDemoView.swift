//
//  SpacerPaddingDemoView.swift
//  swiftUILearn
//
//  【知识点】Spacer 弹性空白 & Padding 内边距
//  场景：书籍卡片排版间距控制
//

import SwiftUI

struct SpacerPaddingDemoView: View {
    @State private var horizontalPad: Double = 16
    @State private var verticalPad: Double = 12
    @State private var showSpacerHighlight = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                DemoHeader(
                    title: "Spacer & Padding",
                    subtitle: "Padding 控制视图内边距，Spacer 是弹性空白块，两者是布局间距的核心工具。"
                )

                // ── 1. Padding 演示 ──
                GroupBox("📐 Padding 内边距") {
                    VStack(spacing: 16) {
                        // 动态控制 padding 大小
                        HStack {
                            Text("水平内边距: \(Int(horizontalPad))pt")
                            Spacer()
                            Slider(value: $horizontalPad, in: 0...40, step: 4)
                                .frame(width: 120)
                        }
                        .font(.caption)

                        HStack {
                            Text("垂直内边距: \(Int(verticalPad))pt")
                            Spacer()
                            Slider(value: $verticalPad, in: 0...40, step: 4)
                                .frame(width: 120)
                        }
                        .font(.caption)

                        // 演示区域
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.blue.opacity(0.5), lineWidth: 1)
                            Text("《活着》余华 著")
                                .font(.headline)
                                // .padding(.horizontal) / .vertical 分方向设置
                                .padding(.horizontal, horizontalPad)
                                .padding(.vertical, verticalPad)
                                .background(Color.blue.opacity(0.1))
                        }
                        .fixedSize()

                        Text("蓝色边框 = 视图边界，蓝色背景 = padding 扩展的区域")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    .padding(8)
                }

                // ── 2. Padding 的各种写法 ──
                GroupBox("✍️ Padding 写法汇总") {
                    VStack(spacing: 8) {
                        PaddingExample(label: ".padding()", value: "四边相等默认值(16pt)")
                        PaddingExample(label: ".padding(20)", value: "四边相等自定义值")
                        PaddingExample(label: ".padding(.horizontal, 16)", value: "仅左右两边")
                        PaddingExample(label: ".padding(.vertical, 8)", value: "仅上下两边")
                        PaddingExample(label: ".padding(.top, 12)", value: "仅顶部")
                        PaddingExample(label: ".padding([.top, .leading], 8)", value: "多边独立设置")
                    }
                    .padding(8)
                }

                // ── 3. Spacer 演示 ──
                GroupBox("↔️ Spacer 弹性空白") {
                    VStack(spacing: 16) {
                        Toggle("高亮显示 Spacer", isOn: $showSpacerHighlight)
                            .font(.caption)

                        // 无 Spacer：内容居左
                        HStack {
                            Text("书名：活着")
                            Text("余华").foregroundStyle(.secondary)
                        }
                        .font(.footnote)
                        .padding(6)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 6))

                        // 有 Spacer：内容分布两端
                        HStack {
                            Text("书名：活着")
                            // Spacer 填充 HStack 中的剩余空间，将两侧内容推向两端
                            Spacer()
                                .background(showSpacerHighlight ? Color.yellow.opacity(0.5) : Color.clear)
                            Text("余华").foregroundStyle(.secondary)
                        }
                        .font(.footnote)
                        .padding(6)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 6))

                        // Spacer(minLength:) 设置最小宽度
                        HStack {
                            Text("ISBN")
                            Spacer(minLength: 20)  // 至少保留20pt空间
                                .background(showSpacerHighlight ? Color.yellow.opacity(0.5) : Color.clear)
                            Text("978-7-5399-4675-9").font(.caption.monospaced())
                        }
                        .font(.footnote)
                        .padding(6)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                    .padding(8)
                }

                ConceptNote(items: [
                    ".padding()：默认四边各加16pt，最常用",
                    ".padding(.horizontal, 16)：只加左右边距",
                    "Spacer()：自动填充剩余空间，常用于左右对齐",
                    "Spacer(minLength: 20)：设置最小尺寸，防止内容过于靠近",
                    ".frame(maxWidth: .infinity)：让视图撑满父容器宽度，常见替代方案"
                ])
            }
            .padding()
        }
        .navigationTitle("Spacer & Padding")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct PaddingExample: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.caption.monospaced())
                .foregroundStyle(.orange)
            Spacer()
            Text(value)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    NavigationStack {
        SpacerPaddingDemoView()
    }
}
