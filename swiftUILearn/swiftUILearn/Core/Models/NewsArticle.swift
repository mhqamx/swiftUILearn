//
//  NewsArticle.swift
//  swiftUILearn
//
//  新闻数据模型
//  对应 JSONPlaceholder /posts 接口
//

import Foundation

struct NewsArticle: Identifiable, Codable, Equatable, Hashable {
    let id: Int
    let userId: Int
    let title: String
    let body: String        // 正文内容（JSONPlaceholder 中是 body 字段）

    // MARK: - 计算属性（不来自接口，本地计算）

    /// 格式化标题（首字母大写）
    var formattedTitle: String {
        title.prefix(1).uppercased() + title.dropFirst()
    }

    /// 摘要（取正文前80个字符）
    var summary: String {
        let text = body.replacingOccurrences(of: "\n", with: " ")
        return text.count > 80 ? String(text.prefix(80)) + "..." : text
    }

    /// 模拟分类（根据 userId 推算）
    var category: String {
        let categories = ["科技", "财经", "体育", "娱乐", "社会", "国际", "健康", "教育", "汽车", "房产"]
        return categories[(userId - 1) % categories.count]
    }

    /// 模拟发布时间（根据 id 推算，仅演示用）
    var publishedAt: String {
        let hours = id % 24
        return "\(hours)小时前"
    }

    /// 模拟阅读数
    var readCount: Int {
        (id * 137 + userId * 53) % 10000
    }
}

// MARK: - 响应包装（部分接口返回带分页的外层结构）
struct PaginatedResponse<T: Codable>: Codable {
    let data: [T]
    let total: Int
    let page: Int
}
