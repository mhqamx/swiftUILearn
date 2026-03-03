//
//  ListSectionDemoView.swift
//  swiftUILearn
//
//  【知识点】List Section 分组
//  场景：按分类展示馆藏书目（文学、科技、历史）
//

import SwiftUI

struct ListSectionDemoView: View {
    // 按分类分组的书籍数据
    let categories: [(String, String, [LibraryBook])] = [
        ("文学小说", "book.fill", [
            LibraryBook(title: "活着", author: "余华", borrowCount: 128, color: .red),
            LibraryBook(title: "围城", author: "钱钟书", borrowCount: 88, color: .orange),
            LibraryBook(title: "百年孤独", author: "马尔克斯", borrowCount: 76, color: .purple),
        ]),
        ("科幻科技", "sparkles", [
            LibraryBook(title: "三体", author: "刘慈欣", borrowCount: 203, color: .blue),
            LibraryBook(title: "人类简史", author: "赫拉利", borrowCount: 156, color: .teal),
        ]),
        ("历史文化", "building.columns.fill", [
            LibraryBook(title: "史记", author: "司马迁", borrowCount: 45, color: .brown),
            LibraryBook(title: "明朝那些事儿", author: "当年明月", borrowCount: 167, color: .green),
        ])
    ]

    var body: some View {
        VStack(spacing: 0) {
            DemoHeader(
                title: "List Section 分组",
                subtitle: "Section 将 List 中的数据分组显示，支持 header 和 footer 标题。"
            )
            .padding()

            List {
                // MARK: Section 基础用法
                // Section(header:) { 行内容 }
                ForEach(categories, id: \.0) { category in
                    Section {
                        // 分组内的行
                        ForEach(category.2) { book in
                            BookListRow(book: book)
                        }
                    } header: {
                        // 自定义 header 视图
                        Label(category.0, systemImage: category.1)
                            .font(.footnote.bold())
                            .foregroundStyle(.primary)
                            .textCase(nil)  // 取消系统自动大写
                    } footer: {
                        // footer：显示分组摘要
                        Text("共 \(category.2.count) 本，合计借出 \(category.2.map(\.borrowCount).reduce(0, +)) 次")
                            .font(.caption2)
                    }
                }
            }
            .listStyle(.insetGrouped)
        }
        .navigationTitle("Section 分组")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ListSectionDemoView()
    }
}
