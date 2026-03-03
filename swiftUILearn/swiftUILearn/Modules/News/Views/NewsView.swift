//
//  NewsView.swift
//  swiftUILearn
//
//  新闻模块主视图
//

import SwiftUI

struct NewsView: View {
    @StateObject private var viewModel = NewsViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.articles.isEmpty {
                    LoadingView(message: "加载新闻中...")
                } else if let error = viewModel.error, viewModel.articles.isEmpty {
                    ErrorView(error: error) {
                        Task { await viewModel.loadArticles() }
                    }
                } else if viewModel.filteredArticles.isEmpty {
                    EmptyStateView(
                        icon: "newspaper",
                        title: "没有找到相关新闻",
                        subtitle: "试试其他关键词"
                    )
                } else {
                    articleList
                }
            }
            .navigationTitle("新闻资讯")
            .searchable(text: $viewModel.searchText, prompt: "搜索新闻")
            .refreshable {
                await viewModel.refresh()
            }
        }
        .task {
            await viewModel.loadArticles()
        }
    }

    // MARK: - 文章列表

    private var articleList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.filteredArticles) { article in
                    NavigationLink {
                        NewsDetailView(article: article)
                    } label: {
                        NewsRowView(article: article)
                    }
                    .buttonStyle(.plain)
                    // 当滑动到最后3条时，触发加载更多
                    .onAppear {
                        if article.id == viewModel.filteredArticles.last?.id {
                            Task { await viewModel.loadMore() }
                        }
                    }
                }

                // 分页加载指示器
                if viewModel.isLoadingMore {
                    InlineLoadingView()
                }

                // 没有更多数据提示
                if !viewModel.hasMore && !viewModel.articles.isEmpty {
                    Text("— 已加载全部内容 —")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
            }
        }
    }
}

#Preview {
    NewsView()
}
