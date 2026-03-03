//
//  NewsViewModel.swift
//  swiftUILearn
//
//  新闻 ViewModel（含搜索 + 分页）
//

import Foundation
import Combine

@MainActor
class NewsViewModel: ObservableObject {

    // MARK: - Published
    @Published var articles: [NewsArticle] = []
    @Published var isLoading = false
    @Published var isLoadingMore = false
    @Published var error: APIError?
    @Published var searchText = ""
    @Published var hasMore = true

    // MARK: - 计算属性：搜索过滤
    var filteredArticles: [NewsArticle] {
        if searchText.isEmpty { return articles }
        return articles.filter {
            $0.title.localizedCaseInsensitiveContains(searchText)
            || $0.body.localizedCaseInsensitiveContains(searchText)
        }
    }

    private var currentPage = 1
    private let pageSize = 15
    private let network: NetworkManager

    // Combine：监听 searchText 变化，防抖 0.3 秒后过滤
    private var cancellables = Set<AnyCancellable>()

    init(network: NetworkManager = .shared) {
        self.network = network
    }

    // MARK: - 加载新闻

    func loadArticles() async {
        guard !isLoading else { return }
        isLoading = true
        error = nil
        currentPage = 1

        do {
            let result = try await network.request(
                .newsList(page: currentPage),
                as: [NewsArticle].self
            )
            articles = result
            hasMore = result.count >= pageSize
            currentPage += 1
        } catch let apiError as APIError {
            error = apiError
        } catch {
            self.error = .unknown(error)
        }

        isLoading = false
    }

    // MARK: - 加载更多

    func loadMore() async {
        guard !isLoadingMore, hasMore, searchText.isEmpty else { return }
        isLoadingMore = true

        do {
            let result = try await network.request(
                .newsList(page: currentPage),
                as: [NewsArticle].self
            )
            articles.append(contentsOf: result)
            hasMore = result.count >= pageSize
            currentPage += 1
        } catch {
            print("加载更多失败：\(error)")
        }

        isLoadingMore = false
    }

    func refresh() async {
        await loadArticles()
    }
}
