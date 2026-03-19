//
//  ObservableMacroDemoView.swift
//  swiftUILearn
//
//  【知识点】@Observable 宏
//  场景：对比旧写法，展示 @Observable 的精细更新和 @Bindable
//

import SwiftUI

// MARK: - @Observable 新写法
@Observable
class BookManager {
    var books: [String] = ["SwiftUI 实战", "Swift 编程语言", "设计模式"]
    var selectedBook: String = ""
    var readingProgress: Double = 0.3

    func addBook(_ name: String) {
        books.append(name)
    }

    func removeBook(at offsets: IndexSet) {
        books.remove(atOffsets: offsets)
    }
}

struct ObservableMacroDemoView: View {
    @State private var manager = BookManager()
    @State private var newBookName = ""
    @State private var updateCount = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                DemoHeader(
                    title: "@Observable 宏",
                    subtitle: "@Observable 是 iOS 17+ 引入的新观察机制，替代 ObservableObject，提供更精细的视图更新。"
                )

                // ── 1. 新旧写法对比 ──
                GroupBox("🆕 新旧写法对比") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("ObservableObject 旧写法")
                            .font(.subheadline.bold())
                            .foregroundStyle(.orange)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("class MyModel: ObservableObject {")
                            Text("    @Published var name = \"\"")
                            Text("}")
                            Text("")
                            Text("@StateObject var model = MyModel()")
                        }
                        .font(.caption.monospaced())
                        .foregroundStyle(.secondary)
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.orange.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                        Text("@Observable 新写法")
                            .font(.subheadline.bold())
                            .foregroundStyle(.green)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("@Observable")
                            Text("class MyModel {")
                            Text("    var name = \"\"  // 无需 @Published")
                            Text("}")
                            Text("")
                            Text("@State var model = MyModel()")
                        }
                        .font(.caption.monospaced())
                        .foregroundStyle(.secondary)
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.green.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                        Text("✅ 不再需要 @Published、@StateObject、@ObservedObject")
                            .font(.caption)
                            .foregroundStyle(.green)
                    }
                    .padding(8)
                }

                // ── 2. 图书管理器 ──
                GroupBox("📚 图书管理器") {
                    VStack(spacing: 12) {
                        HStack {
                            TextField("新书名称", text: $newBookName)
                                .textFieldStyle(.roundedBorder)

                            Button {
                                if !newBookName.isEmpty {
                                    manager.addBook(newBookName)
                                    newBookName = ""
                                }
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title3)
                            }
                            .disabled(newBookName.isEmpty)
                        }

                        ForEach(manager.books, id: \.self) { book in
                            HStack {
                                Image(systemName: "book.fill")
                                    .foregroundStyle(.blue)
                                Text(book)
                                    .font(.subheadline)
                                Spacer()
                            }
                            .padding(8)
                            .background(Color.blue.opacity(0.05))
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                        }

                        Text("共 \(manager.books.count) 本书")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(8)
                }

                // ── 3. @Bindable ──
                GroupBox("🔗 @Bindable 双向绑定") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("@Bindable 可以从 @Observable 对象创建绑定")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        BindableSubView(manager: manager)
                    }
                    .padding(8)
                }

                // ── 4. 精细更新 ──
                GroupBox("⚡️ 精细更新优势") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("@Observable 只在读取了变化属性的视图才会重新渲染")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        HStack(spacing: 16) {
                            // 只读取 readingProgress 的视图
                            ProgressOnlyView(manager: manager)

                            // 只读取 books.count 的视图
                            CountOnlyView(manager: manager)
                        }

                        Slider(value: $manager.readingProgress, in: 0...1)

                        Text("拖动滑块只会更新左侧进度视图，不会影响右侧计数视图")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    .padding(8)
                }

                ConceptNote(items: [
                    "@Observable：iOS 17+ 宏，自动追踪属性访问，无需 @Published",
                    "@State var model：替代 @StateObject，用于拥有 @Observable 对象",
                    "@Bindable：从 @Observable 对象创建 $ 绑定",
                    "精细更新：只有读取了变化属性的视图才重新渲染，性能更优",
                    "ObservableObject：旧方案，任何 @Published 变化都会通知所有观察者"
                ])
            }
            .padding()
        }
        .navigationTitle("@Observable 宏")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - @Bindable 子视图
private struct BindableSubView: View {
    @Bindable var manager: BookManager

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField("选择的书籍", text: $manager.selectedBook)
                .textFieldStyle(.roundedBorder)

            Text("当前选择：\(manager.selectedBook.isEmpty ? "未选择" : manager.selectedBook)")
                .font(.caption)
                .foregroundStyle(.orange)

            HStack {
                Text("阅读进度")
                    .font(.caption)
                Slider(value: $manager.readingProgress, in: 0...1)
                Text("\(Int(manager.readingProgress * 100))%")
                    .font(.caption.bold())
            }
        }
    }
}

// MARK: - 精细更新演示视图
private struct ProgressOnlyView: View {
    let manager: BookManager

    var body: some View {
        VStack {
            ProgressView(value: manager.readingProgress)
                .frame(width: 100)
            Text("\(Int(manager.readingProgress * 100))%")
                .font(.caption.bold())
            Text("进度视图")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private struct CountOnlyView: View {
    let manager: BookManager

    var body: some View {
        VStack {
            Text("\(manager.books.count)")
                .font(.title.bold())
                .foregroundStyle(.blue)
            Text("本书")
                .font(.caption)
            Text("计数视图")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    NavigationStack {
        ObservableMacroDemoView()
    }
}
