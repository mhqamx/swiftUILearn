//
//  HomeView.swift
//  swiftUILearn
//
//  首页视图
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 20) {

                    // ── 状态处理 ──
                    if viewModel.isLoading && viewModel.banners.isEmpty {
                        LoadingView()
                            .frame(height: 300)
                    } else if let error = viewModel.error, viewModel.banners.isEmpty {
                        ErrorView(error: error) {
                            Task { await viewModel.loadAll() }
                        }
                        .frame(height: 300)
                    } else {
                        // ── 轮播 Banner ──
                        if !viewModel.banners.isEmpty {
                            HomeBannerView(items: viewModel.banners)
                                .padding(.horizontal)
                        }

                        // ── 快速入口 ──
                        QuickEntrySection()

                        // ── 推荐内容 ──
                        if !viewModel.recommends.isEmpty {
                            SectionHeader(title: "🔥 热门推荐", subtitle: "查看全部")
                                .padding(.horizontal)

                            ForEach(viewModel.recommends) { article in
                                NavigationLink {
                                    NewsDetailView(article: article)
                                } label: {
                                    HomeRecommendRow(article: article)
                                        .padding(.horizontal)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("首页")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // 搜索
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // 消息
                    } label: {
                        Image(systemName: "bell")
                    }
                }
            }
            .refreshable {
                // 下拉刷新（系统自带动画）
                await viewModel.refresh()
            }
        }
        .task {
            // 视图出现时加载数据
            await viewModel.loadAll()
        }
    }
}

// MARK: - 快速入口九宫格
private struct QuickEntrySection: View {
    private let entries = [
        ("flame.fill", "热点", Color.red),
        ("cart.fill", "商城", Color.orange),
        ("newspaper.fill", "资讯", Color.blue),
        ("person.2.fill", "社区", Color.green),
        ("video.fill", "视频", Color.purple),
        ("music.note", "音乐", Color.pink),
        ("gamecontroller.fill", "游戏", Color.teal),
        ("ellipsis", "更多", Color.gray),
    ]

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16) {
            ForEach(entries, id: \.0) { icon, label, color in
                VStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(color.opacity(0.12))
                        .frame(width: 52, height: 52)
                        .overlay {
                            Image(systemName: icon)
                                .font(.title3)
                                .foregroundStyle(color)
                        }
                    Text(label)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - 推荐内容行
private struct HomeRecommendRow: View {
    let article: NewsArticle

    var body: some View {
        HStack(spacing: 12) {
            // 图片占位（实际项目替换为 AsyncImage）
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.blue.opacity(0.15))
                .frame(width: 80, height: 60)
                .overlay {
                    Image(systemName: "newspaper.fill")
                        .foregroundStyle(.blue.opacity(0.5))
                }

            VStack(alignment: .leading, spacing: 6) {
                Text(article.formattedTitle)
                    .font(.subheadline.bold())
                    .lineLimit(2)

                HStack(spacing: 8) {
                    Text(article.category)
                        .font(.caption2)
                        .padding(.horizontal, 6).padding(.vertical, 2)
                        .background(Color.blue.opacity(0.1))
                        .foregroundStyle(.blue)
                        .clipShape(Capsule())

                    Text(article.publishedAt)
                        .font(.caption2)
                        .foregroundStyle(.secondary)

                    Spacer()

                    Text("\(article.readCount) 阅读")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(12)
        .background(Color.primary.opacity(0.03))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Section 标题栏
struct SectionHeader: View {
    let title: String
    let subtitle: String?

    init(title: String, subtitle: String? = nil) {
        self.title = title
        self.subtitle = subtitle
    }

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
            if let subtitle {
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    HomeView()
}
