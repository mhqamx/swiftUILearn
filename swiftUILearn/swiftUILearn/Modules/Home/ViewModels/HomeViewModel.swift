//
//  HomeViewModel.swift
//  swiftUILearn
//
//  首页 ViewModel
//  遵循 MVVM：视图只调用 ViewModel 的方法，不直接操作数据
//

import Foundation
import Combine

@MainActor  // 确保所有 @Published 更新在主线程（UI 线程）
class HomeViewModel: ObservableObject {

    // MARK: - Published（视图观察这些属性，值变化时自动重绘）
    @Published var banners: [NewsArticle] = []
    @Published var recommends: [NewsArticle] = []
    @Published var isLoading = false
    @Published var error: APIError?

    // MARK: - 私有依赖（通过协议注入，便于单元测试 Mock）
    private let network: NetworkManager

    init(network: NetworkManager = .shared) {
        self.network = network
    }

    // MARK: - 加载首页数据

    /// 加载所有首页数据（轮播 + 推荐并发请求）
    func loadAll() async {
        isLoading = true
        error = nil

        // async let：并发执行两个请求，互不等待
        async let bannersTask = fetchBanners()
        async let recommendsTask = fetchRecommends()

        // await 等两个都完成
        await bannersTask
        await recommendsTask

        isLoading = false
    }

    /// 下拉刷新
    func refresh() async {
        await loadAll()
    }

    // MARK: - 私有请求方法

    private func fetchBanners() async {
        do {
            banners = try await network.request(.homeBanners, as: [NewsArticle].self)
        } catch let apiError as APIError {
            error = apiError
        } catch {
            self.error = .unknown(error)
        }
    }

    private func fetchRecommends() async {
        do {
            recommends = try await network.request(.homeRecommend, as: [NewsArticle].self)
        } catch let apiError as APIError {
            error = apiError
        } catch {
            self.error = .unknown(error)
        }
    }
}
