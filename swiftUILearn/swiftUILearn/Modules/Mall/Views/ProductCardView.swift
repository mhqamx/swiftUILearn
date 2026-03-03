//
//  ProductCardView.swift
//  swiftUILearn
//
//  商品卡片视图
//

import SwiftUI

/// 商品网格卡片
struct ProductCardView: View {
    let product: Product

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 商品图片（使用 AsyncImage 加载真实图片）
            AsyncImage(url: URL(string: product.thumbnailUrl)) { phase in
                switch phase {
                case .empty:
                    // 加载中：骨架屏
                    Rectangle()
                        .fill(Color.gray.opacity(0.15))
                        .overlay { ProgressView() }

                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()

                case .failure:
                    // 加载失败：占位图
                    Rectangle()
                        .fill(Color.gray.opacity(0.1))
                        .overlay {
                            Image(systemName: "photo")
                                .foregroundStyle(.secondary)
                        }

                @unknown default:
                    EmptyView()
                }
            }
            .frame(height: 150)
            .clipped()

            // 商品信息
            VStack(alignment: .leading, spacing: 6) {
                Text(product.shortTitle)
                    .font(.caption)
                    .lineLimit(2)
                    .foregroundStyle(.primary)

                HStack(alignment: .bottom) {
                    Text(product.priceText)
                        .font(.headline)
                        .foregroundStyle(.red)

                    Spacer()

                    Text("销量 \(product.salesCount)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                // 分类标签 + 评分
                HStack {
                    Text(product.category)
                        .font(.caption2)
                        .padding(.horizontal, 5).padding(.vertical, 2)
                        .background(Color.orange.opacity(0.1))
                        .foregroundStyle(.orange)
                        .clipShape(Capsule())

                    Spacer()

                    // 评分星星
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .font(.caption2)
                            .foregroundStyle(.orange)
                        Text(String(format: "%.1f", product.rating))
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(10)
        }
        .background(Color.primary.opacity(0.03))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.primary.opacity(0.06), lineWidth: 1)
        }
    }
}

/// 商品详情页
struct ProductDetailView: View {
    let product: Product
    @State private var quantity = 1
    @State private var isFavorited = false
    @State private var showBuyAlert = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // 商品大图
                AsyncImage(url: URL(string: product.url)) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFit()
                    default:
                        Rectangle()
                            .fill(Color.gray.opacity(0.1))
                            .frame(height: 300)
                            .overlay { Image(systemName: "photo").font(.largeTitle).foregroundStyle(.secondary) }
                    }
                }
                .frame(maxWidth: .infinity)

                VStack(alignment: .leading, spacing: 16) {
                    // 价格 + 销量
                    HStack(alignment: .bottom) {
                        Text(product.priceText)
                            .font(.title.bold())
                            .foregroundStyle(.red)
                        Spacer()
                        Text("销量 \(product.salesCount)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Text(product.title)
                        .font(.headline)

                    Divider()

                    // 数量选择
                    HStack {
                        Text("数量")
                        Spacer()
                        Stepper("\(quantity)", value: $quantity, in: 1...99)
                    }
                    .font(.subheadline)
                }
                .padding()
            }
        }
        .navigationTitle("商品详情")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isFavorited.toggle()
                } label: {
                    Image(systemName: isFavorited ? "heart.fill" : "heart")
                        .foregroundStyle(isFavorited ? .red : .primary)
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            // 底部购买按钮
            HStack(spacing: 12) {
                Button("加入购物车") {
                    showBuyAlert = true
                }
                .buttonStyle(.bordered)
                .tint(.orange)

                Button("立即购买") {
                    showBuyAlert = true
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
            }
            .padding()
            .background(.regularMaterial)
        }
        .alert("演示提示", isPresented: $showBuyAlert) {
            Button("好的", role: .cancel) {}
        } message: {
            Text("这是演示 Demo，实际项目需要接入真实的购物车接口")
        }
    }
}
