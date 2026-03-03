//
//  GridDemoView.swift
//  swiftUILearn
//
//  【知识点】LazyVGrid / LazyHGrid 网格布局
//  场景：书籍封面网格展示（书架视图）
//

import SwiftUI

struct GridDemoView: View {
    // 控制网格列数
    @State private var columnCount: Int = 3
    // 当前选中的书籍
    @State private var selectedBook: BookItem?

    let books = BookItem.sampleData

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                DemoHeader(
                    title: "Grid 网格布局",
                    subtitle: "LazyVGrid 按列排布视图，只渲染可见的单元格，适合展示书籍封面等网格场景。"
                )

                // ── 1. 自适应网格（最常用）──
                GroupBox("📚 书架视图（自适应列宽）") {
                    VStack(spacing: 12) {
                        // 列数控制
                        HStack {
                            Text("每行列数：\(columnCount)")
                                .font(.caption)
                            Spacer()
                            // Stepper 步进器
                            Stepper("", value: $columnCount, in: 2...5)
                                .labelsHidden()
                        }

                        // 构建 GridItem 数组：定义列的规则
                        // .flexible()：列宽弹性填充，列数由 columnCount 决定
                        let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: columnCount)

                        // LazyVGrid：垂直方向延伸的懒加载网格
                        // 只渲染当前可见的格子，性能好
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(books) { book in
                                BookGridCell(book: book, isSelected: selectedBook?.id == book.id)
                                    .onTapGesture {
                                        withAnimation(.spring(duration: 0.2)) {
                                            selectedBook = selectedBook?.id == book.id ? nil : book
                                        }
                                    }
                            }
                        }

                        if let book = selectedBook {
                            Text("已选中：《\(book.title)》")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(8)
                }

                // ── 2. 固定列宽网格 ──
                GroupBox("📏 固定列宽网格") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("每列固定 80pt 宽：")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        // .fixed(width)：每列固定指定宽度
                        LazyVGrid(columns: [
                            GridItem(.fixed(80)),
                            GridItem(.fixed(80)),
                            GridItem(.fixed(80))
                        ], spacing: 8) {
                            ForEach(books.prefix(6)) { book in
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(book.color.gradient)
                                    .frame(height: 60)
                                    .overlay {
                                        Text(book.title)
                                            .font(.caption2)
                                            .foregroundStyle(.white)
                                            .lineLimit(2)
                                            .multilineTextAlignment(.center)
                                            .padding(4)
                                    }
                            }
                        }
                    }
                    .padding(8)
                }

                // ── 3. 自适应宽度网格 ──
                GroupBox("🔄 自适应宽度（最小100pt）") {
                    // .adaptive(minimum:)：让系统根据容器宽度自动决定列数
                    // 每列最小 100pt，自动填充尽可能多的列
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 8) {
                        ForEach(books.prefix(8)) { book in
                            Text(book.title)
                                .font(.caption)
                                .padding(8)
                                .frame(maxWidth: .infinity)
                                .background(book.color.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                    .padding(8)
                }

                ConceptNote(items: [
                    "GridItem(.flexible())：弹性列宽，Array(repeating:count:) 快速创建多列",
                    "GridItem(.fixed(80))：固定列宽",
                    "GridItem(.adaptive(minimum:100))：系统自动决定列数，最常用于响应式布局",
                    "LazyVGrid：垂直延伸，在 ScrollView 中使用，懒加载优化性能",
                    "LazyHGrid：水平延伸，在横向 ScrollView 中使用（分类标签栏）"
                ])
            }
            .padding()
        }
        .navigationTitle("Grid 网格")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 数据模型
struct BookItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let color: Color

    // Color 不支持 Hashable，只用 id 和 title 计算哈希
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: BookItem, rhs: BookItem) -> Bool { lhs.id == rhs.id }

    static let sampleData: [BookItem] = [
        BookItem(title: "活着", color: .red),
        BookItem(title: "三体", color: .blue),
        BookItem(title: "百年孤独", color: .purple),
        BookItem(title: "围城", color: .orange),
        BookItem(title: "平凡的世界", color: .green),
        BookItem(title: "红楼梦", color: .pink),
        BookItem(title: "西游记", color: .yellow),
        BookItem(title: "水浒传", color: .teal),
        BookItem(title: "三国演义", color: .brown),
    ]
}

// MARK: - 书籍网格单元格
private struct BookGridCell: View {
    let book: BookItem
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 4) {
            RoundedRectangle(cornerRadius: 8)
                .fill(book.color.gradient)
                .aspectRatio(0.7, contentMode: .fit)  // 保持封面比例
                .overlay {
                    Image(systemName: "book.fill")
                        .foregroundStyle(.white.opacity(0.6))
                }
                .overlay {
                    // 选中时显示高亮边框
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white, lineWidth: isSelected ? 3 : 0)
                }
                .scaleEffect(isSelected ? 1.05 : 1.0)  // 选中时微微放大

            Text(book.title)
                .font(.caption2)
                .lineLimit(1)
        }
    }
}

#Preview {
    NavigationStack {
        GridDemoView()
    }
}
