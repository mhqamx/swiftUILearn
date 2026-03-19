//
//  ShareLinkDemoView.swift
//  swiftUILearn
//
//  【知识点】ShareLink 分享
//  场景：分享书名、书籍信息
//

import SwiftUI

struct ShareLinkDemoView: View {
    @State private var bookTitle = "SwiftUI 实战指南"
    @State private var bookDescription = "一本全面介绍 SwiftUI 开发的书籍，涵盖基础到进阶的所有知识点。"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                DemoHeader(
                    title: "ShareLink 分享",
                    subtitle: "ShareLink 是 SwiftUI 原生的分享控件，替代 UIActivityViewController，声明式调用更简洁。"
                )

                // ── 1. 基础分享 ──
                GroupBox("📤 基础文本分享") {
                    VStack(spacing: 12) {
                        Text("分享一段文字")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        TextField("书名", text: $bookTitle)
                            .textFieldStyle(.roundedBorder)

                        ShareLink(item: bookTitle) {
                            Label("分享书名", systemImage: "square.and.arrow.up")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(8)
                }

                // ── 2. 分享 URL ──
                GroupBox("🔗 分享链接") {
                    VStack(spacing: 12) {
                        Text("分享一个网址")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        if let url = URL(string: "https://developer.apple.com/xcode/swiftui/") {
                            ShareLink(item: url) {
                                Label("分享 SwiftUI 官网", systemImage: "link")
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                    .padding(8)
                }

                // ── 3. 自定义预览 ──
                GroupBox("📋 自定义分享预览") {
                    VStack(spacing: 12) {
                        Text("SharePreview 自定义分享时的预览样式")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        ShareLink(
                            item: bookTitle,
                            preview: SharePreview(
                                bookTitle,
                                image: Image(systemName: "book.fill")
                            )
                        ) {
                            Label("带预览分享", systemImage: "eye")
                        }
                        .buttonStyle(.bordered)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("SharePreview(")
                            Text("    \"标题\",")
                            Text("    image: Image(...)  // 预览图")
                            Text(")")
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

                // ── 4. Transferable 协议 ──
                GroupBox("📚 Transferable 协议") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("自定义类型实现 Transferable 协议后可用于分享")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("struct BookInfo: Transferable {")
                            Text("    var title: String")
                            Text("    var author: String")
                            Text("")
                            Text("    static var transferRepresentation:")
                            Text("        some TransferRepresentation {")
                            Text("        ProxyRepresentation(\\.description)")
                            Text("    }")
                            Text("}")
                        }
                        .font(.caption.monospaced())
                        .foregroundStyle(.secondary)
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.orange.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                        ShareLink(
                            item: "\(bookTitle) - \(bookDescription)",
                            preview: SharePreview(bookTitle, image: Image(systemName: "book.closed.fill"))
                        ) {
                            Label("分享书籍详情", systemImage: "square.and.arrow.up.fill")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(8)
                }

                ConceptNote(items: [
                    "ShareLink(item:)：SwiftUI 原生分享控件，替代 UIActivityViewController",
                    "SharePreview(title:image:)：自定义分享预览的标题和图片",
                    "Transferable：协议，让自定义类型可用于分享和拖放",
                    "ProxyRepresentation：用现有类型代理传输，最简单的实现方式",
                    "ShareLink 支持 String、URL、Image 等常见类型"
                ])
            }
            .padding()
        }
        .navigationTitle("ShareLink 分享")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ShareLinkDemoView()
    }
}
