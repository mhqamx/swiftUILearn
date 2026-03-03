//
//  StacksDemoView.swift
//  swiftUILearn
//
//  【知识点】VStack / HStack / ZStack 堆叠布局
//  场景：书籍卡片、书架行布局
//

import SwiftUI

struct StacksDemoView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                DemoHeader(
                    title: "Stack 堆叠布局",
                    subtitle: "VStack（垂直）、HStack（水平）、ZStack（层叠）是 SwiftUI 布局的三大基础容器。"
                )

                // ── 1. VStack：垂直排列 ──
                GroupBox("⬇️ VStack — 垂直堆叠") {
                    // VStack(alignment: 水平对齐, spacing: 间距)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("《活着》").font(.headline)
                        Text("余华 著").font(.subheadline).foregroundStyle(.secondary)
                        Text("中国当代文学经典，感人至深。").font(.caption).foregroundStyle(.secondary)

                        HStack(spacing: 4) {
                            ForEach(0..<5) { _ in
                                Image(systemName: "star.fill").foregroundStyle(.orange)
                            }
                        }
                        .font(.caption)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(12)
                    .background(Color.blue.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(8)
                }

                // ── 2. HStack：水平排列 ──
                GroupBox("➡️ HStack — 水平堆叠") {
                    // HStack(alignment: 垂直对齐, spacing: 间距)
                    HStack(alignment: .center, spacing: 12) {
                        // 书籍封面（模拟）
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.red.gradient)
                            .frame(width: 56, height: 72)
                            .overlay {
                                Image(systemName: "book.fill")
                                    .foregroundStyle(.white)
                            }

                        // 书籍信息（VStack 嵌套在 HStack 中）
                        VStack(alignment: .leading, spacing: 4) {
                            Text("三体").font(.headline)
                            Text("刘慈欣 著").font(.subheadline).foregroundStyle(.secondary)
                            Text("科幻").font(.caption)
                                .padding(.horizontal, 8).padding(.vertical, 2)
                                .background(Color.blue.opacity(0.15))
                                .clipShape(Capsule())
                        }

                        Spacer() // 把后面的内容推到右边

                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                    }
                    .padding(12)
                    .background(Color.green.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(8)
                }

                // ── 3. ZStack：层叠排列 ──
                GroupBox("🗂 ZStack — 层叠堆叠") {
                    // ZStack 的子视图按顺序从下往上叠放
                    // alignment 参数控制子视图对齐基准点
                    ZStack(alignment: .topTrailing) {
                        // 底层：书籍封面背景
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.purple.gradient)
                            .frame(height: 120)

                        // 中层：书名文字
                        VStack(spacing: 4) {
                            Text("百年孤独").font(.title2.bold()).foregroundStyle(.white)
                            Text("加西亚·马尔克斯").font(.footnote).foregroundStyle(.white.opacity(0.8))
                        }

                        // 顶层：右上角新书角标（叠放在最上面）
                        Text("NEW")
                            .font(.caption2.bold())
                            .foregroundStyle(.white)
                            .padding(.horizontal, 6).padding(.vertical, 2)
                            .background(Color.red)
                            .clipShape(Capsule())
                            .padding(8)
                    }
                    .padding(8)
                }

                // ── 4. 嵌套组合 ──
                GroupBox("🔗 Stack 嵌套：书架行") {
                    // 实际项目中经常嵌套多层
                    HStack(spacing: 10) {
                        ForEach(["红楼梦", "西游记", "水浒传", "三国演义"], id: \.self) { name in
                            BookSpineView(title: name)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(8)
                }

                ConceptNote(items: [
                    "VStack(alignment: .leading, spacing: 8)：垂直布局，.leading 左对齐",
                    "HStack(alignment: .center, spacing: 12)：水平布局，.center 居中对齐",
                    "ZStack(alignment: .topTrailing)：层叠布局，后写的视图在最上层",
                    "Spacer()：弹性空白，把同级视图推到两端",
                    "嵌套使用：HStack 内嵌 VStack 是最常见的卡片布局模式"
                ])
            }
            .padding()
        }
        .navigationTitle("Stack 布局")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 书脊视图（模拟书架中竖排的书）
private struct BookSpineView: View {
    let title: String

    // 根据书名生成固定颜色（确保同一本书颜色不变）
    var color: Color {
        let colors: [Color] = [.red, .blue, .green, .orange]
        let index = abs(title.hashValue) % colors.count
        return colors[index]
    }

    var body: some View {
        // ZStack 实现竖排文字效果
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(color.gradient)
                .frame(width: 36, height: 90)

            Text(title)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.white)
                .rotationEffect(.degrees(-90)) // 旋转90度模拟书脊文字
                .lineLimit(1)
                .frame(width: 80)
        }
    }
}

#Preview {
    NavigationStack {
        StacksDemoView()
    }
}
