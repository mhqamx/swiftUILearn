//
//  PickerDemoView.swift
//  swiftUILearn
//
//  【知识点】Picker 选择器
//  场景：分类选择、阅读状态、日期选择、颜色选择
//

import SwiftUI

struct PickerDemoView: View {
    @State private var selectedCategory = "文学"
    @State private var readingStatus = "在读"
    @State private var borrowDate = Date()
    @State private var returnDate = Date().addingTimeInterval(30 * 24 * 3600)
    @State private var themeColor = Color.blue
    @State private var selectedRating = 3

    private let categories = ["文学", "科技", "历史", "艺术", "哲学", "教育"]
    private let statuses = ["想读", "在读", "已读", "弃读"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                DemoHeader(
                    title: "Picker 选择器",
                    subtitle: "Picker 是通用选择控件，支持多种样式；DatePicker 和 ColorPicker 是专用选择器。"
                )

                // ── 1. Menu 样式 ──
                GroupBox("📚 分类选择（.menu）") {
                    VStack(alignment: .leading, spacing: 12) {
                        Picker("书籍分类", selection: $selectedCategory) {
                            ForEach(categories, id: \.self) { category in
                                Text(category).tag(category)
                            }
                        }
                        .pickerStyle(.menu)

                        Text("当前选择：\(selectedCategory)")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Text(".menu 是默认样式，点击弹出下拉菜单")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    .padding(8)
                }

                // ── 2. Segmented 样式 ──
                GroupBox("📖 阅读状态（.segmented）") {
                    VStack(spacing: 12) {
                        Picker("阅读状态", selection: $readingStatus) {
                            ForEach(statuses, id: \.self) { status in
                                Text(status).tag(status)
                            }
                        }
                        .pickerStyle(.segmented)

                        HStack {
                            Image(systemName: statusIcon(readingStatus))
                                .foregroundStyle(statusColor(readingStatus))
                            Text("状态：\(readingStatus)")
                                .font(.subheadline)
                        }
                    }
                    .padding(8)
                }

                // ── 3. DatePicker ──
                GroupBox("📅 DatePicker 日期选择") {
                    VStack(spacing: 12) {
                        DatePicker("借阅日期", selection: $borrowDate, displayedComponents: .date)

                        DatePicker("归还日期", selection: $returnDate, in: borrowDate..., displayedComponents: .date)

                        let days = Calendar.current.dateComponents([.day], from: borrowDate, to: returnDate).day ?? 0
                        Text("借阅天数：\(days) 天")
                            .font(.caption)
                            .foregroundStyle(.orange)
                    }
                    .padding(8)
                }

                // ── 4. ColorPicker ──
                GroupBox("🎨 ColorPicker 颜色选择") {
                    VStack(spacing: 12) {
                        ColorPicker("选择主题色", selection: $themeColor)

                        RoundedRectangle(cornerRadius: 12)
                            .fill(themeColor.gradient)
                            .frame(height: 80)
                            .overlay {
                                VStack {
                                    Image(systemName: "book.fill")
                                        .font(.title)
                                    Text("主题预览")
                                        .font(.caption)
                                }
                                .foregroundStyle(.white)
                            }
                    }
                    .padding(8)
                }

                // ── 5. Wheel 样式 ──
                GroupBox("🎡 .wheel 滚轮样式") {
                    VStack(spacing: 12) {
                        Text("选择评分")
                            .font(.subheadline.bold())

                        Picker("评分", selection: $selectedRating) {
                            ForEach(1...5, id: \.self) { rating in
                                Text("\(rating) 星").tag(rating)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(height: 100)

                        HStack(spacing: 4) {
                            ForEach(1...5, id: \.self) { star in
                                Image(systemName: star <= selectedRating ? "star.fill" : "star")
                                    .foregroundStyle(star <= selectedRating ? .yellow : .gray)
                            }
                        }
                    }
                    .padding(8)
                }

                ConceptNote(items: [
                    "Picker(selection:)：通用选择器，支持 .menu/.segmented/.wheel 等样式",
                    "DatePicker：日期选择，displayedComponents 控制显示日期或时间",
                    "DatePicker(in: range)：限制可选日期范围",
                    "ColorPicker：颜色选择器，返回 Color 值",
                    ".pickerStyle()：切换 Picker 的外观样式"
                ])
            }
            .padding()
        }
        .navigationTitle("Picker 选择器")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func statusIcon(_ status: String) -> String {
        switch status {
        case "想读": return "bookmark"
        case "在读": return "book.fill"
        case "已读": return "checkmark.circle.fill"
        case "弃读": return "xmark.circle"
        default: return "questionmark"
        }
    }

    private func statusColor(_ status: String) -> Color {
        switch status {
        case "想读": return .blue
        case "在读": return .orange
        case "已读": return .green
        case "弃读": return .red
        default: return .gray
        }
    }
}

#Preview {
    NavigationStack {
        PickerDemoView()
    }
}
