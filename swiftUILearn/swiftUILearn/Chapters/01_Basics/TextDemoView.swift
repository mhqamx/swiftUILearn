//
//  TextDemoView.swift
//  swiftUILearn
//
//  【知识点】Text 文本视图
//  场景：图书馆书籍信息展示
//

import SwiftUI

struct TextDemoView: View {
    var body: some View {
        // ScrollView 允许内容超出屏幕时滚动
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                // ── 页面标题 ──
                DemoHeader(
                    title: "Text 文本视图",
                    subtitle: "Text 是 SwiftUI 中最基础的视图，用于显示静态或动态文本。"
                )

                // ── Demo 区域 ──
                GroupBox("📖 书籍信息卡片") {
                    VStack(alignment: .leading, spacing: 12) {

                        // 1. 基础文本
                        // .font() 设置字体大小，SwiftUI 提供了一套语义化字体系统
                        Text("活着")
                            .font(.largeTitle)   // 最大标题

                        // 2. 副标题 + 颜色
                        // .foregroundStyle() 设置前景色（iOS 17 推荐，替代 .foregroundColor）
                        Text("余华 著")
                            .font(.title3)
                            .foregroundStyle(.secondary)   // 次要灰色

                        // 3. 多行文本 + 行间距
                        // """ 多行字符串字面量
                        Text("这部小说以朴实的叙述手法，讲述了中国农村一个普通家庭在历史变迁中经历的苦难与坚韧。")
                            .font(.body)
                            .lineSpacing(6)       // 设置行间距
                            .foregroundStyle(.primary)

                        Divider()

                        // 4. 组合样式：粗体 + 斜体
                        HStack {
                            // .bold() 等同于 .fontWeight(.bold)
                            Text("ISBN:").bold()
                            // .italic() 斜体
                            Text("978-7-5399-4675-9").italic()
                        }
                        .font(.footnote)

                        // 5. 自定义字体颜色
                        HStack {
                            Text("馆藏状态：")
                                .font(.footnote)
                                .foregroundStyle(.secondary)

                            // 使用系统颜色表示状态
                            Text("可借阅")
                                .font(.footnote)
                                .bold()
                                .foregroundStyle(.green)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(.green.opacity(0.15))
                                .clipShape(Capsule())   // 胶囊形状背景
                        }

                        // 6. 对齐方式
                        Text("共借出 128 次")
                            .font(.caption)
                            .foregroundStyle(.tertiary)  // 三级灰色，更浅
                            .frame(maxWidth: .infinity, alignment: .trailing) // 右对齐
                    }
                    .padding(8)
                }

                // ── 知识点说明 ──
                ConceptNote(items: [
                    ".font()：设置字体，推荐使用语义化字体如 .headline / .body / .caption",
                    ".foregroundStyle()：设置前景色，iOS 17 推荐写法",
                    ".bold() / .italic()：文字修饰，可叠加使用",
                    ".lineSpacing()：设置行间距，提升多行文本可读性",
                    ".multilineTextAlignment()：多行文本的水平对齐方式"
                ])
            }
            .padding()
        }
        .navigationTitle("Text 文本")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        TextDemoView()
    }
}
