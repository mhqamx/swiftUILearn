//
//  NavigationStackDemoView.swift
//  swiftUILearn
//
//  【知识点】NavigationStack 栈式导航
//  场景：书籍列表 → 书籍详情 → 作者信息 多级跳转
//

import SwiftUI

struct NavigationStackDemoView: View {
    // NavigationPath 管理导航栈（支持程序化导航）
    @State private var navigationPath = NavigationPath()

    let books = BookItem.sampleData

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // DemoHeader 放在 NavigationStack 外面
            DemoHeader(
                title: "NavigationStack",
                subtitle: "NavigationStack 管理页面栈，NavigationLink 触发跳转，支持程序化导航。"
            )
            .padding()

            // NavigationStack：整个导航容器
            // 传入 path 参数启用程序化导航
            NavigationStack(path: $navigationPath) {
                List(books) { book in
                    // NavigationLink(destination: 目标视图) { 触发视图 }
                    NavigationLink {
                        BookDetailView(book: book)
                    } label: {
                        BookNavRow(book: book)
                    }
                }
                .listStyle(.insetGrouped)
                .navigationTitle("馆藏书目")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        // 程序化跳转：直接 push 目标页面
                        Button("随机推荐") {
                            if let random = books.randomElement() {
                                print("navigationPath：《\(navigationPath)》")
                                navigationPath.append(random)
                            }
                        }
                    }
                }
                // navigationDestination：注册可跳转的目标类型
                // 当 navigationPath 中有 BookItem 类型时，渲染此视图
                .navigationDestination(for: BookItem.self) { book in
                    BookDetailView(book: book)
                }
            }
        }
        .navigationTitle("NavigationStack")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 书籍详情页
private struct BookDetailView: View {
    let book: BookItem
    @Environment(\.dismiss) private var dismiss  // 获取 dismiss 动作

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 封面
                RoundedRectangle(cornerRadius: 16)
                    .fill(book.color.gradient)
                    .frame(width: 120, height: 160)
                    .overlay {
                        Image(systemName: "book.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                    }
                    .shadow(radius: 8)

                Text("《\(book.title)》")
                    .font(.title.bold())

                // 跳转到更深一层：作者信息页
                NavigationLink("查看作者信息 →") {
                    AuthorInfoView(bookTitle: book.title)
                }
                .buttonStyle(.borderedProminent)

                // 手动返回（等同于点击导航栏返回按钮）
                Button("返回书单") {
                    dismiss()
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
        .navigationTitle(book.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 作者信息页（第三层）
private struct AuthorInfoView: View {
    let bookTitle: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(.blue)

            Text("作者信息")
                .font(.title.bold())

            Text("《\(bookTitle)》的作者信息页面\n这是导航栈的第三层")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
        .navigationTitle("作者信息")
    }
}

// MARK: - 列表行
private struct BookNavRow: View {
    let book: BookItem

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 6)
                .fill(book.color.gradient)
                .frame(width: 40, height: 52)
                .overlay {
                    Image(systemName: "book.fill")
                        .font(.caption)
                        .foregroundStyle(.white)
                }
            VStack(alignment: .leading, spacing: 2) {
                Text(book.title).font(.headline)
                Text("点击查看详情").font(.caption).foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStackDemoView()
}
