//
//  ListBasicsDemoView.swift
//  swiftUILearn
//
//  【知识点】List 基础
//  场景：图书馆馆藏书目列表
//

import SwiftUI

struct ListBasicsDemoView: View {
    let books = LibraryBook.sampleData
    @State private var styleIndex = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                DemoHeader(
                    title: "List 基础",
                    subtitle: "List 是展示可滚动数据列表的核心视图，支持多种样式，性能优于 ScrollView + ForEach。"
                )

                // ── 1. 最基础的 List ──
                GroupBox("📋 基础 List 写法") {
                    // List(数据) { 元素 in 行视图 }
                    // 数据需遵循 Identifiable 协议
                    List(books.prefix(3)) { book in
                        // 行内容是任意 View
                        HStack {
                            Text(book.title)
                            Spacer()
                            Text(book.author)
                                .foregroundStyle(.secondary)
                                .font(.caption)
                        }
                    }
                    // List 默认会撑开，需要固定高度
                    .frame(height: 140)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                // ── 2. List 样式 ──
                GroupBox("🎨 三种内置样式") {
                    VStack(alignment: .leading, spacing: 12) {
                        StyleRow(name: ".plain", desc: "最简单，无背景分组")
                        StyleRow(name: ".inset", desc: "带内边距，iOS 15+ 默认")
                        StyleRow(name: ".insetGrouped", desc: "分组 + 内边距，最常用")
                        StyleRow(name: ".grouped", desc: "带分组标题的传统样式")
                        StyleRow(name: ".sidebar", desc: "侧边栏样式（iPad/Mac）")
                    }
                    .padding(8)
                }

                // ── 3. 完整书单列表 ──
                GroupBox("📚 完整书单示例") {
                    List(books) { book in
                        BookListRow(book: book)
                    }
                    .frame(height: 280)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                // ── 4. ForEach vs List ──
                GroupBox("🔄 ForEach 在 List 中") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("List 内部使用 ForEach 可以混合静态和动态内容：")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        List {
                            // 静态行
                            Text("📌 馆长推荐").bold()

                            // 动态行（ForEach）
                            ForEach(books.prefix(3)) { book in
                                Label(book.title, systemImage: "book")
                            }

                            // 再加一个静态行
                            Text("查看更多...").foregroundStyle(.blue)
                        }
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .padding(8)
                }

                ConceptNote(items: [
                    "List(data) { item in ... }：最简写法，data 需遵循 Identifiable",
                    ".listStyle(.insetGrouped)：最常用的分组样式",
                    "List 内可混合 ForEach 和静态 View",
                    "List 性能优于 ScrollView + LazyVStack：系统级优化",
                    ".listRowInsets()：自定义行内边距"
                ])
            }
            .padding()
        }
        .navigationTitle("List 基础")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 样式说明行
private struct StyleRow: View {
    let name: String
    let desc: String

    var body: some View {
        HStack {
            Text(name)
                .font(.caption.monospaced())
                .foregroundStyle(.orange)
            Text(desc)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - 书籍列表行
struct BookListRow: View {
    let book: LibraryBook

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 4)
                .fill(book.color.gradient)
                .frame(width: 36, height: 48)
                .overlay {
                    Image(systemName: "book.fill")
                        .font(.caption2)
                        .foregroundStyle(.white)
                }

            VStack(alignment: .leading, spacing: 3) {
                Text(book.title).font(.headline)
                Text(book.author).font(.subheadline).foregroundStyle(.secondary)
                Text("借出 \(book.borrowCount) 次")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }

            Spacer()

            Image(systemName: book.isFavorited ? "heart.fill" : "heart")
                .foregroundStyle(book.isFavorited ? .red : .secondary)
                .font(.footnote)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        ListBasicsDemoView()
    }
}
