//
//  FileManagerDemoView.swift
//  swiftUILearn
//
//  【知识点】FileManager 文件读写
//  场景：将书单保存为本地 JSON 文件
//

import SwiftUI

// MARK: - 文件操作工具类
class BookFileManager {
    // 获取沙盒文档目录路径
    // iOS 应用只能访问自己的沙盒目录
    static var documentsURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    static var booklistURL: URL {
        documentsURL.appendingPathComponent("booklist.json")
    }

    // 将书单保存为 JSON 文件
    static func saveBooks(_ books: [SimpleBook]) throws {
        let data = try JSONEncoder().encode(books)
        try data.write(to: booklistURL, options: .atomicWrite)  // 原子写入，防止写入失败导致文件损坏
    }

    // 从 JSON 文件读取书单
    static func loadBooks() throws -> [SimpleBook] {
        guard FileManager.default.fileExists(atPath: booklistURL.path) else {
            return []  // 文件不存在时返回空数组
        }
        let data = try Data(contentsOf: booklistURL)
        return try JSONDecoder().decode([SimpleBook].self, from: data)
    }

    // 删除文件
    static func deleteFile() throws {
        try FileManager.default.removeItem(at: booklistURL)
    }

    // 获取文件大小（字节）
    static func fileSize() -> Int64 {
        guard let attrs = try? FileManager.default.attributesOfItem(atPath: booklistURL.path),
              let size = attrs[.size] as? Int64 else { return 0 }
        return size
    }
}

// MARK: - 简单书籍模型（Codable 支持 JSON 编解码）
struct SimpleBook: Identifiable, Codable {
    let id: UUID
    var title: String
    var author: String
    var addedDate: Date

    init(title: String, author: String) {
        self.id = UUID()
        self.title = title
        self.author = author
        self.addedDate = Date()
    }
}

// MARK: - Demo 视图
struct FileManagerDemoView: View {
    @State private var books: [SimpleBook] = []
    @State private var newTitle = ""
    @State private var newAuthor = ""
    @State public var statusMessage = ""
    @State private var fileSize: Int64 = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                DemoHeader(
                    title: "FileManager 文件读写",
                    subtitle: "FileManager 读写本地文件。结合 Codable，可以将数据结构序列化为 JSON 持久保存。"
                )

                // ── 文件信息 ──
                GroupBox("📁 文件信息") {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("保存路径：")
                                .font(.caption).foregroundStyle(.secondary)
                            Text("Documents/booklist.json")
                                .font(.caption.monospaced())
                                .foregroundStyle(.blue)
                        }
                        HStack {
                            Text("文件大小：")
                                .font(.caption).foregroundStyle(.secondary)
                            Text(fileSize > 0 ? "\(fileSize) bytes" : "文件不存在")
                                .font(.caption.monospaced())
                                .foregroundStyle(fileSize > 0 ? .green : .secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                }

                // ── 新增书籍 ──
                GroupBox("➕ 新增书籍") {
                    VStack(spacing: 10) {
                        TextField("书名", text: $newTitle)
                            .textFieldStyle(.roundedBorder)
                        TextField("作者", text: $newAuthor)
                            .textFieldStyle(.roundedBorder)

                        HStack(spacing: 10) {
                            Button("添加并保存") {
                                guard !newTitle.isEmpty else { return }
                                let book = SimpleBook(title: newTitle, author: newAuthor.isEmpty ? "佚名" : newAuthor)
                                books.append(book)
                                saveToFile()
                                newTitle = ""
                                newAuthor = ""
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(newTitle.isEmpty)

                            Button("读取文件") {
                                loadFromFile()
                            }
                            .buttonStyle(.bordered)

                            Button("删除文件", role: .destructive) {
                                deleteFile()
                            }
                            .buttonStyle(.bordered)
                        }
                        if !statusMessage.isEmpty {
                            Text(statusMessage)
                                .font(.caption)
                                .foregroundStyle(.green)
                        } else {
                            Text("6666").font(.caption).foregroundStyle(.secondary)  // 占位符，保持布局稳定
                        }
                    }
                    .padding(8)
                }

                // ── 书单 ──
                if !books.isEmpty {
                    GroupBox("📚 书单（\(books.count) 本）") {
                        VStack(spacing: 0) {
                            ForEach(books) { book in
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(book.title).font(.headline)
                                        Text(book.author).font(.caption).foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Text(book.addedDate.formatted(date: .abbreviated, time: .omitted))
                                        .font(.caption2)
                                        .foregroundStyle(.tertiary)
                                }
                                .padding(.vertical, 6)
                                Divider()
                            }
                        }
                        .padding(8)
                    }
                }

                ConceptNote(items: [
                    "FileManager.default：系统文件管理器单例",
                    ".documentDirectory：应用沙盒文档目录，数据永久保存",
                    "Codable = Encodable + Decodable：支持 JSON 序列化和反序列化",
                    "JSONEncoder().encode()：将 Codable 对象编码为 Data",
                    "data.write(to:options:.atomicWrite)：原子写入防止文件损坏"
                ])
            }
            .padding()
        }
        .navigationTitle("FileManager")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { loadFromFile() }
    }

    private func saveToFile() {
        do {
            try BookFileManager.saveBooks(books)
            fileSize = BookFileManager.fileSize()
            statusMessage = "✅ 已保存 \(books.count) 本书到文件"
        } catch {
            statusMessage = "❌ 保存失败：\(error.localizedDescription)"
        }
    }

    private func loadFromFile() {
        do {
            books = try BookFileManager.loadBooks()
            fileSize = BookFileManager.fileSize()
            statusMessage = books.isEmpty ? "文件为空或不存在" : "✅ 已读取 \(books.count) 本书"
        } catch {
            statusMessage = "❌ 读取失败：\(error.localizedDescription)"
        }
    }

    private func deleteFile() {
        do {
            try BookFileManager.deleteFile()
            books = []
            fileSize = 0
            statusMessage = "✅ 文件已删除"
        } catch {
            statusMessage = "❌ 删除失败：\(error.localizedDescription)"
        }
    }
}

#Preview {
    NavigationStack {
        FileManagerDemoView()
    }
}
