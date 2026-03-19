//
//  SwiftDataDemoView.swift
//  swiftUILearn
//
//  【知识点】SwiftData 基础
//  场景：使用 SwiftData 管理书籍数据的增删改查
//

import SwiftUI
import SwiftData

// MARK: - SwiftData 模型
@Model
class SwiftDataBook {
    var title: String
    var author: String
    var rating: Int
    var isRead: Bool
    var addedDate: Date

    init(title: String, author: String, rating: Int = 0, isRead: Bool = false) {
        self.title = title
        self.author = author
        self.rating = rating
        self.isRead = isRead
        self.addedDate = Date()
    }
}

struct SwiftDataDemoView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \SwiftDataBook.addedDate, order: .reverse) private var books: [SwiftDataBook]
    @State private var showAddSheet = false
    @State private var searchText = ""
    @State private var filterRead: Bool? = nil
    @State private var sortByRating = false

    var filteredBooks: [SwiftDataBook] {
        var result = books
        if !searchText.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.author.localizedCaseInsensitiveContains(searchText)
            }
        }
        if let filterRead {
            result = result.filter { $0.isRead == filterRead }
        }
        if sortByRating {
            result = result.sorted { $0.rating > $1.rating }
        }
        return result
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                DemoHeader(
                    title: "SwiftData 基础",
                    subtitle: "SwiftData 是 Apple 推出的现代数据持久化框架，用 @Model 宏替代 CoreData 的 Entity，更加 Swift 原生。"
                )

                // ── 1. @Model 定义 ──
                GroupBox("🆕 @Model 定义") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("对比 CoreData Entity")
                            .font(.subheadline.bold())

                        VStack(alignment: .leading, spacing: 4) {
                            Text("// CoreData 需要 .xcdatamodeld 文件")
                            Text("// SwiftData 直接用 Swift 代码：")
                            Text("")
                            Text("@Model")
                            Text("class SwiftDataBook {")
                            Text("    var title: String")
                            Text("    var author: String")
                            Text("    var rating: Int")
                            Text("}")
                        }
                        .font(.caption.monospaced())
                        .foregroundStyle(.secondary)
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.blue.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                        Text("✅ 无需 .xcdatamodeld、无需 NSManagedObject 子类")
                            .font(.caption)
                            .foregroundStyle(.green)
                    }
                    .padding(8)
                }

                // ── 2. 增删改查 ──
                GroupBox("📝 增删改查") {
                    VStack(spacing: 12) {
                        HStack {
                            Text("书架 (\(books.count) 本)")
                                .font(.subheadline.bold())
                            Spacer()
                            Button {
                                showAddSheet = true
                            } label: {
                                Label("添加", systemImage: "plus.circle.fill")
                                    .font(.caption)
                            }
                            .buttonStyle(.borderedProminent)
                        }

                        if books.isEmpty {
                            VStack(spacing: 8) {
                                Image(systemName: "books.vertical")
                                    .font(.largeTitle)
                                    .foregroundStyle(.gray)
                                Text("书架空空如也，添加一本书吧")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)

                                Button("添加示例数据") {
                                    addSampleData()
                                }
                                .font(.caption)
                                .buttonStyle(.bordered)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                        }

                        ForEach(filteredBooks) { book in
                            SwiftDataBookRow(book: book) {
                                modelContext.delete(book)
                            }
                        }
                    }
                    .padding(8)
                }

                // ── 3. 查询与排序 ──
                GroupBox("🔍 查询与筛选") {
                    VStack(spacing: 12) {
                        TextField("搜索书名或作者", text: $searchText)
                            .textFieldStyle(.roundedBorder)

                        HStack {
                            Text("筛选：")
                                .font(.caption)

                            Button {
                                filterRead = nil
                            } label: {
                                Text("全部")
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(filterRead == nil ? Color.blue : Color.gray.opacity(0.2))
                                    .foregroundStyle(filterRead == nil ? .white : .primary)
                                    .clipShape(Capsule())
                            }

                            Button {
                                filterRead = true
                            } label: {
                                Text("已读")
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(filterRead == true ? Color.green : Color.gray.opacity(0.2))
                                    .foregroundStyle(filterRead == true ? .white : .primary)
                                    .clipShape(Capsule())
                            }

                            Button {
                                filterRead = false
                            } label: {
                                Text("未读")
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(filterRead == false ? Color.orange : Color.gray.opacity(0.2))
                                    .foregroundStyle(filterRead == false ? .white : .primary)
                                    .clipShape(Capsule())
                            }

                            Spacer()

                            Toggle(isOn: $sortByRating) {
                                Text("按评分")
                                    .font(.caption)
                            }
                            .toggleStyle(.button)
                            .buttonStyle(.bordered)
                        }

                        Text("匹配 \(filteredBooks.count) 本书")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(8)
                }

                // ── 4. @Query 说明 ──
                GroupBox("📋 @Query 自动刷新") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("@Query 会自动监听数据变化并刷新视图")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("@Query(sort: \\SwiftDataBook.addedDate,")
                            Text("       order: .reverse)")
                            Text("private var books: [SwiftDataBook]")
                        }
                        .font(.caption.monospaced())
                        .foregroundStyle(.orange)
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.orange.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                        Text("• insert/delete 后视图自动刷新，无需手动通知")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("• 支持 SortDescriptor 和 #Predicate 过滤")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(8)
                }

                ConceptNote(items: [
                    "@Model：SwiftData 的核心宏，替代 CoreData 的 NSManagedObject",
                    "modelContext：用于 insert/delete/save 操作",
                    "@Query：自动查询并监听数据变化，驱动视图更新",
                    "SortDescriptor：排序描述符，支持多字段排序",
                    "#Predicate：类型安全的查询谓词，替代 NSPredicate",
                    ".modelContainer(for:)：在 App 入口配置数据容器"
                ])
            }
            .padding()
        }
        .navigationTitle("SwiftData 基础")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showAddSheet) {
            AddSwiftDataBookSheet()
        }
    }

    private func addSampleData() {
        let samples = [
            SwiftDataBook(title: "SwiftUI 实战", author: "苹果开发者", rating: 5, isRead: true),
            SwiftDataBook(title: "Swift 编程语言", author: "Apple Inc.", rating: 4, isRead: true),
            SwiftDataBook(title: "设计模式", author: "GoF", rating: 3, isRead: false),
            SwiftDataBook(title: "算法导论", author: "CLRS", rating: 4, isRead: false),
            SwiftDataBook(title: "代码大全", author: "Steve McConnell", rating: 5, isRead: false)
        ]
        for book in samples {
            modelContext.insert(book)
        }
    }
}

