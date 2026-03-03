//
//  ToggleDemoView.swift
//  swiftUILearn
//
//  【知识点】Toggle 开关
//  场景：图书馆书籍状态管理（是否可借、是否推荐等）
//

import SwiftUI

struct ToggleDemoView: View {
    // 各种借阅相关的布尔状态
    @State private var isAvailable = true
    @State private var isRecommended = false
    @State private var isNewArrival = true
    @State private var allowElectronic = false
    @State private var enableNotification = true

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                DemoHeader(
                    title: "Toggle 开关",
                    subtitle: "Toggle 是布尔值的开关控件，绑定一个 Bool 类型的 @State 变量。"
                )

                // ── 1. 基础开关 ──
                GroupBox("📚 书籍状态设置") {
                    VStack(spacing: 0) {
                        // Toggle(label, isOn: $boolVar) — 标准写法
                        Toggle("可供借阅", isOn: $isAvailable)
                        Divider().padding(.vertical, 4)

                        Toggle("馆员推荐", isOn: $isRecommended)
                        Divider().padding(.vertical, 4)

                        Toggle("新书到馆", isOn: $isNewArrival)
                        Divider().padding(.vertical, 4)

                        // 带图标的 Toggle（使用 Label）
                        Toggle(isOn: $allowElectronic) {
                            Label("提供电子版", systemImage: "ipad")
                        }
                    }
                    .padding(8)
                }

                // ── 2. 状态结果展示 ──
                GroupBox("📋 当前状态") {
                    VStack(alignment: .leading, spacing: 8) {
                        StatusRow(label: "借阅状态", value: isAvailable ? "可借" : "已借出",
                                  isPositive: isAvailable)
                        StatusRow(label: "推荐状态", value: isRecommended ? "馆员推荐" : "普通藏书",
                                  isPositive: isRecommended)
                        StatusRow(label: "到馆时间", value: isNewArrival ? "近30天新书" : "馆藏旧书",
                                  isPositive: isNewArrival)
                        StatusRow(label: "电子版本", value: allowElectronic ? "有电子版" : "仅纸质版",
                                  isPositive: allowElectronic)
                    }
                    .padding(8)
                }

                // ── 3. 自定义样式 ──
                GroupBox("🎨 Toggle 样式") {
                    VStack(spacing: 12) {

                        // .toggleStyle(.switch)：默认样式（iOS 风格拨码开关）
                        Toggle("到期提醒", isOn: $enableNotification)
                            .toggleStyle(.switch)   // 默认就是这个，可以省略

                        // .toggleStyle(.button)：按钮样式（点击切换，像选中/取消选中）
                        Toggle("收藏此书", isOn: $isRecommended)
                            .toggleStyle(.button)

                        // 自定义颜色（通过 .tint 修改开关颜色）
                        Toggle("允许续借", isOn: $isAvailable)
                            .tint(.green)   // 开启状态时的颜色
                    }
                    .padding(8)
                }

                ConceptNote(items: [
                    "Toggle(label, isOn: $bool)：绑定 Bool 类型的 @State 变量",
                    "$前缀：将变量包装为 Binding，允许 Toggle 读写该变量",
                    ".toggleStyle(.switch)：默认拨码样式",
                    ".toggleStyle(.button)：按钮切换样式，视觉更紧凑",
                    ".tint(color)：修改开关开启时的颜色"
                ])
            }
            .padding()
        }
        .navigationTitle("Toggle 开关")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 状态显示行（子视图）
private struct StatusRow: View {
    let label: String
    let value: String
    let isPositive: Bool

    var body: some View {
        HStack {
            Text(label)
                .font(.footnote)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.footnote.bold())
                .foregroundStyle(isPositive ? .green : .orange)
        }
    }
}

#Preview {
    NavigationStack {
        ToggleDemoView()
    }
}
