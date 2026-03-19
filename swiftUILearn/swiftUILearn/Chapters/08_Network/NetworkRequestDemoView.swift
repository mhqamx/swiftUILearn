//
//  NetworkRequestDemoView.swift
//  swiftUILearn
//
//  【知识点】URLSession + async/await 网络请求
//  场景：通过现代并发方式加载商品数据，展示网络层全流程
//

import SwiftUI
import Combine

struct NetworkRequestDemoView: View {
    @StateObject private var viewModel = NetworkDemoViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                DemoHeader(
                    title: "URLSession + async/await",
                    subtitle: "async/await 让异步网络请求像同步代码一样顺序执行，配合 NetworkManager 封装，错误处理统一、代码简洁。"
                )

                // ── 1. 基础 GET 请求 ──
                GroupBox("📡 基础 GET 请求") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("GET /photos?_page=1&_limit=5")
                            .font(.caption.monospaced())
                            .foregroundStyle(.secondary)

                        Button {
                            Task { await viewModel.fetchProducts() }
                        } label: {
                            Label("发起请求", systemImage: "arrow.down.circle.fill")
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(viewModel.isLoading)

                        if viewModel.isLoading {
                            ProgressView("请求中...").padding(.vertical, 4)
                        }

                        if let error = viewModel.error {
                            ErrorBanner(message: error.localizedDescription ?? "未知错误")
                        }

                        ForEach(viewModel.products) { product in
                            ProductRowView(product: product)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                }

                // ── 2. 带参数的分页请求 ──
                GroupBox("📄 带参数请求：分页") {
                    VStack(spacing: 12) {
                        HStack {
                            Text("当前第 \(viewModel.currentPage) 页")
                                .font(.caption).foregroundStyle(.secondary)
                            Spacer()
                            Text("每页 10 条")
                                .font(.caption).foregroundStyle(.secondary)
                        }

                        HStack(spacing: 12) {
                            Button {
                                Task { await viewModel.loadNextPage() }
                            } label: {
                                Label("下一页", systemImage: "chevron.right")
                            }
                            .buttonStyle(.bordered)
                            .disabled(viewModel.isLoadingPage)

                            Button {
                                Task { await viewModel.resetPage() }
                            } label: {
                                Label("重置", systemImage: "arrow.counterclockwise")
                            }
                            .buttonStyle(.bordered)
                            .disabled(viewModel.isLoadingPage)
                        }

                        if viewModel.isLoadingPage {
                            ProgressView("加载分页...").padding(.vertical, 4)
                        }

                        ForEach(viewModel.pagedProducts.prefix(5)) { product in
                            ProductRowView(product: product)
                        }
                    }
                    .padding(8)
                }

                // ── 3. 详情请求（路径参数）──
                GroupBox("🔍 详情请求：路径参数") {
                    VStack(spacing: 12) {
                        HStack {
                            Text("商品 ID：")
                            TextField("1~100", text: $viewModel.detailIdInput)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.numberPad)
                            Button {
                                Task { await viewModel.fetchDetail() }
                            } label: {
                                Image(systemName: "magnifyingglass")
                            }
                            .buttonStyle(.borderedProminent)
                        }

                        if viewModel.isLoadingDetail {
                            ProgressView("查询中...").padding(.vertical, 4)
                        }

                        if let product = viewModel.detailProduct {
                            ProductDetailCard(product: product)
                        }
                    }
                    .padding(8)
                }

