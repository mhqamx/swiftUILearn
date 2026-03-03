//
//  BasicAnimationDemoView.swift
//  swiftUILearn
//
//  【知识点】基础动画
//  场景：书籍借阅动画、评分星星弹跳效果
//

import SwiftUI

struct BasicAnimationDemoView: View {
    // 动画状态变量
    @State private var scale: CGFloat = 1.0
    @State private var rotation: Double = 0
    @State private var isExpanded = false
    @State private var opacity: Double = 1.0
    @State private var offset: CGFloat = 0
    @State private var isBorrowed = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                DemoHeader(
                    title: "基础动画",
                    subtitle: "SwiftUI 动画分两种：隐式动画（.animation修饰符）和显式动画（withAnimation块）。"
                )

                // ── 1. withAnimation 显式动画 ──
                GroupBox("🎬 withAnimation 显式动画") {
                    VStack(spacing: 16) {
                        // 借阅书籍动画
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(isBorrowed ? Color.green.gradient : Color.blue.gradient)
                                .frame(width: 80, height: 110)
                                .overlay {
                                    Image(systemName: isBorrowed ? "checkmark.circle.fill" : "book.fill")
                                        .font(.title)
                                        .foregroundStyle(.white)
                                }
                                // 隐式动画：当 scaleEffect 的值变化时自动动画
                                .scaleEffect(isBorrowed ? 1.1 : 1.0)
                                .rotationEffect(.degrees(isBorrowed ? 5 : 0))
                        }
                        .frame(height: 120)

                        Button(isBorrowed ? "归还书籍" : "借阅此书") {
                            // withAnimation：包裹的状态改变都会附带动画
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                                isBorrowed.toggle()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(isBorrowed ? .orange : .blue)

                        Text("withAnimation 明确指定哪些状态改变需要动画")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(8)
                }

                // ── 2. 动画类型 ──
                GroupBox("⚡️ 动画类型对比") {
                    VStack(spacing: 12) {
                        AnimTypeRow(label: ".easeInOut") {
                            withAnimation(.easeInOut(duration: 0.5)) { scale = scale == 1.0 ? 1.5 : 1.0 }
                        }
                        AnimTypeRow(label: ".spring") {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.4)) {
                                scale = scale == 1.0 ? 1.5 : 1.0
                            }
                        }
                        AnimTypeRow(label: ".bouncy") {
                            withAnimation(.bouncy) { scale = scale == 1.0 ? 1.5 : 1.0 }
                        }
                        AnimTypeRow(label: ".linear") {
                            withAnimation(.linear(duration: 0.5)) { rotation += 180 }
                        }

                        // 演示用的图书图标
                        Image(systemName: "book.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(.blue)
                            .scaleEffect(scale)
                            .rotationEffect(.degrees(rotation))
                    }
                    .padding(8)
                }

                // ── 3. 隐式动画（.animation 修饰符）──
                GroupBox("🔄 .animation 隐式动画") {
                    VStack(spacing: 12) {
                        Text("展开书籍简介")
                            .font(.headline)

                        Button {
                            isExpanded.toggle()
                        } label: {
                            Label(isExpanded ? "收起" : "展开",
                                  systemImage: isExpanded ? "chevron.up" : "chevron.down")
                        }
                        .buttonStyle(.bordered)

                        if isExpanded {
                            Text("这是一段关于书籍的简介内容，展开后才会显示，使用 animation 修饰符让其平滑出现。")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                                .transition(.opacity.combined(with: .scale(scale: 0.9, anchor: .top)))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    // .animation(动画类型, value: 触发值)
                    // 当 isExpanded 改变时，这个 GroupBox 内的所有视图变化都会有动画
                    .animation(.easeInOut(duration: 0.3), value: isExpanded)
                    .padding(8)
                }

                // ── 4. 动画修饰符 ──
                GroupBox("🎛 常用动画相关修饰符") {
                    VStack(spacing: 12) {
                        // .offset：位移
                        HStack {
                            Button("抖动提示") {
                                withAnimation(.spring(response: 0.2, dampingFraction: 0.3).repeatCount(3)) {
                                    offset = offset == 0 ? 8 : 0
                                }
                            }
                            .buttonStyle(.bordered)

                            Image(systemName: "bell.fill")
                                .foregroundStyle(.orange)
                                .offset(x: offset)
                        }
                    }
                    .padding(8)
                }

                ConceptNote(items: [
                    "withAnimation(.spring) {}：显式动画，推荐使用，精确控制哪些变化有动画",
                    ".animation(.easeInOut, value:)：隐式动画，value 变化时触发",
                    ".spring(response:dampingFraction:)：弹簧动画，response越小越快，damping越小弹跳越多",
                    ".bouncy：iOS 17+ 快捷弹跳动画",
                    ".repeatCount(n) / .repeatForever()：重复动画次数"
                ])
            }
            .padding()
        }
        .navigationTitle("基础动画")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct AnimTypeRow: View {
    let label: String
    let action: () -> Void

    var body: some View {
        HStack {
            Text(label)
                .font(.caption.monospaced())
                .foregroundStyle(.orange)
            Spacer()
            Button("触发") { action() }
                .font(.caption)
                .buttonStyle(.bordered)
        }
    }
}

#Preview {
    NavigationStack {
        BasicAnimationDemoView()
    }
}
