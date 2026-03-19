//
//  ScrollViewDemoView.swift
//  swiftUILearn
//
//  【知识点】ScrollView 滚动视图
//  场景：书单展示、分类轮播、书籍定位
//

import SwiftUI

struct ScrollViewDemoView: View {
    @State private var scrollTarget: Int?
    @State private var currentPage = 0

    // 示例书籍数据
    private let books = (1...30).map { "书籍 #\($0)" }
    private let categories = ["文学", "科技", "历史", "艺术", "哲学"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                DemoHeader(
                    title: "ScrollView 滚动视图",
                    subtitle: "ScrollView 是最基础的滚动容器，支持垂直和水平滚动，可以嵌套使用。"
                )

                // ── 1. 基础 ScrollView ──
                GroupBox("📜 基础 ScrollView") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("垂直滚动书单")
                            .font(.subheadline.bold())

                        ScrollView {
                            VStack(spacing: 8) {
                                ForEach(1...10, id: \.self) { i in
                                    HStack {
                                        Image(systemName: "book.fill")
                                            .foregroundStyle(.blue)
                                        Text("《SwiftUI 入门 第\(i)章》")
                                            .font(.subheadline)
                                        Spacer()
                                    }
                                    .padding(10)
                                    .background(Color.blue.opacity(0.05))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                            }
                        }
                        .frame(height: 200)

                        Text("水平滚动")
                            .font(.subheadline.bold())

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(1...8, id: \.self) { i in
                                    VStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.blue.gradient)
                                            .frame(width: 80, height: 110)
                                            .overlay {
                                                Image(systemName: "book.fill")
                                                    .font(.title2)
                                                    .foregroundStyle(.white)
                                            }
                                        Text("书籍\(i)")
                                            .font(.caption)
                                    }
                                }
                            }
                        }
                    }
                    .padding(8)
                }

                // ── 2. 嵌套滚动 ──
                GroupBox("🔄 嵌套滚动") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("垂直列表中嵌套水平轮播")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        ForEach(categories, id: \.self) { category in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(category)
                                    .font(.subheadline.bold())

                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 10) {
                                        ForEach(1...6, id: \.self) { i in
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(categoryColor(category).gradient)
                                                .frame(width: 100, height: 60)
                                                .overlay {
                                                    Text("\(category) \(i)")
                                                        .font(.caption)
                                                        .foregroundStyle(.white)
                                                }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(8)
                }

                // ── 3. ScrollViewReader ──
                GroupBox("📍 ScrollViewReader") {
                    VStack(spacing: 12) {
                        Text("点击按钮定位到指定书籍")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        HStack {
                            ForEach([1, 10, 20, 30], id: \.self) { num in
                                Button("第\(num)本") {
                                    scrollTarget = num
                                }
                                .font(.caption)
                                .buttonStyle(.bordered)
                            }
                        }

                        ScrollViewReader { proxy in
                            ScrollView {
                                VStack(spacing: 6) {
                                    ForEach(1...30, id: \.self) { i in
                                        HStack {
                                            Text("📖 书籍 #\(i)")
                                                .font(.subheadline)
                                            Spacer()
                                        }
                                        .padding(8)
                                        .background(scrollTarget == i ? Color.orange.opacity(0.2) : Color.gray.opacity(0.05))
                                        .clipShape(RoundedRectangle(cornerRadius: 6))
                                        .id(i)
                                    }
                                }
                            }
                            .frame(height: 180)
                            .onChange(of: scrollTarget) { _, target in
                                if let target {
                                    withAnimation {
                                        proxy.scrollTo(target, anchor: .center)
                                    }
                                }
                            }
                        }
                    }
                    .padding(8)
                }

                // ── 4. 滚动行为 ──
                GroupBox("📏 分页滚动效果") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("scrollTargetBehavior 实现分页")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        ScrollView(.horizontal) {
                            HStack(spacing: 0) {
                                ForEach(1...5, id: \.self) { i in
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill([Color.blue, .green, .orange, .purple, .pink][i - 1].gradient)
                                        .frame(width: 300, height: 180)
                                        .overlay {
                                            VStack {
                                                Image(systemName: "book.fill")
                                                    .font(.largeTitle)
                                                Text("推荐书单 \(i)")
                                                    .font(.headline)
                                            }
                                            .foregroundStyle(.white)
                                        }
                                        .padding(.horizontal, 10)
                                        .containerRelativeFrame(.horizontal)
                                }
                            }
                            .scrollTargetLayout()
                        }
                        .scrollTargetBehavior(.viewAligned)
                        .frame(height: 200)
                    }
                    .padding(8)
                }

                ConceptNote(items: [
                    "ScrollView(.horizontal)：水平滚动，默认是垂直滚动",
                    "ScrollViewReader：通过 proxy.scrollTo(id, anchor:) 编程式滚动",
                    "scrollTargetBehavior(.viewAligned)：iOS 17+ 对齐滚动，实现分页效果",
                    ".containerRelativeFrame：让子视图相对容器定义尺寸",
                    "ScrollView vs List：ScrollView 适合自定义布局，List 适合数据驱动列表"
                ])
            }
            .padding()
        }
        .navigationTitle("ScrollView 滚动视图")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func categoryColor(_ category: String) -> Color {
        switch category {
        case "文学": return .blue
        case "科技": return .green
        case "历史": return .brown
        case "艺术": return .purple
        default: return .orange
        }
    }
}

#Preview {
    NavigationStack {
        ScrollViewDemoView()
    }
}
