//
//  TextFieldDemoView.swift
//  swiftUILearn
//
//  【知识点】TextField 输入框
//  场景：图书馆新书登记、搜索书名
//

import SwiftUI

struct TextFieldDemoView: View {
    @State private var bookTitle = ""
    @State private var authorName = ""
    @State private var isbn = ""
    @State private var notes = ""
    @State private var submittedTitle = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                DemoHeader(
                    title: "TextField 输入框",
                    subtitle: "TextField 用于接收用户文本输入，支持多种键盘类型和格式化。"
                )

                // ── 1. 基础输入框 ──
                GroupBox("📝 新书登记表单") {
                    VStack(spacing: 14) {

                        // TextField(placeholder, text: $binding)
                        // $bookTitle 是双向绑定，输入内容会同步更新变量
                        TextField("书名（必填）", text: $bookTitle)
                            .textFieldStyle(.roundedBorder)  // 圆角边框样式

                        TextField("作者姓名", text: $authorName)
                            .textFieldStyle(.roundedBorder)

                        // 指定键盘类型：数字键盘更适合输入 ISBN
                        TextField("ISBN 编号", text: $isbn)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)       // 数字键盘
                            .textContentType(.none)          // 关闭自动填充

                        // 多行文本输入：使用 axis: .vertical 让 TextField 自动扩展高度
                        TextField("备注说明", text: $notes, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .lineLimit(3...6)               // 最小3行，最多6行

                        // 提交按钮
                        Button("登记入库") {
                            submittedTitle = bookTitle.isEmpty ? "（未填书名）" : bookTitle
                            bookTitle = ""
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(bookTitle.isEmpty)        // 书名为空时禁用按钮

                        if !submittedTitle.isEmpty {
                            Text("✅ 已登记：《\(submittedTitle)》")
                                .font(.footnote)
                                .foregroundStyle(.green)
                        }
                    }
                    .padding(8)
                }

                // ── 2. 安全输入框 ──
                GroupBox("🔒 SecureField 密码框") {
                    VStack(spacing: 12) {
                        // SecureField 用于密码输入，内容会被遮蔽
                        SecureFieldExample()
                    }
                    .padding(8)
                }

                // ── 3. 修饰符演示 ──
                GroupBox("⚙️ 常用修饰符") {
                    VStack(spacing: 12) {
                        // .autocorrectionDisabled()：关闭自动纠错（适合专有名词）
                        TextField("书籍系列名（关闭纠错）", text: .constant(""))
                            .textFieldStyle(.roundedBorder)
                            .autocorrectionDisabled()

                        // .textInputAutocapitalization：自动大写策略
                        TextField("作者英文名（首字母大写）", text: .constant(""))
                            .textFieldStyle(.roundedBorder)
                            .textInputAutocapitalization(.words)

                        // .submitLabel：设置键盘右下角按钮文字
                        TextField("搜索书名（回车键显示搜索）", text: .constant(""))
                            .textFieldStyle(.roundedBorder)
                            .submitLabel(.search)
                    }
                    .padding(8)
                }

                ConceptNote(items: [
                    "TextField(placeholder, text: $var)：$符号创建双向绑定",
                    ".textFieldStyle(.roundedBorder)：内置圆角样式，最常用",
                    ".keyboardType(.numberPad)：数字键盘，适合ID/ISBN输入",
                    "axis: .vertical + .lineLimit()：多行自动扩展输入框",
                    ".disabled(condition)：条件禁用，表单未填完时禁用提交",
                    "SecureField：密码输入，内容自动遮蔽"
                ])
            }
            .padding()
        }
        .navigationTitle("TextField 输入框")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - SecureField 示例（独立子视图，因为有自己的 @State）
private struct SecureFieldExample: View {
    @State private var password = ""
    @State private var isVisible = false

    var body: some View {
        HStack {
            if isVisible {
                TextField("图书馆员工密码", text: $password)
            } else {
                SecureField("图书馆员工密码", text: $password)
            }

            // 切换密码可见性
            Button {
                isVisible.toggle()
            } label: {
                Image(systemName: isVisible ? "eye.slash" : "eye")
                    .foregroundStyle(.secondary)
            }
        }
        .textFieldStyle(.roundedBorder)
    }
}

#Preview {
    NavigationStack {
        TextFieldDemoView()
    }
}
