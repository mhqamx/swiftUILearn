//
//  ViewModifierDemoView.swift
//  swiftUILearn
//
//  【知识点】ViewModifier & @ViewBuilder
//  场景：自定义修饰符、View 扩展、泛型容器
//

import SwiftUI

struct ViewModifierDemoView: View {
    @State private var isHighlighted = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                DemoHeader(
                    title: "ViewModifier & @ViewBuilder",
                    subtitle: "ViewModifier 让你封装可复用的视图修改逻辑，@ViewBuilder 让你编写接受视图参数的函数和容器。"
                )

                // ── 1. 自定义 ViewModifier ──
                GroupBox("🏗️ 自定义 ViewModifier") {
                    VStack(spacing: 12) {
                        Text("封装通用的卡片样式")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        // 使用自定义 modifier
                        Text("SwiftUI 入门指南")
                            .modifier(BookCardModifier(color: .blue))

                        Text("Swift 高级编程")
                            .modifier(BookCardModifier(color: .green))

                        Text("设计模式精解")
                            .modifier(BookCardModifier(color: .orange))

                        VStack(alignment: .leading, spacing: 4) {
                            Text("struct BookCardModifier: ViewModifier {")
                            Text("    func body(content: Content) -> some View {")
                            Text("        content")
                            Text("            .padding()")
                            Text("            .background(color.opacity(0.1))")
                            Text("            .clipShape(RoundedRectangle(...))")
                            Text("    }")
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

                // ── 2. View 扩展 ──
                GroupBox("🔗 View 扩展") {
                    VStack(spacing: 12) {
                        Text("通过扩展创建更简洁的调用方式")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        // 使用扩展方法
                        Text("使用 .bookCardStyle()")
                            .bookCardStyle(color: .purple)

                        HStack {
                            Image(systemName: "book.fill")
                            Text("组合视图也可以用")
                        }
                        .bookCardStyle(color: .pink)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("extension View {")
                            Text("    func bookCardStyle(color: Color)")
                            Text("        -> some View {")
                            Text("        modifier(BookCardModifier(color: color))")
                            Text("    }")
                            Text("}")
                        }
                        .font(.caption.monospaced())
                        .foregroundStyle(.secondary)
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.purple.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .padding(8)
                }

                // ── 3. @ViewBuilder 函数 ──
                GroupBox("📦 @ViewBuilder 函数") {
                    VStack(spacing: 12) {
                        Text("@ViewBuilder 让函数返回多种视图")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        statusBadge(isRead: true)
                        statusBadge(isRead: false)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("@ViewBuilder")
                            Text("func statusBadge(isRead: Bool) -> some View {")
                            Text("    if isRead {")
                            Text("        Label(\"已读\", ...)")
                            Text("    } else {")
                            Text("        Label(\"未读\", ...)")
                            Text("    }")
                            Text("}")
                        }
                        .font(.caption.monospaced())
                        .foregroundStyle(.secondary)
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.green.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .padding(8)
                }

                // ── 4. 泛型容器视图 ──
                GroupBox("🧩 泛型容器视图") {
                    VStack(spacing: 12) {
                        Text("用泛型和 @ViewBuilder 创建可复用容器")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        SectionContainer(title: "推荐书籍", icon: "star.fill", iconColor: .yellow) {
                            Text("SwiftUI 实战")
                            Text("Swift 进阶")
                        }

                        SectionContainer(title: "最近阅读", icon: "clock.fill", iconColor: .blue) {
                            HStack {
                                Image(systemName: "book.fill")
                                Text("设计模式")
                            }
                        }
                    }
                    .padding(8)
                }

                ConceptNote(items: [
                    "ViewModifier：协议，实现 body(content:) 封装修饰逻辑",
                    ".modifier()：应用自定义 ViewModifier",
                    "View extension：通过扩展提供便捷调用，如 .bookCardStyle()",
                    "@ViewBuilder：标记函数或属性，可以返回条件视图",
                    "泛型容器：结合 @ViewBuilder 和泛型，创建可复用的布局容器"
                ])
            }
            .padding()
        }
        .navigationTitle("ViewModifier")
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private func statusBadge(isRead: Bool) -> some View {
        if isRead {
            Label("已读", systemImage: "checkmark.circle.fill")
                .font(.caption)
                .foregroundStyle(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.green)
                .clipShape(Capsule())
        } else {
            Label("未读", systemImage: "circle")
                .font(.caption)
                .foregroundStyle(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.gray)
                .clipShape(Capsule())
        }
    }
}

// MARK: - 自定义 ViewModifier
struct BookCardModifier: ViewModifier {
    let color: Color

    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(color.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            }
    }
}

// MARK: - View 扩展
extension View {
    func bookCardStyle(color: Color = .blue) -> some View {
        modifier(BookCardModifier(color: color))
    }
}

// MARK: - 泛型容器视图
struct SectionContainer<Content: View>: View {
    let title: String
    let icon: String
    let iconColor: Color
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .foregroundStyle(iconColor)
                Text(title)
                    .font(.subheadline.bold())
            }

            VStack(alignment: .leading, spacing: 4) {
                content
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color.gray.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

#Preview {
    NavigationStack {
        ViewModifierDemoView()
    }
}
