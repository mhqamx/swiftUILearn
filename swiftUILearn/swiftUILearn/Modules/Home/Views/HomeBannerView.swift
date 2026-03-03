//
//  HomeBannerView.swift
//  swiftUILearn
//
//  首页自动轮播 Banner
//

import SwiftUI

struct HomeBannerView: View {
    let items: [NewsArticle]

    // 当前显示的 Banner 索引
    @State private var currentIndex = 0

    // 用于渐变效果的颜色池
    private let colors: [Color] = [.blue, .purple, .orange, .teal, .pink]

    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, article in
                BannerCard(article: article, color: colors[index % colors.count])
                    .tag(index)
            }
        }
        // .tabViewStyle(.page)：变为可左右滑动的分页视图（轮播效果）
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .frame(height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        // 自动轮播：每3秒切换一次
        .onAppear { startAutoPlay() }
    }

    private func startAutoPlay() {
        guard !items.isEmpty else { return }
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                currentIndex = (currentIndex + 1) % items.count
            }
        }
    }
}

/// 单个 Banner 卡片
private struct BannerCard: View {
    let article: NewsArticle
    let color: Color

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // 渐变背景
            LinearGradient(
                colors: [color.opacity(0.8), color],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            // 装饰圆圈
            Circle()
                .fill(.white.opacity(0.1))
                .frame(width: 120)
                .offset(x: 200, y: -60)

            // 文字内容
            VStack(alignment: .leading, spacing: 6) {
                Text(article.category)
                    .font(.caption.bold())
                    .padding(.horizontal, 8).padding(.vertical, 3)
                    .background(.white.opacity(0.25))
                    .clipShape(Capsule())

                Text(article.formattedTitle)
                    .font(.headline)
                    .lineLimit(2)

                Text(article.publishedAt)
                    .font(.caption)
                    .opacity(0.8)
            }
            .foregroundStyle(.white)
            .padding(16)
        }
    }
}
