//
//  MallViewModel.swift
//  swiftUILearn
//
//  商城 ViewModel（含分页加载逻辑）
//

import Foundation
import Combine

@MainActor
class MallViewModel: ObservableObject {

    // MARK: - Published
    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var isLoadingMore = false    // 分页加载状态（与首次加载分开）
    @Published var error: APIError?
    @Published var hasMore = true           // 是否还有更多数据

    // MARK: - 分页状态
    private var currentPage = 1
    private let pageSize = 20

    private let network: NetworkManager

    init(network: NetworkManager = .shared) {
        self.network = network
    }

    // MARK: - 首次加载

    func loadProducts() async {
        guard !isLoading else { return }
        isLoading = true
        error = nil
        currentPage = 1
        hasMore = true

        do {
            let result = try await network.request(
                .products(page: currentPage, limit: pageSize),
                as: [Product].self
            )
            products = result
            hasMore = result.count >= pageSize
            currentPage += 1
        } catch let apiError as APIError {
            error = apiError
        } catch {
            self.error = .unknown(error)
        }

        isLoading = false
    }

    // MARK: - 加载更多（上拉翻页）

    func loadMore() async {
        guard !isLoadingMore, hasMore else { return }
        isLoadingMore = true

        do {
            let result = try await network.request(
                .products(page: currentPage, limit: pageSize),
                as: [Product].self
            )
            products.append(contentsOf: result)
            hasMore = result.count >= pageSize
            currentPage += 1
        } catch {
            // 加载更多失败时静默处理（不打断用户体验）
            print("加载更多失败：\(error.localizedDescription)")
        }

        isLoadingMore = false
    }

    // MARK: - 下拉刷新

    func refresh() async {
        await loadProducts()
    }
}
