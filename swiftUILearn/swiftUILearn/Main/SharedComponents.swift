//
//  SharedComponents.swift
//  swiftUILearn
//
//  所有 Demo 页面共用的 UI 组件
//  DemoHeader：页面顶部标题区域
//  ConceptNote：底部知识点说明区域
//

import SwiftUI

// MARK: - Demo 页面顶部标题
/// 每个知识点页面统一的顶部区域
struct DemoHeader: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title2.bold())

            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true) // 允许多行
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - 底部知识点说明
/// 用于展示关键 API 和注意事项
struct ConceptNote: View {
    let items: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 标题行
            HStack(spacing: 6) {
                Image(systemName: "lightbulb.fill")
                    .foregroundStyle(.yellow)
                Text("核心知识点")
                    .font(.footnote.bold())
                    .foregroundStyle(.secondary)
            }
            .padding(.bottom, 10)

            // 知识点列表
            ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                HStack(alignment: .top, spacing: 8) {
                    // 分割第一个单词（通常是 API 名）和描述
                    let parts = item.split(separator: "：", maxSplits: 1)
                    if parts.count == 2 {
                        Text(String(parts[0]) + "：")
                            .font(.caption.monospaced())
                            .foregroundStyle(.orange)
                            .fixedSize()
                        Text(String(parts[1]))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    } else {
                        Text("• " + item)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(.bottom, 6)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - 预览
#Preview {
    VStack(spacing: 16) {
        DemoHeader(
            title: "Text 文本视图",
            subtitle: "Text 是 SwiftUI 中最基础的视图，用于显示静态或动态文本。"
        )
        ConceptNote(items: [
            ".font()：设置字体，推荐使用语义化字体如 .headline / .body",
            ".foregroundStyle()：设置前景色，iOS 17 推荐写法",
            ".bold() / .italic()：文字修饰，可叠加使用"
        ])
    }
    .padding()
}
