//
//  ToolbarDemoView.swift
//  swiftUILearn
//
//  【知识点】Toolbar 工具栏
//  场景：导航栏按钮、底部工具栏、键盘工具栏
//

import SwiftUI

struct ToolbarDemoView: View {
    @State private var showToolbarDemo = false
    @State private var editMode = false
    @State private var bookTitle = ""
    @State private var noteText = ""
    @FocusState private var isTextFieldFocused: Bool
    @State private var actionLog: [String] = []

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                DemoHeader(
                    title: "Toolbar 工具栏",
                    subtitle: "Toolbar 是 SwiftUI 中添加导航栏按钮和工具栏的统一方式，支持多种位置和样式。"
                )

                // ── 1. 导航栏按钮 ──
                GroupBox("🔧 导航栏按钮") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("通过 NavigationStack 内嵌 toolbar 查看效果")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        NavigationLink("查看工具栏示例 →") {
                            ToolbarExampleView()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(8)
                }

                // ── 2. 按钮位置 ──
                GroupBox("📍 ToolbarItem 位置") {
                    VStack(alignment: .leading, spacing: 8) {
                        PositionRow(name: ".topBarLeading", desc: "导航栏左侧（返回按钮旁）")
                        PositionRow(name: ".topBarTrailing", desc: "导航栏右侧（常放操作按钮）")
                        PositionRow(name: ".principal", desc: "导航栏中间（替换标题）")
                        PositionRow(name: ".bottomBar", desc: "底部工具栏")
                        PositionRow(name: ".keyboard", desc: "键盘上方工具栏")
                    }
                    .padding(8)
                }

                // ── 3. 自定义标题 ──
                GroupBox("🎨 自定义导航标题") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("用 .principal 放自定义视图替换标题")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        NavigationLink("查看自定义标题 →") {
                            CustomTitleToolbarView()
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding(8)
                }

                // ── 4. 键盘工具栏 ──
                GroupBox("⌨️ 键盘工具栏") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("在键盘上方添加「完成」按钮")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        TextField("输入读书笔记...", text: $noteText)
                            .textFieldStyle(.roundedBorder)
                            .focused($isTextFieldFocused)

                        Text("点击输入框，键盘上方会出现完成按钮")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    .padding(8)
                }
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("完成") {
                            isTextFieldFocused = false
                        }
                    }
                }

                // 操作记录
                if !actionLog.isEmpty {
                    GroupBox("📋 操作记录") {
                        VStack(alignment: .leading, spacing: 4) {
                            ForEach(actionLog, id: \.self) { log in
                                Text(log)
                                    .font(.caption.monospaced())
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(8)
                    }
                }

                ConceptNote(items: [
                    "ToolbarItem(placement:)：指定按钮在工具栏中的位置",
                    ".topBarTrailing：导航栏右侧，最常用的位置",
                    ".principal：替换导航标题，放自定义视图",
                    "ToolbarItemGroup(placement: .keyboard)：键盘上方工具栏",
                    ".toolbar(.hidden)：隐藏指定位置的工具栏"
                ])
            }
            .padding()
        }
        .navigationTitle("Toolbar 工具栏")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 工具栏示例页
private struct ToolbarExampleView: View {
    @State private var items = ["SwiftUI 入门", "Swift 进阶", "设计模式"]
    @State private var showAdd = false

    var body: some View {
        List {
            ForEach(items, id: \.self) { item in
                HStack {
                    Image(systemName: "book.fill")
                        .foregroundStyle(.blue)
                    Text(item)
                }
            }
            .onDelete { items.remove(atOffsets: $0) }
        }
        .navigationTitle("我的书架")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showAdd = true
                } label: {
                    Image(systemName: "plus")
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                EditButton()
            }

            ToolbarItem(placement: .bottomBar) {
                HStack {
                    Text("共 \(items.count) 本书")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Button {
                        items.append("新书 \(items.count + 1)")
                    } label: {
                        Label("快速添加", systemImage: "plus.circle")
                            .font(.caption)
                    }
                }
            }
        }
        .alert("添加书籍", isPresented: $showAdd) {
            Button("取消", role: .cancel) { }
            Button("确定") {
                items.append("新书 \(items.count + 1)")
            }
        } message: {
            Text("是否添加一本新书？")
        }
    }
}

// MARK: - 自定义标题页
private struct CustomTitleToolbarView: View {
    var body: some View {
        List {
            ForEach(1...5, id: \.self) { i in
                Text("书籍条目 \(i)")
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack(spacing: 2) {
                    Text("我的书架")
                        .font(.headline)
                    Text("共 5 本书")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

// MARK: - 位置说明行
private struct PositionRow: View {
    let name: String
    let desc: String

    var body: some View {
        HStack(spacing: 8) {
            Text(name)
                .font(.caption.monospaced())
                .foregroundStyle(.orange)
                .frame(width: 140, alignment: .leading)
            Text(desc)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    NavigationStack {
        ToolbarDemoView()
    }
}
