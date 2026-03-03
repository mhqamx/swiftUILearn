//
//  ObservableDemoView.swift
//  swiftUILearn
//
//  【知识点】@StateObject / @ObservedObject
//  场景：图书馆 ViewModel 管理书单数据
//

import SwiftUI
import Combine

// MARK: - ViewModel（数据模型）
// ObservableObject：标记这个类可以被 SwiftUI 视图观察
// 当 @Published 属性变化时，所有观察它的视图自动重绘
class BookListViewModel: ObservableObject {

    // @Published：被修改时通知所有观察者（视图）
    @Published var books: [LibraryBook] = []
    @Published var isLoading = false
    @Published var searchText = ""

    // 计算属性：根据搜索词过滤书籍
    var filteredBooks: [LibraryBook] {
        if searchText.isEmpty { return books }
        return books.filter { $0.title.contains(searchText) || $0.author.contains(searchText) }
    }

    init() {
        // 模拟从数据库加载书籍
        loadBooks()
    }

    func loadBooks() {
        isLoading = true
        // 模拟网络延迟（实际项目使用 async/await）
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.books = LibraryBook.sampleData
            self.isLoading = false
        }
    }

    func toggleFavorite(book: LibraryBook) {
        // 找到对应书籍并切换收藏状态
        if let index = books.firstIndex(where: { $0.id == book.id }) {
            books[index].isFavorited.toggle()
        }
    }

    func addBook(title: String, author: String) {
        let newBook = LibraryBook(title: title, author: author)
        books.append(newBook)
    }
}

// MARK: - 数据模型
struct LibraryBook: Identifiable {
    let id = UUID()
    var title: String
    var author: String
    var isFavorited: Bool = false
    var borrowCount: Int = Int.random(in: 0...200)
    var color: Color = .blue  // 封面主题色
}

extension LibraryBook {
    static let sampleData = [
        LibraryBook(title: "活着", author: "余华", isFavorited: true, borrowCount: 128, color: .red),
        LibraryBook(title: "三体", author: "刘慈欣", borrowCount: 203, color: .blue),
        LibraryBook(title: "百年孤独", author: "马尔克斯", borrowCount: 76, color: .purple),
        LibraryBook(title: "围城", author: "钱钟书", borrowCount: 88, color: .orange),
        LibraryBook(title: "平凡的世界", author: "路遥", borrowCount: 112, color: .green),
        LibraryBook(title: "红楼梦", author: "曹雪芹", borrowCount: 94, color: .pink),
        LibraryBook(title: "西游记", author: "吴承恩", borrowCount: 67, color: .teal),
    ]
}

// MARK: - 主视图
struct ObservableDemoView: View {
    // @StateObject：在本视图中创建并拥有 ViewModel 实例
    // 视图销毁时，ViewModel 也会被销毁
    // ⚠️ 只在创建者视图中使用 @StateObject，传给子视图时用 @ObservedObject
    @StateObject private var viewModel = BookListViewModel()
    @State private var showAddSheet = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                DemoHeader(
                    title: "@StateObject / @ObservedObject",
                    subtitle: "将复杂状态抽取到 ViewModel（ObservableObject），实现视图与数据逻辑的分离。"
                )

                // 加载状态
                if viewModel.isLoading {
                    GroupBox {
                        HStack {
                            ProgressView()
                            Text("正在加载书单...").font(.footnote).foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(8)
                    }
                } else {
                    // ── 书单列表 ──
                    GroupBox("📚 馆藏书单（\(viewModel.books.count) 本）") {
                        VStack(spacing: 0) {
                            // 搜索框绑定 ViewModel 的 @Published 属性
                            TextField("搜索书名或作者", text: $viewModel.searchText)
                                .textFieldStyle(.roundedBorder)
                                .padding(.bottom, 8)

                            ForEach(viewModel.filteredBooks) { book in
                                // 将 viewModel 传给子视图（使用 @ObservedObject）
                                BookRowView(book: book) {
                                    viewModel.toggleFavorite(book: book)
                                }
                                Divider()
                            }

                            if viewModel.filteredBooks.isEmpty {
                                Text("没有找到相关书籍")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            }
                        }
                        .padding(8)
                    }

                    // 添加书籍按钮
                    Button {
                        viewModel.addBook(title: "新书 #\(viewModel.books.count + 1)", author: "佚名")
                    } label: {
                        Label("新增一本书（演示实时更新）", systemImage: "plus")
                    }
                    .buttonStyle(.bordered)
                    .frame(maxWidth: .infinity)
                }

                ConceptNote(items: [
                    "@StateObject：在视图中创建 ViewModel，视图拥有其生命周期",
                    "@ObservedObject：子视图观察已有 ViewModel，不负责创建",
                    "ObservableObject：协议，标记类可被 SwiftUI 观察",
                    "@Published：属性变化时自动通知观察者重绘",
                    "ViewModel 职责：业务逻辑 + 数据处理，视图只负责显示"
                ])
            }
            .padding()
        }
        .navigationTitle("@StateObject")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 书籍行子视图
// 接收回调而非直接持有 ViewModel，更符合单一职责
private struct BookRowView: View {
    let book: LibraryBook
    let onToggleFavorite: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(book.title).font(.headline)
                Text(book.author).font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Text("借出 \(book.borrowCount) 次")
                .font(.caption2)
                .foregroundStyle(.tertiary)
            Button {
                onToggleFavorite()
            } label: {
                Image(systemName: book.isFavorited ? "heart.fill" : "heart")
                    .foregroundStyle(book.isFavorited ? .red : .gray)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    NavigationStack {
        ObservableDemoView()
    }
}
