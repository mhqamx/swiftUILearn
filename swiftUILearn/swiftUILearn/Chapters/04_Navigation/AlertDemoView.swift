//
//  AlertDemoView.swift
//  swiftUILearn
//
//  【知识点】Alert 警告弹窗 & ConfirmationDialog
//  场景：删除书籍确认、借阅期限提醒、操作选择菜单
//

import SwiftUI

struct AlertDemoView: View {
    @State private var showDeleteAlert = false
    @State private var showOverdueAlert = false
    @State private var showActionDialog = false
    @State private var showCustomAlert = false
    @State private var resultMessage = ""
    @State private var selectedBook = "《活着》"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                DemoHeader(
                    title: "Alert & Dialog",
                    subtitle: "Alert 用于警告或确认，ConfirmationDialog 用于提供多个操作选项。"
                )

                if !resultMessage.isEmpty {
                    Text("操作结果：\(resultMessage)")
                        .font(.footnote)
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.green.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                // ── 1. 基础 Alert ──
                GroupBox("⚠️ 删除确认 Alert") {
                    VStack(spacing: 12) {
                        Button("删除书籍记录", role: .destructive) {
                            showDeleteAlert = true
                        }
                        .buttonStyle(.bordered)
                        // .alert(title, isPresented: $bool) { 按钮 } message: { 内容 }
                        .alert("确认删除？", isPresented: $showDeleteAlert) {
                            // 定义按钮
                            Button("删除", role: .destructive) {
                                resultMessage = "已删除 \(selectedBook)"
                            }
                            // .cancel 按钮系统自动放在左侧/底部
                            Button("取消", role: .cancel) {
                                resultMessage = "取消删除"
                            }
                        } message: {
                            Text("删除后将无法恢复，确定要删除 \(selectedBook) 的记录吗？")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(8)
                }

                // ── 2. 带文本输入的 Alert ──
                GroupBox("🔔 逾期提醒 Alert") {
                    VStack(spacing: 12) {
                        Button("模拟逾期提醒") {
                            showOverdueAlert = true
                        }
                        .buttonStyle(.bordered)
                        .tint(.orange)
                        .alert("借阅逾期提醒", isPresented: $showOverdueAlert) {
                            Button("立即续借") {
                                resultMessage = "已续借 14 天"
                            }
                            Button("前往还书") {
                                resultMessage = "已标记还书"
                            }
                            Button("稍后提醒", role: .cancel) {
                                resultMessage = "将在明天提醒"
                            }
                        } message: {
                            Text("\(selectedBook) 已逾期 3 天，请尽快归还或续借。")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(8)
                }

                // ── 3. ConfirmationDialog（操作菜单）──
                GroupBox("📋 ConfirmationDialog 操作菜单") {
                    VStack(spacing: 12) {
                        Button {
                            showActionDialog = true
                        } label: {
                            Label("书籍操作", systemImage: "ellipsis.circle")
                        }
                        .buttonStyle(.bordered)
                        // .confirmationDialog 从底部弹出操作菜单（类似 ActionSheet）
                        .confirmationDialog("请选择操作", isPresented: $showActionDialog,
                                            titleVisibility: .visible) {
                            Button("借阅此书") { resultMessage = "已借阅 \(selectedBook)" }
                            Button("加入书单") { resultMessage = "已加入书单" }
                            Button("预约借阅") { resultMessage = "已预约" }
                            Button("删除记录", role: .destructive) {
                                resultMessage = "已删除记录"
                            }
                            Button("取消", role: .cancel) {}
                        }

                        Text("ConfirmationDialog 适合提供多个操作选项，在底部弹出")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(8)
                }

                ConceptNote(items: [
                    ".alert(title, isPresented: $bool) { buttons } message: { text }：标准警告",
                    "Button(role: .destructive)：红色破坏性按钮",
                    "Button(role: .cancel)：取消按钮，系统自动处理样式和位置",
                    ".confirmationDialog(title, isPresented: $bool)：底部操作菜单",
                    "titleVisibility: .visible：控制 Dialog 标题是否显示"
                ])
            }
            .padding()
        }
        .navigationTitle("Alert & Dialog")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        AlertDemoView()
    }
}
