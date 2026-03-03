//
//  APIError.swift
//  swiftUILearn
//
//  统一的网络错误类型定义
//

import Foundation

/// 网络请求错误枚举
/// 所有网络层抛出的错误都应转换为此类型
enum APIError: Error, LocalizedError {
    case invalidURL                     // URL 格式错误
    case noData                         // 响应无数据
    case decodingFailed(Error)          // JSON 解码失败
    case serverError(Int)               // 服务器返回非 2xx 状态码
    case networkUnavailable             // 无网络连接
    case timeout                        // 请求超时
    case unknown(Error)                 // 其他未知错误

    /// 用户可读的错误描述（用于 UI 展示）
    var errorDescription: String? {
        switch self {
        case .invalidURL:               return "请求地址无效"
        case .noData:                   return "服务器未返回数据"
        case .decodingFailed(let e):    return "数据解析失败：\(e.localizedDescription)"
        case .serverError(let code):    return "服务器错误（\(code)）"
        case .networkUnavailable:       return "网络不可用，请检查网络连接"
        case .timeout:                  return "请求超时，请稍后重试"
        case .unknown(let e):           return e.localizedDescription
        }
    }

    /// 是否是可重试的错误
    var isRetryable: Bool {
        switch self {
        case .timeout, .networkUnavailable: return true
        default: return false
        }
    }
}
