//
//  ImageDemoView.swift
//  swiftUILearn
//
//  【知识点】Image 图片视图
//  场景：书籍封面与分类图标展示
//

import SwiftUI

struct ImageDemoView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                DemoHeader(
                    title: "Image 图片视图",
                    subtitle: "Image 用于展示图片和 SF Symbols 系统图标，是构建 UI 的重要基础。"
                )

                // ── 1. SF Symbols 系统图标 ──
                GroupBox("🔤 SF Symbols 系统图标") {
                    VStack(spacing: 16) {
                        Text("Apple 提供了数千个免费矢量图标，使用 systemName 引用")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        // 图书馆相关图标展示
                        HStack(spacing: 20) {
                            IconItem(name: "book.fill", label: "书籍", color: .blue)
                            IconItem(name: "bookmark.fill", label: "书签", color: .orange)
                            IconItem(name: "person.2.fill", label: "读者", color: .green)
                            IconItem(name: "magnifyingglass", label: "搜索", color: .purple)
                            IconItem(name: "cart.fill", label: "借阅", color: .red)
                        }
                    }
                    .padding(8)
                }

                // ── 2. 图标大小控制 ──
                GroupBox("📐 图标大小控制") {
                    HStack(spacing: 24) {
                        VStack {
                            // .font() 控制 SF Symbol 的大小
                            Image(systemName: "book.fill")
                                .font(.caption)
                            Text(".caption").font(.caption2).foregroundStyle(.secondary)
                        }
                        VStack {
                            Image(systemName: "book.fill")
                                .font(.title2)
                            Text(".title2").font(.caption2).foregroundStyle(.secondary)
                        }
                        VStack {
                            Image(systemName: "book.fill")
                                .font(.system(size: 48))
                            Text("48pt").font(.caption2).foregroundStyle(.secondary)
                        }
                        VStack {
                            // .imageScale() 专门用于 SF Symbol 缩放
                            Image(systemName: "book.fill")
                                .imageScale(.large)
                                .font(.title)
                            Text(".large").font(.caption2).foregroundStyle(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(8)
                }

                // ── 3. 多色渲染模式 ──
                GroupBox("🎨 渲染模式") {
                    HStack(spacing: 24) {
                        VStack(spacing: 6) {
                            // .monochrome：单色（默认）
                            Image(systemName: "bookmark.fill")
                                .font(.largeTitle)
                                .symbolRenderingMode(.monochrome)
                                .foregroundStyle(.orange)
                            Text("单色").font(.caption2)
                        }
                        VStack(spacing: 6) {
                            // .multicolor：系统多色
                            Image(systemName: "star.fill")
                                .font(.largeTitle)
                                .symbolRenderingMode(.multicolor)
                            Text("多色").font(.caption2)
                        }
                        VStack(spacing: 6) {
                            // .hierarchical：层级渲染（主色 + 透明度变化）
                            Image(systemName: "books.vertical.fill")
                                .font(.largeTitle)
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(.brown)
                            Text("层级").font(.caption2)
                        }
                        VStack(spacing: 6) {
                            // .palette：双色调色板
                            Image(systemName: "person.crop.circle.fill.badge.checkmark")
                                .font(.largeTitle)
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.white, .green)
                            Text("双色").font(.caption2)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(8)
                }

                // ── 4. 模拟书籍封面（用颜色矩形代替真实图片）──
                GroupBox("🖼 书籍封面（resizable 用法）") {
                    HStack(spacing: 12) {
                        ForEach(mockBooks, id: \.title) { book in
                            BookCoverView(book: book)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(8)
                }

                ConceptNote(items: [
                    "Image(systemName:)：引用 SF Symbols 系统图标",
                    ".font()：控制 SF Symbol 大小，因为图标本质是字形",
                    ".symbolRenderingMode()：设置图标渲染模式（单色/多色/层级）",
                    ".resizable()：让图片可缩放，必须配合 .frame() 或 .scaledToFit() 使用",
                    ".scaledToFit() / .scaledToFill()：等比缩放适应/填充容器"
                ])
            }
            .padding()
        }
        .navigationTitle("Image 图片")
        .navigationBarTitleDisplayMode(.inline)
    }

    // 示例书籍数据
    private let mockBooks = [
        MockBook(title: "活着", color: .red),
        MockBook(title: "三体", color: .blue),
        MockBook(title: "百年孤独", color: .yellow),
        MockBook(title: "围城", color: .green)
    ]
}

// MARK: - 子视图

private struct IconItem: View {
    let name: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: name)
                .font(.title2)
                .foregroundStyle(color)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
}

private struct MockBook {
    let title: String
    let color: Color
}

private struct BookCoverView: View {
    let book: MockBook

    var body: some View {
        VStack(spacing: 4) {
            // 用颜色矩形模拟书籍封面
            RoundedRectangle(cornerRadius: 6)
                .fill(book.color.gradient)
                .frame(width: 60, height: 80)
                .overlay {
                    Image(systemName: "book.fill")
                        .foregroundStyle(.white.opacity(0.8))
                }
                .shadow(radius: 2)
            Text(book.title)
                .font(.caption2)
                .lineLimit(1)
        }
    }
}

#Preview {
    NavigationStack {
        ImageDemoView()
    }
}