// MARK: - 书籍行
private struct SwiftDataBookRow: View {
    let book: SwiftDataBook
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: book.isRead ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(book.isRead ? .green : .gray)
                .onTapGesture {
                    book.isRead.toggle()
                }

            VStack(alignment: .leading, spacing: 2) {
                Text(book.title)
                    .font(.subheadline)
                    .strikethrough(book.isRead)
                Text(book.author)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            HStack(spacing: 2) {
                ForEach(1...5, id: \.self) { star in
                    Image(systemName: star <= book.rating ? "star.fill" : "star")
                        .font(.caption2)
                        .foregroundStyle(star <= book.rating ? .yellow : .gray.opacity(0.3))
                        .onTapGesture {
                            book.rating = star
                        }
                }
            }

            Button(role: .destructive) {
                withAnimation { onDelete() }
            } label: {
                Image(systemName: "trash")
                    .font(.caption)
            }
        }
        .padding(10)
        .background(Color.blue.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - 添加书籍页
private struct AddSwiftDataBookSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3

    var body: some View {
        NavigationStack {
            Form {
                Section("书籍信息") {
                    TextField("书名", text: $title)
                    TextField("作者", text: $author)
                    Stepper("评分：\(rating) 星", value: $rating, in: 1...5)
                }
            }
            .navigationTitle("添加书籍")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("添加") {
                        let book = SwiftDataBook(title: title, author: author, rating: rating)
                        modelContext.insert(book)
                        dismiss()
                    }
                    .disabled(title.isEmpty || author.isEmpty)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SwiftDataDemoView()
    }
    .modelContainer(for: SwiftDataBook.self, inMemory: true)
}