                // ── 4. 并发请求（async let）──
                GroupBox("⚡️ 并发请求：async let") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("async let 同时启动多个请求，全部完成后再统一 await，比逐个串行等待快很多。")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Button {
                            Task { await viewModel.fetchConcurrently() }
                        } label: {
                            Label("同时请求 3 个商品", systemImage: "bolt.fill")
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(viewModel.isLoadingConcurrent)

                        if viewModel.isLoadingConcurrent {
                            ProgressView("并发加载中...").padding(.vertical, 4)
                        }

                        if !viewModel.concurrentProducts.isEmpty {
                            Text("总耗时：\(String(format: "%.2f", viewModel.concurrentDuration))秒")
                                .font(.caption.bold())
                                .foregroundStyle(.green)

                            ForEach(viewModel.concurrentProducts) { product in
                                ProductRowView(product: product)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                }

                // ── 5. 带重试的请求 ──
                GroupBox("🔄 错误处理：重试机制") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("网络不稳定时自动重试，每次等待时间递增（指数退避）。")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Button {
                            Task { await viewModel.fetchWithRetry() }
                        } label: {
                            Label("带重试的请求", systemImage: "arrow.triangle.2.circlepath")
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(viewModel.isRetrying)

                        if viewModel.isRetrying {
                            HStack(spacing: 8) {
                                ProgressView()
                                Text("第 \(viewModel.retryCount) 次尝试...")
                                    .font(.caption).foregroundStyle(.secondary)
                            }
                        }

                        if !viewModel.retryLog.isEmpty {
                            VStack(alignment: .leading, spacing: 4) {
                                ForEach(Array(viewModel.retryLog.enumerated()), id: \.offset) { _, log in
                                    Text(log)
                                        .font(.caption.monospaced())
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                }

                ConceptNote(items: [
                    "async/await：让异步代码顺序执行，避免回调嵌套（回调地狱）",
                    "URLSession.data(for:)：async 版本，挂起当前 Task 直到响应返回",
                    "Task { await ... }：在 SwiftUI 事件处理中启动异步任务",
                    "async let：并发发起多个请求，不等上一个完成，提升整体速度",
                    "NetworkManager：封装 URLSession，统一处理状态码校验和 JSON 解码",
                    "APIError.isRetryable：区分可重试错误（超时/断网）与不可重试错误"
                ])
            }
            .padding()
        }
        .navigationTitle("网络请求")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - ViewModel

@MainActor
final class NetworkDemoViewModel: ObservableObject {

    private let network = NetworkManager.shared

    // 1. 基础请求
    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var error: APIError?

    // 2. 分页
    @Published var pagedProducts: [Product] = []
    @Published var currentPage = 1
    @Published var isLoadingPage = false

    // 3. 详情
    @Published var detailIdInput = "1"
    @Published var detailProduct: Product?
    @Published var isLoadingDetail = false

    // 4. 并发
    @Published var concurrentProducts: [Product] = []
    @Published var isLoadingConcurrent = false
    @Published var concurrentDuration: TimeInterval = 0

    // 5. 重试
    @Published var isRetrying = false
    @Published var retryCount = 0
    @Published var retryLog: [String] = []

    // MARK: - 1️⃣ 基础 GET 请求

    func fetchProducts() async {
        isLoading = true
        error = nil

        do {
            // NetworkManager 封装了 URLSession、状态码校验和 JSON 解码
            products = try await network.request(
                .products(page: 1, limit: 5),
                as: [Product].self
            )
        } catch let apiError as APIError {
            error = apiError
        } catch {
            self.error = .unknown(error)
        }

        isLoading = false
    }

    // MARK: - 2️⃣ 带参数的分页请求

    func loadNextPage() async {
        currentPage += 1
        isLoadingPage = true

        do {
            pagedProducts = try await network.request(
                .products(page: currentPage, limit: 10),
                as: [Product].self
            )
        } catch {
            currentPage -= 1  // 失败时回退页码
        }

        isLoadingPage = false
    }

    func resetPage() async {
        currentPage = 1
        isLoadingPage = true

        do {
            pagedProducts = try await network.request(
                .products(page: 1, limit: 10),
                as: [Product].self
            )
        } catch {}

        isLoadingPage = false
    }

    // MARK: - 3️⃣ 详情请求（路径参数）

    func fetchDetail() async {
        guard let id = Int(detailIdInput), id > 0 else { return }
        isLoadingDetail = true
        detailProduct = nil

        do {
            // /photos/:id 格式的路径参数请求
            detailProduct = try await network.request(
                .productDetail(id: id),
                as: Product.self
            )
        } catch {}

        isLoadingDetail = false
    }

    // MARK: - 4️⃣ 并发请求（async let）

    func fetchConcurrently() async {
        isLoadingConcurrent = true
        concurrentProducts = []
        let start = Date()

        do {
            // async let：立即启动，不等待结果，三个请求并发执行
            async let p1 = network.request(.productDetail(id: 1), as: Product.self)
            async let p2 = network.request(.productDetail(id: 2), as: Product.self)
            async let p3 = network.request(.productDetail(id: 3), as: Product.self)

            // try await：等待全部完成后统一取值
            concurrentProducts = try await [p1, p2, p3]
            concurrentDuration = Date().timeIntervalSince(start)
        } catch {}

        isLoadingConcurrent = false
    }

    // MARK: - 5️⃣ 带重试的请求

    func fetchWithRetry() async {
        isRetrying = true
        retryCount = 0
        retryLog = []

        let maxRetries = 3

        for attempt in 1...maxRetries {
            retryCount = attempt
            retryLog.append("[\(timestamp())] 第 \(attempt) 次尝试...")

            do {
                let result = try await network.request(
                    .products(page: 1, limit: 5),
                    as: [Product].self
                )
                retryLog.append("✅ 成功！获取到 \(result.count) 条数据")
                products = result
                break
            } catch {
                retryLog.append("❌ 失败：\(error.localizedDescription)")

                if attempt < maxRetries {
                    let delay = Double(attempt)
                    retryLog.append("⏳ \(delay)s 后重试...")
                    try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                } else {
                    retryLog.append("🛑 已达最大重试次数（\(maxRetries) 次）")
                }
            }
        }

        isRetrying = false
    }

    private func timestamp() -> String {
        Date().formatted(date: .omitted, time: .standard)
    }
}

// MARK: - 私有 UI 组件

private struct ProductRowView: View {
    let product: Product

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: product.thumbnailUrl)) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                default:
                    Image(systemName: "photo")
                        .foregroundStyle(.gray)
                }
            }
            .frame(width: 44, height: 44)
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 4) {
                Text(product.shortTitle)
                    .font(.subheadline)
                    .lineLimit(1)
                Text("ID: \(product.id)  ·  \(product.category)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(10)
        .background(Color.blue.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private struct ProductDetailCard: View {
    let product: Product

    var body: some View {
        VStack(spacing: 12) {
            AsyncImage(url: URL(string: product.thumbnailUrl)) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFit()
                        .frame(maxHeight: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                default:
                    ProgressView().frame(height: 80)
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(product.title)
                    .font(.headline)
                HStack {
                    Text("ID: \(product.id)")
                    Text("·")
                    Text(product.category)
                    Text("·")
                    Text(product.priceText).foregroundStyle(.orange)
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

private struct ErrorBanner: View {
    let message: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.red)
            Text(message)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.red.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    NavigationStack {
        NetworkRequestDemoView()
    }
}
