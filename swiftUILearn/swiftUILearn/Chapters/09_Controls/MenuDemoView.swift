//
//  MenuDemoView.swift
//  swiftUILearn
//
//  【知识点】Menu & ContextMenu
//  场景：排序菜单、嵌套菜单、长按菜单
//

import SwiftUI

struct MenuDemoView: View {
    @State private var sortOrder = "默认"
    @State private var books = ["SwiftUI 入门", "Swift 进阶", "设计模式", "算法导论", "代码大全"]
    @State private var selectedBook: String?
    @State private var fontSize: Double = 16

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                DemoHeader(
                    title: "Menu & ContextMenu",
                    subtitle: "Menu 是下拉操作菜单，ContextMenu 是长按弹出的上下文菜单，两者都支持嵌套和分组。"
                )

                // ── 1. 排序菜单 ──
                GroupBox("📋 排序菜单") {
                    VStack(spacing: 12) {
                        HStack {
                            Text("当前排序：\(sortOrder)")
                                .font(.subheadline)
                            Spacer()

                            Menu {
                                Button {
                                    sortOrder = "默认"
                                } label: {
                                    Label("默认顺序", systemImage: "list.bullet")
                                }

                                Button {
                                    sortOrder = "名称"
                                    books.sort()
                                } label: {
                                    Label("按名称", systemImage: "textformat.abc")
                                }

                                Button {
                                    sortOrder = "倒序"
                                    books.sort(by: >)
                                } label: {
                                    Label("倒序", systemImage: "arrow.up.arrow.down")
                                }
                            } label: {
                                Label("排序", systemImage: "arrow.up.arrow.down.circle")
                                    .font(.caption)
                            }
                            .buttonStyle(.bordered)
                        }

                        ForEach(books, id: \.self) { book in
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
                    }
                    .padding(8)
                }

                // ── 2. 嵌套菜单 ──
                GroupBox("📚 嵌套菜单") {
                    VStack(spacing: 12) {
                        Text("Menu 支持 Section 分组和嵌套子菜单")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Menu {
                            Section("阅读设置") {
                                Menu("字体大小") {
                                    Button("小 (14pt)") { fontSize = 14 }
                                    Button("中 (16pt)") { fontSize = 16 }
                                    Button("大 (20pt)") { fontSize = 20 }
                                }

                                Menu("主题") {
                                    Button("浅色") { }
                                    Button("深色") { }
                                    Button("跟随系统") { }
                                }
                            }

                            Divider()

                            Section("书架操作") {
                                Button {
                                } label: {
                                    Label("添加书籍", systemImage: "plus")
                                }

                                Button(role: .destructive) {
                                } label: {
                                    Label("清空书架", systemImage: "trash")
                                }
                            }
                        } label: {
                            Label("更多操作", systemImage: "ellipsis.circle.fill")
                        }
                        .buttonStyle(.borderedProminent)

                        Text("当前字体大小：\(Int(fontSize))pt")
                            .font(.system(size: fontSize))
                    }
                    .padding(8)
                }

                // ── 3. contextMenu 长按 ──
                GroupBox("👆 contextMenu 长按菜单") {
                    VStack(spacing: 12) {
                        Text("长按书籍卡片弹出操作菜单")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        ForEach(books, id: \.self) { book in
                            HStack {
                                Image(systemName: "book.fill")
                                    .foregroundStyle(.purple)
                                Text(book)
                                    .font(.subheadline)
                                Spacer()
                                if selectedBook == book {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(.green)
                                }
                            }
                            .padding(10)
                            .background(Color.purple.opacity(0.05))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .contextMenu {
                                Button {
                                    selectedBook = book
                                } label: {
                                    Label("选择", systemImage: "checkmark.circle")
                                }

                                Button {
                                } label: {
                                    Label("分享", systemImage: "square.and.arrow.up")
                                }

                                Divider()

                                Button(role: .destructive) {
                                    books.removeAll { $0 == book }
                                } label: {
                                    Label("删除", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .padding(8)
                }

                // ── 4. 菜单内嵌控件 ──
                GroupBox("🏷️ 菜单样式说明") {
                    VStack(alignment: .leading, spacing: 8) {
                        InfoRow(code: "Menu { } label: { }", desc: "基础菜单，点击触发")
                        InfoRow(code: ".contextMenu { }", desc: "长按触发的上下文菜单")
                        InfoRow(code: "Section(\"标题\")", desc: "菜单项分组")
                        InfoRow(code: "Divider()", desc: "菜单分隔线")
                        InfoRow(code: "role: .destructive", desc: "红色危险操作按钮")
                        InfoRow(code: "Menu(\"子菜单\") { }", desc: "嵌套子菜单")
                    }
                    .padding(8)
                }

                ConceptNote(items: [
                    "Menu：点击触发的下拉菜单，适合操作按钮",
                    "contextMenu：长按触发的上下文菜单，适合列表项操作",
                    "Section / Divider：菜单内分组和分隔",
                    "role: .destructive：标记为危险操作，显示红色",
                    "Menu 支持嵌套：可以创建多级子菜单"
                ])
            }
            .padding()
        }
        .navigationTitle("Menu & ContextMenu")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct InfoRow: View {
    let code: String
    let desc: String

    var body: some View {
        HStack(spacing: 8) {
            Text(code)
                .font(.caption.monospaced())
                .foregroundStyle(.orange)
            Spacer()
            Text(desc)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    NavigationStack {
        MenuDemoView()
    }
}
