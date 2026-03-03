//
//  SliderDemoView.swift
//  swiftUILearn
//
//  【知识点】Slider 滑块
//  场景：图书馆评分系统、借阅天数选择
//

import SwiftUI

struct SliderDemoView: View {
    // Slider 绑定 Double 类型
    @State private var rating: Double = 3.0        // 评分 1-5
    @State private var borrowDays: Double = 7.0    // 借阅天数 1-30
    @State private var fontSize: Double = 16.0     // 字体大小预览

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                DemoHeader(
                    title: "Slider 滑块",
                    subtitle: "Slider 用于在指定范围内选择连续值，绑定 Double 类型变量。"
                )

                // ── 1. 基础评分滑块 ──
                GroupBox("⭐️ 书籍评分") {
                    VStack(spacing: 16) {
                        // 显示当前评分（用 String(format:) 格式化小数）
                        HStack {
                            Text("评分")
                            Spacer()
                            Text(String(format: "%.1f / 5.0", rating))
                                .bold()
                                .foregroundStyle(.orange)
                        }

                        // Slider(value: $var, in: min...max)
                        // step: 设置步长（可选）
                        Slider(value: $rating, in: 1...5, step: 0.5)
                            .tint(.orange)  // 修改滑块颜色

                        // 用图标直观展示评分
                        HStack(spacing: 4) {
                            ForEach(1...5, id: \.self) { star in
                                Image(systemName: rating >= Double(star) ? "star.fill" : "star")
                                    .foregroundStyle(.orange)
                            }
                        }
                        .font(.title2)
                        .animation(.easeInOut(duration: 0.1), value: rating)
                    }
                    .padding(8)
                }

                // ── 2. 借阅天数选择 ──
                GroupBox("📅 借阅天数") {
                    VStack(spacing: 12) {
                        HStack {
                            Text("借阅期限")
                            Spacer()
                            Text("\(Int(borrowDays)) 天")
                                .bold()
                                .foregroundStyle(.blue)
                        }

                        // 带最小/最大标签的 Slider
                        Slider(value: $borrowDays, in: 1...30, step: 1) {
                            // label：无障碍标签（VoiceOver 使用）
                            Text("借阅天数")
                        } minimumValueLabel: {
                            Text("1天").font(.caption).foregroundStyle(.secondary)
                        } maximumValueLabel: {
                            Text("30天").font(.caption).foregroundStyle(.secondary)
                        }

                        // 根据天数变化显示不同提示
                        let message: String = {
                            switch Int(borrowDays) {
                            case 1...7:   return "短期借阅，适合快速阅读"
                            case 8...14:  return "标准借阅期限"
                            case 15...21: return "长期借阅，请注意归还"
                            default:      return "超长期借阅，需要馆长审批"
                            }
                        }()
                        Text(message)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(8)
                }

                // ── 3. 实时预览效果 ──
                GroupBox("🔤 字体大小预览") {
                    VStack(spacing: 12) {
                        HStack {
                            Text("字号：\(Int(fontSize))pt").font(.caption)
                            Spacer()
                            Slider(value: $fontSize, in: 10...32, step: 1)
                                .frame(width: 160)
                        }

                        Text("《活着》是中国当代著名小说")
                            .font(.system(size: fontSize))
                            .animation(.easeInOut(duration: 0.1), value: fontSize)
                    }
                    .padding(8)
                }

                ConceptNote(items: [
                    "Slider(value: $var, in: range)：基础用法，绑定 Double 类型",
                    "step: 1：设置步长，整数步长配合 Int() 转换使用",
                    "minimumValueLabel / maximumValueLabel：显示两端标签",
                    ".tint(color)：修改滑块和进度条颜色",
                    "String(format: \"%.1f\", value)：格式化小数显示"
                ])
            }
            .padding()
        }
        .navigationTitle("Slider 滑块")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SliderDemoView()
    }
}
