//
//  MatchedGeometryDemoView.swift
//  swiftUILearn
//
//  【知识点】matchedGeometryEffect
//  场景：书籍封面从列表到详情的共享元素过渡动画
//

import SwiftUI

struct MatchedGeometryDemoView: View {
    // Namespace 用于标记配对的视图
    @Namespace private var bookTransition
    @State private var selectedBookId: String? = nil

    let books = ["活着", "三体", "百年孤独", "围城"]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            DemoHeader(
                title: "matchedGeometryEffect",
                subtitle: "让同一元素在两个位置之间平滑过渡，实现共享元素动画（英雄动画）。"
            )
            .padding()

            ZStack {
                // ── 书籍网格（默认视图）──
                if selectedBookId == nil {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("点击书籍封面查看详情")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .padding(.horizontal)

                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 16) {
                                ForEach(books, id: \.self) { title in
                                    BookCoverCell(
                                        title: title,
                                        namespace: bookTransition,
                                        isSelected: false
                                    )
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                            selectedBookId = title
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
                    }
                    .transition(.opacity)
                }

                // ── 书籍详情（选中后视图）──
                if let bookId = selectedBookId {
                    BookDetailExpanded(
                        title: bookId,
                        namespace: bookTransition
                    ) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            selectedBookId = nil
                        }
                    }
                    .transition(.opacity)
                }
            }
        }
        .navigationTitle("MatchedGeometry")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 书籍封面（网格中的小卡片）
private struct BookCoverCell: View {
    let title: String
    let namespace: Namespace.ID
    let isSelected: Bool

    var color: Color {
        let colors: [Color] = [.red, .blue, .purple, .orange, .green, .teal]
        return colors[abs(title.hashValue) % colors.count]
    }

    var body: some View {
        VStack(spacing: 6) {
            RoundedRectangle(cornerRadius: 12)
                .fill(color.gradient)
                .frame(height: 120)
                // matchedGeometryEffect(id:in:)：
                // id：唯一标识符（同一个 id 的两个视图会配对过渡）
                // in：命名空间（隔离不同动画组）
                .matchedGeometryEffect(id: "cover-\(title)", in: namespace)
                .overlay {
                    Image(systemName: "book.fill")
                        .foregroundStyle(.white.opacity(0.6))
                }

            Text(title)
                .font(.caption.bold())
                .matchedGeometryEffect(id: "title-\(title)", in: namespace)
        }
    }
}

// MARK: - 书籍详情展开视图
private struct BookDetailExpanded: View {
    let title: String
    let namespace: Namespace.ID
    let onDismiss: () -> Void

    var color: Color {
        let colors: [Color] = [.red, .blue, .purple, .orange, .green, .teal]
        return colors[abs(title.hashValue) % colors.count]
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // 封面（与网格中的封面使用相同的 matchedGeometryEffect id）
                RoundedRectangle(cornerRadius: 0)
                    .fill(color.gradient)
                    .frame(height: 280)
                    .matchedGeometryEffect(id: "cover-\(title)", in: namespace)
                    .overlay(alignment: .bottom) {
                        LinearGradient(
                            colors: [.clear, .black.opacity(0.4)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    }
                    .ignoresSafeArea(edges: .top)

                VStack(alignment: .leading, spacing: 16) {
                    Text("《\(title)》")
                        .font(.title.bold())
                        .matchedGeometryEffect(id: "title-\(title)", in: namespace)

                    Text("这是书籍的详细介绍内容，包括作者、出版信息、内容简介等。通过 matchedGeometryEffect，封面和书名从列表位置平滑过渡到这个详情页面。")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .lineSpacing(6)
                }
                .padding()
            }
        }
        .ignoresSafeArea(edges: .top)
        .overlay(alignment: .topTrailing) {
            Button {
                onDismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .background(Circle().fill(.black.opacity(0.3)))
            }
            .padding()
        }
    }
}

#Preview {
    NavigationStack {
        MatchedGeometryDemoView()
    }
}
