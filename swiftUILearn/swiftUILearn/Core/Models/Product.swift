//
//  Product.swift
//  swiftUILearn
//
//  商城商品数据模型
//  对应 JSONPlaceholder /photos 接口
//

import Foundation

struct Product: Identifiable, Codable, Equatable, Hashable {
    let id: Int
    let albumId: Int
    let title: String
    let url: String             // 原图 URL
    let thumbnailUrl: String    // 缩略图 URL

    // MARK: - 计算属性

    /// 商品价格（根据 id 模拟，实际来自接口）
    var price: Double {
        Double((id * 17 + albumId * 13) % 1000) + 9.9
    }

    /// 格式化价格
    var priceText: String {
        String(format: "¥%.2f", price)
    }

    /// 销量（模拟）
    var salesCount: Int {
        (id * 83 + albumId * 47) % 5000
    }

    /// 评分（模拟 4.0-5.0）
    var rating: Double {
        let base = Double((id + albumId) % 20)
        return 4.0 + base / 100.0 * 5.0
    }

    /// 商品标题（截断过长标题）
    var shortTitle: String {
        title.count > 20 ? String(title.prefix(20)) + "..." : title
    }

    /// 分类标签
    var category: String {
        let categories = ["电子", "服饰", "家居", "美妆", "运动", "图书", "食品", "玩具"]
        return categories[albumId % categories.count]
    }
}
