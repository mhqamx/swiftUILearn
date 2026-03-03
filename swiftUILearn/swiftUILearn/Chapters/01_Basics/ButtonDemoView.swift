//
//  ButtonDemoView.swift
//  swiftUILearn
//
//  【知识点】Button 按钮
//  场景：图书馆借阅、收藏、预约操作按钮
//

import SwiftUI

struct ButtonDemoView: View {
    // @State 存储视图内部状态（详见第三章）
    @State private var borrowCount = 0
    @State private var isFavorited = false
    @State private var isReserved = false
    @State private var lastAction = "等待操作..."

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                DemoHeader(
                    title: "Button 按钮",
                    subtitle: "Button 是处理用户点击交互的基础控件，支持多种样式和自定义外观。"
                )

                // ── 1. 基础按钮 ──
                GroupBox("🖱 基础按钮") {
                    VStack(spacing: 12) {
                        // 最简单的按钮：title + action
                        Button("借阅这本书") {
                            borrowCount += 1
                            lastAction = "点击了借阅，共借阅 \(borrowCount) 次"
                        }

                        // 带图标的按钮（使用 Label）
                        Button {
                            isFavorited.toggle()
                            lastAction = isFavorited ? "已加入收藏" : "已取消收藏"
                        } label: {
                            // Label 自动组合图标和文字
                            Label(isFavorited ? "取消收藏" : "加入收藏",
                                  systemImage: isFavorited ? "heart.fill" : "heart")
                        }

                        Text("最近操作：\(lastAction)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(8)
                }

                // ── 2. 按钮样式 ──
                GroupBox("🎨 内置按钮样式") {
                    VStack(spacing: 12) {
                        // .borderedProminent：最突出的填充样式
                        Button("立即借阅") { lastAction = "使用 borderedProminent" }
                            .buttonStyle(.borderedProminent)

                        // .bordered：带边框的样式
                        Button("预约借阅") { lastAction = "使用 bordered" }
                            .buttonStyle(.bordered)

                        // .borderless：无边框（最低调）
                        Button("查看详情") { lastAction = "使用 borderless" }
                            .buttonStyle(.borderless)

                        // .plain：纯文本，无任何修饰
                        Button("忽略") { lastAction = "使用 plain" }
                            .buttonStyle(.plain)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(8)
                }

                // ── 3. 按钮角色（Role）──
                GroupBox("⚠️ 按钮角色") {
                    HStack(spacing: 16) {
                        // .destructive：破坏性操作（系统自动变为红色）
                        Button("删除记录", role: .destructive) {
                            lastAction = "触发了删除操作"
                        }
                        .buttonStyle(.borderedProminent)

                        // .cancel：取消操作
                        Button("取消", role: .cancel) {
                            lastAction = "取消操作"
                        }
                        .buttonStyle(.bordered)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(8)
                }

                // ── 4. 自定义样式按钮 ──
                GroupBox("✨ 自定义样式") {
                    VStack(spacing: 12) {
                        // 自定义外观：组合 Image + Text + 修饰符
                        Button {
                            isReserved.toggle()
                            lastAction = isReserved ? "预约成功！" : "已取消预约"
                        } label: {
                            HStack {
                                Image(systemName: isReserved ? "checkmark.circle.fill" : "calendar.badge.plus")
                                Text(isReserved ? "已预约" : "预约此书")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            // 根据状态切换颜色
                            .background(isReserved ? Color.green : Color.accentColor)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        // .buttonStyle(.plain) 防止系统覆盖自定义颜色
                        .buttonStyle(.plain)
                    }
                    .padding(8)
                }

                ConceptNote(items: [
                    "Button(title) {}：最简写法，标题和动作",
                    "Button {} label: {}：自定义外观的写法",
                    ".buttonStyle()：设置内置样式，如 .borderedProminent / .bordered",
                    "role: .destructive：破坏性操作，系统自动标红",
                    ".buttonStyle(.plain)：禁止系统覆盖自定义样式，自定义按钮时必用"
                ])
            }
            .padding()
        }
        .navigationTitle("Button 按钮")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ButtonDemoView()
    }
}
