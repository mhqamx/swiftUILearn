//
//  SwipeActionsDemoView.swift
//  swiftUILearn
//
//  【知识点】SwipeActions 侧滑操作
//  场景：左滑删除书籍、右滑收藏/借阅
//

import SwiftUI

struct SwipeActionsDemoView: View {
    @State private var books = LibraryBook.sampleData
    @State private var deletedCount = 0

    var body: some View {
        VStack(spacing: 0) {
            DemoHeader(
                title: "Swipe Actions 侧滑",
                subtitle: "为 List 行添加侧滑操作按钮，左滑显示删除等操作，右滑显示快捷功能。"
            )
            .padding()

            List {
                ForEach(books) { book in
                    BookListRow(book: book)
                        // ── 右滑操作（leading edge）──
                        .swipeActions(edge: .leading) {
                            // 收藏按钮
                            Button {
                                toggleFavorite(book: book)
                            } label: {
                                Label(book.isFavorited ? "取消收藏" : "收藏",
                                      systemImage: book.isFavorited ? "heart.slash" : "heart.fill")
                            }
                            // .tint 设置按钮背景色
                            .tint(book.isFavorited ? .gray : .red)

                            // 借阅按钮
                            Button {
                                // 操作反馈
                            } label: {
                                Label("借阅", systemImage: "cart.fill.badge.plus")
                            }
                            .tint(.blue)
                        }
                        // ── 左滑操作（trailing edge，默认）──
                        .swipeActions(edge: .trailing) {
                            // 删除按钮（.destructive 自动显示为红色）
                            Button(role: .destructive) {
                                deleteBook(book: book)
                            } label: {
                                Label("删除", systemImage: "trash.fill")
                            }

                            // 更多按钮
                            Button {
                                // 更多操作
                            } label: {
                                Label("更多", systemImage: "ellipsis.circle.fill")
                            }
                            .tint(.orange)
                        }
                        // allowsFullSwipe：是否允许完整滑动直接触发第一个按钮
                        // false = 必须点击按钮才能触发，防止误操作
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) { }
                }
                // .onDelete：传统删除方式（仅支持左滑删除）
                // .onDelete(perform: deleteBooks)
            }
            .listStyle(.insetGrouped)
            .overlay(alignment: .bottom) {
                if deletedCount > 0 {
                    Text("已删除 \(deletedCount) 本书")
                        .font(.caption)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(.regularMaterial)
                        .clipShape(Capsule())
                        .padding(.bottom, 20)
                }
            }
        }
        .navigationTitle("Swipe Actions")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func toggleFavorite(book: LibraryBook) {
        if let index = books.firstIndex(where: { $0.id == book.id }) {
            books[index].isFavorited.toggle()
        }
    }

    private func deleteBook(book: LibraryBook) {
        books.removeAll { $0.id == book.id }
        deletedCount += 1
    }
}

#Preview {
    NavigationStack {
        SwipeActionsDemoView()
    }
}
