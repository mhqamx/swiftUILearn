//
//  ChartsDemoView.swift
//  swiftUILearn
//
//  【知识点】Swift Charts 图表
//  场景：阅读统计、趋势分析、分类分布
//

import SwiftUI
import Charts

struct ChartsDemoView: View {
    // 月度阅读数据
    private let monthlyData: [MonthlyReading] = [
        .init(month: "1月", count: 3),
        .init(month: "2月", count: 5),
        .init(month: "3月", count: 2),
        .init(month: "4月", count: 7),
        .init(month: "5月", count: 4),
        .init(month: "6月", count: 6)
    ]

    // 阅读趋势
    private let trendData: [ReadingTrend] = [
        .init(week: 1, pages: 50),
        .init(week: 2, pages: 80),
        .init(week: 3, pages: 65),
        .init(week: 4, pages: 120),
        .init(week: 5, pages: 95),
        .init(week: 6, pages: 140),
        .init(week: 7, pages: 110),
        .init(week: 8, pages: 160)
    ]

    // 分类分布
    private let categoryData: [CategoryShare] = [
        .init(name: "文学", count: 12, color: .blue),
        .init(name: "科技", count: 8, color: .green),
        .init(name: "历史", count: 5, color: .orange),
        .init(name: "哲学", count: 3, color: .purple),
        .init(name: "艺术", count: 4, color: .pink)
    ]

    @State private var selectedMonth: String?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                DemoHeader(
                    title: "Swift Charts 图表",
                    subtitle: "Swift Charts 是 Apple 原生图表框架，支持柱状图、折线图、扇形图等多种图表类型。"
                )

                // ── 1. BarMark ──
                GroupBox("📊 BarMark 柱状图") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("月度阅读量")
                            .font(.subheadline.bold())

                        Chart(monthlyData) { item in
                            BarMark(
                                x: .value("月份", item.month),
                                y: .value("数量", item.count)
                            )
                            .foregroundStyle(Color.blue.gradient)
                            .cornerRadius(4)
                            .annotation(position: .top) {
                                Text("\(item.count)")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .frame(height: 200)
                        .chartYAxis {
                            AxisMarks(position: .leading)
                        }
                    }
                    .padding(8)
                }

                // ── 2. LineMark ──
                GroupBox("📈 LineMark 折线图") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("每周阅读页数趋势")
                            .font(.subheadline.bold())

                        Chart(trendData) { item in
                            LineMark(
                                x: .value("周", "第\(item.week)周"),
                                y: .value("页数", item.pages)
                            )
                            .foregroundStyle(Color.green)
                            .interpolationMethod(.catmullRom)

                            AreaMark(
                                x: .value("周", "第\(item.week)周"),
                                y: .value("页数", item.pages)
                            )
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.green.opacity(0.3), .green.opacity(0.05)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .interpolationMethod(.catmullRom)

                            PointMark(
                                x: .value("周", "第\(item.week)周"),
                                y: .value("页数", item.pages)
                            )
                            .foregroundStyle(Color.green)
                        }
                        .frame(height: 200)
                    }
                    .padding(8)
                }

                // ── 3. SectorMark ──
                GroupBox("🍰 SectorMark 扇形图") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("书籍分类分布")
                            .font(.subheadline.bold())

                        Chart(categoryData) { item in
                            SectorMark(
                                angle: .value("数量", item.count),
                                innerRadius: .ratio(0.5),
                                angularInset: 2
                            )
                            .foregroundStyle(by: .value("分类", item.name))
                            .cornerRadius(4)
                        }
                        .frame(height: 200)
                        .chartLegend(position: .bottom, spacing: 16)

                        // 图例补充
                        HStack {
                            ForEach(categoryData) { item in
                                VStack {
                                    Text("\(item.count)")
                                        .font(.caption.bold())
                                    Text(item.name)
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(8)
                }

                // ── 4. 图表定制 ──
                GroupBox("🎨 图表定制") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("自定义颜色、标注和坐标轴")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Chart(monthlyData) { item in
                            BarMark(
                                x: .value("月份", item.month),
                                y: .value("数量", item.count)
                            )
                            .foregroundStyle(item.count >= 5 ? Color.green : Color.orange)

                            RuleMark(y: .value("目标", 5))
                                .foregroundStyle(.red)
                                .lineStyle(StrokeStyle(dash: [5, 3]))
                                .annotation(position: .top, alignment: .trailing) {
                                    Text("目标: 5本")
                                        .font(.caption2)
                                        .foregroundStyle(.red)
                                }
                        }
                        .frame(height: 180)
                        .chartYScale(domain: 0...10)
                        .chartXAxis {
                            AxisMarks { _ in
                                AxisValueLabel()
                            }
                        }
                    }
                    .padding(8)
                }

                ConceptNote(items: [
                    "Chart：图表容器，接收数据集合",
                    "BarMark：柱状图标记，x/y 指定数据映射",
                    "LineMark / AreaMark：折线图和面积图",
                    "SectorMark：扇形图（iOS 17+），innerRadius 设置内圈半径",
                    "RuleMark：参考线，常用于显示目标值",
                    ".chartForegroundStyleScale：自定义图表配色方案"
                ])
            }
            .padding()
        }
        .navigationTitle("Swift Charts")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 数据模型
private struct MonthlyReading: Identifiable {
    let id = UUID()
    let month: String
    let count: Int
}

private struct ReadingTrend: Identifiable {
    let id = UUID()
    let week: Int
    let pages: Int
}

private struct CategoryShare: Identifiable {
    let id = UUID()
    let name: String
    let count: Int
    let color: Color
}

#Preview {
    NavigationStack {
        ChartsDemoView()
    }
}
