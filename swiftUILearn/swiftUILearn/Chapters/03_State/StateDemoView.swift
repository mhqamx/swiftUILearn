//
//  StateDemoView.swift
//  swiftUILearn
//
//  【知识点】@State 本地状态
//  场景：借阅计数器、收藏状态切换
//

import SwiftUI

struct StateDemoView: View {
    // @State：视图内部的私有状态
    // - 当 @State 变量的值改变时，SwiftUI 自动重新渲染视图
    // - 必须用 private 修饰，强调这是视图私有的
    // - 只能在视图内部修改（通过 $binding 传给子视图除外）
    @State private var borrowCount = 0
    @State private var isFavorited = false
    @State private var currentRating = 0
    @State private var showDetails = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                DemoHeader(
                    title: "@State 本地状态",
                    subtitle: "@State 是视图内部的私有可变状态。值改变时，SwiftUI 自动重新渲染整个视图。"
                )

                // ── 1. 借阅计数器 ──
                GroupBox("📊 借阅计数器") {
                    VStack(spacing: 16) {
                        // 显示 @State 变量的当前值
                        Text("\(borrowCount)")
                            .font(.system(size: 64, weight: .bold, design: .rounded))
                            .foregroundStyle(.blue)

                        Text("本书被借阅次数")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        HStack(spacing: 20) {
                            Button {
                                // 修改 @State 变量，触发视图重绘
                                if borrowCount > 0 { borrowCount -= 1 }
                            } label: {
                                Image(systemName: "minus.circle.fill")
                                    .font(.largeTitle)
                                    .foregroundStyle(.red)
                            }
                            .buttonStyle(.plain)

                            Button {
                                borrowCount += 1
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.largeTitle)
                                    .foregroundStyle(.green)
                            }
                            .buttonStyle(.plain)
                        }

                        Button("重置") {
                            // withAnimation 让数字归零时有动画
                            withAnimation {
                                borrowCount = 0
                            }
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(8)
                }

                // ── 2. 收藏状态切换 ──
                GroupBox("❤️ 收藏状态") {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("《活着》")
                                .font(.headline)
                            Text(isFavorited ? "已加入我的书单" : "点击收藏这本书")
                                .font(.caption)
                                .foregroundStyle(isFavorited ? .green : .secondary)
                        }
                        Spacer()
                        // @State 变量改变 → 视图重绘 → 图标和颜色更新
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                                isFavorited.toggle()
                            }
                        } label: {
                            Image(systemName: isFavorited ? "heart.fill" : "heart")
                                .font(.title2)
                                .foregroundStyle(isFavorited ? .red : .gray)
                                // 收藏时有弹跳缩放效果
                                .scaleEffect(isFavorited ? 1.2 : 1.0)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(8)
                }

                // ── 3. 评星交互 ──
                GroupBox("⭐️ 交互式评分") {
                    VStack(spacing: 12) {
                        HStack(spacing: 8) {
                            ForEach(1...5, id: \.self) { star in
                                Image(systemName: star <= currentRating ? "star.fill" : "star")
                                    .font(.title2)
                                    .foregroundStyle(star <= currentRating ? .orange : .gray)
                                    .onTapGesture {
                                        // 点击星星时更新评分
                                        withAnimation(.spring(response: 0.2)) {
                                            currentRating = star
                                        }
                                    }
                            }
                        }
                        Text(currentRating == 0 ? "点击评分" : "\(currentRating) 星 - \(ratingText)")
                            .font(.footnote)
                            .foregroundStyle(currentRating == 0 ? Color.secondary : Color.orange)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(8)
                }

                // ── 4. 条件渲染 ──
                GroupBox("👁 条件显示") {
                    VStack(spacing: 12) {
                        Button {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showDetails.toggle()
                            }
                        } label: {
                            Label(showDetails ? "收起详情" : "查看详情",
                                  systemImage: showDetails ? "chevron.up" : "chevron.down")
                        }
                        .buttonStyle(.bordered)

                        // @State 控制视图的显示/隐藏
                        if showDetails {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("出版社：南海出版公司")
                                Text("出版时间：2012年")
                                Text("页数：192页")
                                Text("馆藏位置：A区 3楼 F排")
                            }
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }
                    .padding(8)
                }

                ConceptNote(items: [
                    "@State private var：视图私有状态，值改变触发重绘",
                    "不要在视图外部修改 @State：它是视图独有的",
                    "withAnimation {}：让 @State 的值变化附带动画",
                    "@State 适合：计数器、开关、输入框文本、展开/收起等简单状态",
                    "复杂状态（多视图共享）应使用 @StateObject / @EnvironmentObject"
                ])
            }
            .padding()
        }
        .navigationTitle("@State 本地状态")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var ratingText: String {
        switch currentRating {
        case 1: return "很差"
        case 2: return "较差"
        case 3: return "一般"
        case 4: return "推荐"
        case 5: return "强烈推荐"
        default: return ""
        }
    }
}

#Preview {
    NavigationStack {
        StateDemoView()
    }
}
