//
//  FocusStateDemoView.swift
//  swiftUILearn
//
//  【知识点】@FocusState 焦点
//  场景：表单自动聚焦、焦点切换、键盘工具栏
//

import SwiftUI

struct FocusStateDemoView: View {
    // 基本焦点
    @FocusState private var isNameFocused: Bool
    @State private var name = ""

    // 枚举焦点
    enum FormField: Hashable {
        case title, author, isbn, notes
    }
    @FocusState private var focusedField: FormField?
    @State private var bookTitle = ""
    @State private var bookAuthor = ""
    @State private var bookISBN = ""
    @State private var bookNotes = ""

    // 验证
    @State private var showValidation = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                DemoHeader(
                    title: "@FocusState 焦点",
                    subtitle: "@FocusState 用于管理输入框焦点，支持自动聚焦、焦点切换和键盘工具栏。"
                )

                // ── 1. 自动聚焦 ──
                GroupBox("📝 自动聚焦") {
                    VStack(spacing: 12) {
                        Text("进入页面时自动聚焦到输入框")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        TextField("输入你的名字", text: $name)
                            .textFieldStyle(.roundedBorder)
                            .focused($isNameFocused)

                        HStack {
                            Button("聚焦") {
                                isNameFocused = true
                            }
                            .buttonStyle(.bordered)

                            Button("取消焦点") {
                                isNameFocused = false
                            }
                            .buttonStyle(.bordered)

                            Text(isNameFocused ? "✅ 已聚焦" : "❌ 未聚焦")
                                .font(.caption)
                        }
                    }
                    .padding(8)
                }

                // ── 2. 枚举焦点切换 ──
                GroupBox("🔄 枚举焦点切换") {
                    VStack(spacing: 12) {
                        Text("使用枚举管理多个输入框的焦点")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        VStack(spacing: 8) {
                            FocusableField(
                                label: "书名",
                                text: $bookTitle,
                                field: .title,
                                focusedField: $focusedField
                            )

                            FocusableField(
                                label: "作者",
                                text: $bookAuthor,
                                field: .author,
                                focusedField: $focusedField
                            )

                            FocusableField(
                                label: "ISBN",
                                text: $bookISBN,
                                field: .isbn,
                                focusedField: $focusedField
                            )

                            FocusableField(
                                label: "备注",
                                text: $bookNotes,
                                field: .notes,
                                focusedField: $focusedField
                            )
                        }
                    }
                    .padding(8)
                }

                // ── 3. 键盘工具栏 ──
                GroupBox("⌨️ 键盘工具栏导航") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("在键盘上方添加上/下/完成按钮")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("ToolbarItemGroup(placement: .keyboard) {")
                            Text("    Button(\"上一个\") { ... }")
                            Text("    Button(\"下一个\") { ... }")
                            Text("    Spacer()")
                            Text("    Button(\"完成\") { focusedField = nil }")
                            Text("}")
                        }
                        .font(.caption.monospaced())
                        .foregroundStyle(.secondary)
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.blue.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .padding(8)
                }

                // ── 4. 表单验证聚焦 ──
                GroupBox("✅ 表单验证") {
                    VStack(spacing: 12) {
                        Text("提交时自动聚焦到第一个空白字段")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        if showValidation {
                            VStack(alignment: .leading, spacing: 4) {
                                if bookTitle.isEmpty {
                                    Label("请填写书名", systemImage: "exclamationmark.circle")
                                        .font(.caption)
                                        .foregroundStyle(.red)
                                }
                                if bookAuthor.isEmpty {
                                    Label("请填写作者", systemImage: "exclamationmark.circle")
                                        .font(.caption)
                                        .foregroundStyle(.red)
                                }
                            }
                        }

                        Button("提交") {
                            showValidation = true
                            if bookTitle.isEmpty {
                                focusedField = .title
                            } else if bookAuthor.isEmpty {
                                focusedField = .author
                            } else if bookISBN.isEmpty {
                                focusedField = .isbn
                            } else {
                                focusedField = nil
                                showValidation = false
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(8)
                }

                ConceptNote(items: [
                    "@FocusState var isFocused: Bool：单个输入框的焦点状态",
                    "@FocusState var field: Field?：枚举管理多个焦点",
                    ".focused($field, equals: .title)：绑定焦点到指定枚举值",
                    "ToolbarItemGroup(.keyboard)：键盘上方的工具栏按钮",
                    "设为 nil 可关闭键盘：focusedField = nil"
                ])
            }
            .padding()
        }
        .navigationTitle("@FocusState 焦点")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button {
                    moveFocus(forward: false)
                } label: {
                    Image(systemName: "chevron.up")
                }

                Button {
                    moveFocus(forward: true)
                } label: {
                    Image(systemName: "chevron.down")
                }

                Spacer()

                Button("完成") {
                    focusedField = nil
                }
            }
        }
    }

    private func moveFocus(forward: Bool) {
        let fields: [FormField] = [.title, .author, .isbn, .notes]
        guard let current = focusedField,
              let index = fields.firstIndex(of: current) else { return }

        if forward {
            if index < fields.count - 1 {
                focusedField = fields[index + 1]
            }
        } else {
            if index > 0 {
                focusedField = fields[index - 1]
            }
        }
    }
}

private struct FocusableField: View {
    let label: String
    @Binding var text: String
    let field: FocusStateDemoView.FormField
    @FocusState.Binding var focusedField: FocusStateDemoView.FormField?

    var body: some View {
        HStack {
            Text(label)
                .font(.caption)
                .frame(width: 40, alignment: .leading)
            TextField(label, text: $text)
                .textFieldStyle(.roundedBorder)
                .focused($focusedField, equals: field)

            if focusedField == field {
                Image(systemName: "pencil.circle.fill")
                    .foregroundStyle(.blue)
            }
        }
    }
}

#Preview {
    NavigationStack {
        FocusStateDemoView()
    }
}
