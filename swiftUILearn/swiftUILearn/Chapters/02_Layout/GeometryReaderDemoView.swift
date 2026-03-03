//
//  GeometryReaderDemoView.swift
//  swiftUILearn
//
//  【知识点】GeometryReader 几何读取器
//  场景：根据屏幕尺寸自适应书籍封面和进度条
//

import SwiftUI

struct GeometryReaderDemoView: View {
    @State private var readProgress: Double = 0.35  // 阅读进度 0.0 ~ 1.0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                DemoHeader(
                    title: "GeometryReader",
                    subtitle: "GeometryReader 允许获取父容器的尺寸和坐标，实现自适应布局。"
                )

                // ── 1. 基础用法：获取容器尺寸 ──
                GroupBox("📏 获取容器尺寸") {
                    // GeometryReader 将父容器的几何信息通过 proxy 传入
                    GeometryReader { proxy in
                        VStack(alignment: .leading, spacing: 8) {
                            Text("容器宽度：\(Int(proxy.size.width)) pt")
                            Text("容器高度：\(Int(proxy.size.height)) pt")
                            Text("安全区域（顶部）：\(Int(proxy.safeAreaInsets.top)) pt")

                            // 根据容器宽度绘制分割线
                            Rectangle()
                                .fill(Color.blue.opacity(0.3))
                                .frame(width: proxy.size.width * 0.6, height: 4)
                                .clipShape(Capsule())

                            Text("上方蓝条 = 容器宽度的 60%")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .font(.footnote.monospaced())
                    }
                    // ⚠️ 必须给 GeometryReader 一个固定高度，否则会尝试撑满屏幕
                    .frame(height: 120)
                    .padding(8)
                }

                // ── 2. 自适应阅读进度条 ──
                GroupBox("📖 阅读进度条") {
                    VStack(spacing: 12) {
                        HStack {
                            Text("《活着》阅读进度")
                            Spacer()
                            Text("\(Int(readProgress * 100))%")
                                .bold()
                                .foregroundStyle(.blue)
                        }
                        .font(.footnote)

                        // 使用 GeometryReader 制作自适应宽度进度条
                        GeometryReader { proxy in
                            ZStack(alignment: .leading) {
                                // 背景条
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.gray.opacity(0.2))

                                // 进度条：宽度 = 容器宽度 × 进度比例
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.blue.gradient)
                                    .frame(width: proxy.size.width * readProgress)
                                    .animation(.easeInOut(duration: 0.3), value: readProgress)
                            }
                        }
                        .frame(height: 8)

                        Slider(value: $readProgress, in: 0...1)
                            .tint(.blue)
                    }
                    .padding(8)
                }

                // ── 3. 自适应封面网格 ──
                GroupBox("🖼 自适应封面宽度") {
                    GeometryReader { proxy in
                        // 根据容器宽度决定每列宽度（两列布局）
                        let itemWidth = (proxy.size.width - 24) / 3  // 减去间距再平分

                        HStack(spacing: 12) {
                            ForEach(["活着", "三体","大学"], id: \.self) { title in
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(title == "活着" ? Color.red.gradient : Color.blue.gradient)
                                    .frame(width: itemWidth, height: itemWidth * 1.4)  // 按比例算高度
                                    .overlay {
                                        Text(title)
                                            .font(.headline)
                                            .foregroundStyle(.white)
                                    }
                            }
                        }
                    }
                    .frame(height: 140)
                    .padding(8)
                }

                ConceptNote(items: [
                    "GeometryReader { proxy in }：proxy.size.width/height 获取容器尺寸",
                    "proxy.safeAreaInsets：获取安全区域内边距",
                    "必须设置 .frame(height:)：GeometryReader 默认撑满父容器，需指定高度",
                    "proxy.size.width * ratio：按比例计算子视图尺寸，实现自适应",
                    "适用场景：进度条、自适应卡片宽度、坐标依赖的动画"
                ])
            }
            .padding()
        }
        .navigationTitle("GeometryReader")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        GeometryReaderDemoView()
    }
}
