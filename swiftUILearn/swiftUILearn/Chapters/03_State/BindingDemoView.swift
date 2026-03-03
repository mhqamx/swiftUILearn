//
//  BindingDemoView.swift
//  swiftUILearn
//
//  【知识点】@Binding 数据绑定
//  场景：父视图书籍列表 ↔ 子视图借阅状态开关
//

import SwiftUI

// 定义数据模型，打包相关状态
struct BookSettings {
    var isAvailable = true
    var isRecommended = false
    var borrowDays = 14
}

struct BindingDemoView: View {
    // 父视图拥有这些状态
    // 方案优化：将多个状态打包成一个结构体
    @State private var settings = BookSettings()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                DemoHeader(
                    title: "@Binding 数据绑定",
                    subtitle: "@Binding 在父子视图间建立双向数据通道：子视图修改数据，父视图同步更新。"
                )

                // ── 父视图状态展示 ──
                GroupBox("📋 父视图状态（实时更新）") {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("可借状态：")
                            Text(settings.isAvailable ? "✅ 可借" : "❌ 已借出")
                                .bold()
                                .foregroundStyle(settings.isAvailable ? .green : .red)
                        }
                        HStack {
                            Text("馆员推荐：")
                            Text(settings.isRecommended ? "⭐️ 已推荐" : "普通藏书")
                                .bold()
                                .foregroundStyle(settings.isRecommended ? .orange : .secondary)
                        }
                        HStack {
                            Text("借阅天数：")
                            Text("\(settings.borrowDays) 天")
                                .bold()
                                .foregroundStyle(.blue)
                        }
                    }
                    .font(.footnote)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                }

                // ── 子视图（通过 @Binding 接收数据）──
                GroupBox("🔗 子视图（通过 @Binding 修改父视图数据）") {
                    VStack(spacing: 0) {
                        // 只需要传递 settings 一个 Binding
                        BookStatusEditor(settings: $settings)
                    }
                    .padding(8)
                }

                // ── 原理说明 ──
                GroupBox("💡 @Binding 原理图") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("父视图 @State var settings = BookSettings()")
                            .font(.caption.monospaced())
                            .foregroundStyle(.blue)

                        HStack(spacing: 4) {
                            Spacer()
                            Image(systemName: "arrow.up.arrow.down")
                                .foregroundStyle(.orange)
                            Text("$settings（Binding）")
                                .font(.caption.monospaced())
                                .foregroundStyle(.orange)
                            Spacer()
                        }

                        Text("子视图 @Binding var settings: BookSettings")
                            .font(.caption.monospaced())
                            .foregroundStyle(.green)

                        Text("子视图修改 settings.属性 → 父视图的 @State 同步更新 → 父视图重绘")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .padding(.top, 4)
                    }
                    .padding(8)
                }

                ConceptNote(items: [
                    "@Binding var x：子视图声明，不拥有数据，只是引用",
                    "Struct 绑定：可以将多个状态打包成 Struct，只传递一个 Binding",
                    "$stateVar：父视图传递，$ 符号将 @State 转为 Binding",
                    "双向同步：子视图写入 → 父视图 @State 更新 → 两个视图都重绘",
                    ".constant(value)：传入固定值，用于 Preview 时提供 Binding"
                ])
            }
            .padding()
        }
        .navigationTitle("@Binding 数据绑定")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 子视图：接收 @Binding 参数
private struct BookStatusEditor: View {
    // @Binding：不拥有数据，通过引用修改父视图的数据
    @Binding var settings: BookSettings

    var body: some View {
        VStack(spacing: 12) {
            // Toggle 内部就是通过 Binding 工作的
            // 使用 $settings.属性名 访问内部属性的 Binding
            Toggle("可供借阅", isOn: $settings.isAvailable)
            Divider()
            Toggle("馆员推荐", isOn: $settings.isRecommended)
            Divider()

            HStack {
                Text("借阅天数：\(settings.borrowDays) 天")
                    .font(.footnote)
                Spacer()
                Stepper("", value: $settings.borrowDays, in: 1...30)
                    .labelsHidden()
            }
        }
    }
}

#Preview {
    NavigationStack {
        BindingDemoView()
    }
}
