//
//  MallView.swift
//  swiftUILearn
//
//  商城主视图（网格 + 分页加载）
//

import SwiftUI

struct MallView: View {
    @StateObject private var viewModel = MallViewModel()

    // 两列网格
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.products.isEmpty {
                    LoadingView(message: "加载商品中...")
                } else if let error = viewModel.error, viewModel.products.isEmpty {
                    ErrorView(error: error) {
                        Task { await viewModel.loadProducts() }
                    }
                } else {
                    productGrid
                }
            }
            .navigationTitle("商城")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                    } label: {
                        Image(systemName: "cart")
                    }
                }
            }
            .refreshable {
                await viewModel.refresh()
            }
        }
        .task {
            await viewModel.loadProducts()
        }
    }

    // MARK: - 商品网格

    private var productGrid: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(viewModel.products) { product in
                    NavigationLink {
                        ProductDetailView(product: product)
                    } label: {
                        ProductCardView(product: product)
                    }
                    .buttonStyle(.plain)
                    // 滑到最后触发加载更多
                    .onAppear {
                        if product.id == viewModel.products.last?.id {
                            Task { await viewModel.loadMore() }
                        }
                    }
                }
            }
            .padding(.horizontal)

            // 加载更多指示器
            if viewModel.isLoadingMore {
                InlineLoadingView()
            }

            if !viewModel.hasMore {
                Text("— 已加载全部商品 —")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
        }
    }
}

#Preview {
    MallView()
}
