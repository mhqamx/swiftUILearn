//
//  CoreDataDemoView.swift
//  swiftUILearn
//
//  【知识点】CoreData 基础
//  场景：使用 CoreData 持久化借阅记录
//  注意：本 Demo 使用内存存储演示概念，不需要配置 .xcdatamodeld
//

import SwiftUI
import CoreData
import Combine

// MARK: - CoreData 内存存储（用于 Demo 演示）
class CoreDataStack: ObservableObject {
    // NSPersistentContainer：CoreData 的核心容器
    // 管理数据模型、持久化存储和托管对象上下文
    let container: NSPersistentContainer

    init() {
        // 1. 用代码创建数据模型（生产环境通常使用 .xcdatamodeld 文件）
        let model = NSManagedObjectModel()

        // 2. 创建 "BorrowRecord" 实体
        let entity = NSEntityDescription()
        entity.name = "BorrowRecord"
        entity.managedObjectClassName = NSStringFromClass(BorrowRecord.self)

        // 3. 添加属性
        let titleAttr = NSAttributeDescription()
        titleAttr.name = "bookTitle"
        titleAttr.attributeType = .stringAttributeType
        titleAttr.isOptional = true

        let dateAttr = NSAttributeDescription()
        dateAttr.name = "borrowDate"
        dateAttr.attributeType = .dateAttributeType
        dateAttr.isOptional = true

        let returnedAttr = NSAttributeDescription()
        returnedAttr.name = "isReturned"
        returnedAttr.attributeType = .booleanAttributeType
        returnedAttr.defaultValue = false

        entity.properties = [titleAttr, dateAttr, returnedAttr]
        model.entities = [entity]

        container = NSPersistentContainer(name: "Library", managedObjectModel: model)

        // 使用内存存储（数据不持久化到磁盘，仅用于 Demo）
        let storeDescription = NSPersistentStoreDescription()
        storeDescription.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [storeDescription]

        container.loadPersistentStores { _, error in
            if let error { print("CoreData 加载失败：\(error)") }
        }
    }

    // 托管对象上下文（执行增删改查的工作区）
    var context: NSManagedObjectContext { container.viewContext }

    func save() {
        if context.hasChanges {
            try? context.save()
        }
    }
}

// MARK: - NSManagedObject 子类（借阅记录）
class BorrowRecord: NSManagedObject {
    @NSManaged var bookTitle: String?
    @NSManaged var borrowDate: Date?
    @NSManaged var isReturned: Bool
}

// MARK: - Demo 视图
struct CoreDataDemoView: View {
    // @StateObject 创建 CoreData 容器
    @StateObject private var stack = CoreDataStack()

    // @FetchRequest：自动从 CoreData 查询数据
    // 当数据变化时，视图自动更新
    @State private var records: [BorrowRecord] = []
    @State private var newBookTitle = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                DemoHeader(
                    title: "CoreData 基础",
                    subtitle: "CoreData 是 Apple 的对象-关系映射框架，用于结构化数据的本地持久化存储。"
                )

                // ── CoreData 核心概念 ──
                GroupBox("🗃 CoreData 核心组件") {
                    VStack(alignment: .leading, spacing: 8) {
                        ConceptRow(term: "NSPersistentContainer", desc: "整体容器，管理模型和存储")
                        ConceptRow(term: "NSManagedObjectModel", desc: "数据模型，定义实体和属性")
                        ConceptRow(term: "NSManagedObjectContext", desc: "工作区，执行增删改查")
                        ConceptRow(term: "NSManagedObject", desc: "数据记录（一行数据）")
                        ConceptRow(term: "NSFetchRequest", desc: "查询请求，类似 SQL SELECT")
                    }
                    .padding(8)
                }

                // ── 借阅记录 CRUD ──
                GroupBox("📝 借阅记录（CRUD）") {
                    VStack(spacing: 12) {
                        // Create：新增
                        HStack {
                            TextField("输入书名添加借阅记录", text: $newBookTitle)
                                .textFieldStyle(.roundedBorder)

                            Button("借出") {
                                addRecord(title: newBookTitle)
                                newBookTitle = ""
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(newBookTitle.isEmpty)
                        }

                        Divider()

                        // Read：显示所有记录
                        if records.isEmpty {
                            Text("暂无借阅记录，添加一条试试")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else {
                            ForEach(records, id: \.objectID) { record in
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(record.bookTitle ?? "未知书籍")
                                            .font(.headline)
                                            .strikethrough(record.isReturned)
                                        Text(record.borrowDate?.formatted(date: .abbreviated, time: .shortened) ?? "")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    // Update：切换归还状态
                                    Button {
                                        toggleReturned(record: record)
                                    } label: {
                                        Text(record.isReturned ? "已还" : "未还")
                                            .font(.caption.bold())
                                            .foregroundStyle(record.isReturned ? .green : .orange)
                                    }
                                    .buttonStyle(.bordered)

                                    // Delete：删除记录
                                    Button(role: .destructive) {
                                        deleteRecord(record: record)
                                    } label: {
                                        Image(systemName: "trash")
                                            .font(.caption)
                                    }
                                    .buttonStyle(.bordered)
                                }
                            }
                        }
                    }
                    .padding(8)
                }

                ConceptNote(items: [
                    "NSPersistentContainer：CoreData 入口，loadPersistentStores 加载存储",
                    "context.save()：提交所有修改到持久化存储",
                    "NSManagedObject：数据行，通过 @NSManaged 声明属性",
                    "NSFetchRequest：查询，可设置 predicate（过滤）和 sortDescriptors（排序）",
                    "@FetchRequest：SwiftUI 专用，数据变化自动刷新视图（生产环境推荐）"
                ])
            }
            .padding()
        }
        .navigationTitle("CoreData 基础")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { fetchRecords() }
    }

    // MARK: - CRUD 操作

    private func addRecord(title: String) {
        // 在 context 中创建新对象
        let record = BorrowRecord(context: stack.context)
        record.bookTitle = title
        record.borrowDate = Date()
        record.isReturned = false
        stack.save()
        fetchRecords()
    }

    private func toggleReturned(record: BorrowRecord) {
        record.isReturned.toggle()
        stack.save()
        fetchRecords()
    }

    private func deleteRecord(record: BorrowRecord) {
        stack.context.delete(record)  // 标记为删除
        stack.save()
        fetchRecords()
    }

    private func fetchRecords() {
        let request = NSFetchRequest<BorrowRecord>(entityName: "BorrowRecord")
        request.sortDescriptors = [NSSortDescriptor(key: "borrowDate", ascending: false)]
        records = (try? stack.context.fetch(request)) ?? []
    }
}

// MARK: - 概念说明行
private struct ConceptRow: View {
    let term: String
    let desc: String

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text(term)
                .font(.caption.monospaced())
                .foregroundStyle(.orange)
                .fixedSize()
            Text(desc)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    NavigationStack {
        CoreDataDemoView()
    }
}
