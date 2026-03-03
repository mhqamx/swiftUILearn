//
//  APIEndpoint.swift
//  swiftUILearn
//
//  所有接口地址的统一管理
//  新增接口只需在此添加 case，不需要分散写 URL 字符串
//

import Foundation

/// 接口端点协议
/// 每个 case 对应一个 API 接口，自动组装完整 URL 和参数
protocol APIEndpointProtocol {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem]? { get }
    var url: URL? { get }
}

/// HTTP 请求方法
enum HTTPMethod: String {
    case GET, POST, PUT, DELETE, PATCH
}

/// 应用所有接口定义
/// 使用 JSONPlaceholder 作为演示数据源（https://jsonplaceholder.typicode.com）
enum APIEndpoint: APIEndpointProtocol {

    // MARK: - 首页
    case homeBanners            // 首页轮播（使用 albums 模拟）
    case homeRecommend          // 首页推荐（使用 posts 前5条）

    // MARK: - 商城
    case products(page: Int, limit: Int)    // 商品列表（分页）
    case productDetail(id: Int)             // 商品详情

    // MARK: - 新闻
    case newsList(page: Int)    // 新闻列表
    case newsDetail(id: Int)    // 新闻详情

    // MARK: - 用户
    case userProfile(id: Int)   // 用户信息
    case userPosts(userId: Int) // 用户发布的内容

    // MARK: - BaseURL（按环境区分）
    var baseURL: String {
        // 实际项目中根据环境切换：
        // Debug → 测试服，Release → 生产服
        return "https://jsonplaceholder.typicode.com"
    }

    // MARK: - Path
    var path: String {
        switch self {
        case .homeBanners:              return "/albums"
        case .homeRecommend:            return "/posts"
        case .products:                 return "/photos"
        case .productDetail(let id):   return "/photos/\(id)"
        case .newsList:                 return "/posts"
        case .newsDetail(let id):      return "/posts/\(id)"
        case .userProfile(let id):     return "/users/\(id)"
        case .userPosts(let userId):   return "/posts"
        }
    }

    // MARK: - HTTP Method
    var method: HTTPMethod {
        // 演示项目全部是 GET，实际项目 POST/PUT 用于提交数据
        return .GET
    }

    // MARK: - Query 参数
    var queryItems: [URLQueryItem]? {
        switch self {
        case .homeRecommend:
            return [URLQueryItem(name: "_limit", value: "5")]

        case .homeBanners:
            return [URLQueryItem(name: "_limit", value: "5")]

        case .products(let page, let limit):
            // 分页参数：_page 从1开始，_limit 每页条数
            return [
                URLQueryItem(name: "_page", value: "\(page)"),
                URLQueryItem(name: "_limit", value: "\(limit)")
            ]

        case .newsList(let page):
            return [
                URLQueryItem(name: "_page", value: "\(page)"),
                URLQueryItem(name: "_limit", value: "15")
            ]

        case .userPosts(let userId):
            return [URLQueryItem(name: "userId", value: "\(userId)")]

        default:
            return nil
        }
    }

    // MARK: - 组装完整 URL
    var url: URL? {
        var components = URLComponents(string: baseURL + path)
        components?.queryItems = queryItems
        return components?.url
    }
}
