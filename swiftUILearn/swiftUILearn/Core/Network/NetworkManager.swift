//
//  NetworkManager.swift
//  swiftUILearn
//
//  网络请求核心管理器
//  职责：发起请求 → 校验响应 → 解码数据 → 统一错误处理
//
//  架构原则：
//  - 单例模式：全局唯一实例，共享 URLSession 配置
//  - 泛型：request<T: Decodable> 支持任意可解码类型
//  - async/await：现代 Swift 并发，比 Combine 更简洁
//

import Foundation

/// 网络请求管理器（单例）
final class NetworkManager {

    // MARK: - 单例
    static let shared = NetworkManager()

    // MARK: - URLSession 配置
    private let session: URLSession

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15       // 请求超时 15 秒
        config.timeoutIntervalForResource = 60      // 资源加载超时 60 秒
        config.waitsForConnectivity = true          // 等待网络连接（而不是立即失败）
        self.session = URLSession(configuration: config)
    }

    // MARK: - 核心请求方法

    /// 发起网络请求并解码为指定类型
    /// - Parameters:
    ///   - endpoint: 接口端点（包含 URL、参数等）
    ///   - type: 期望解码的数据类型
    /// - Returns: 解码后的数据
    /// - Throws: APIError 类型的错误
    func request<T: Decodable>(
        _ endpoint: APIEndpoint,
        as type: T.Type = T.self
    ) async throws -> T {

        // 1. 校验 URL
        guard let url = endpoint.url else {
            throw APIError.invalidURL
        }

        // 2. 构建 URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        // 3. 发起请求
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: request)
        } catch let urlError as URLError {
            // 将 URLError 转换为 APIError
            switch urlError.code {
            case .timedOut:             throw APIError.timeout
            case .notConnectedToInternet,
                 .networkConnectionLost: throw APIError.networkUnavailable
            default:                    throw APIError.unknown(urlError)
            }
        }

        // 4. 校验 HTTP 状态码（200-299 为成功）
        if let http = response as? HTTPURLResponse,
           !(200...299).contains(http.statusCode) {
            throw APIError.serverError(http.statusCode)
        }

        // 5. 解码 JSON
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase  // snake_case → camelCase
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingFailed(error)
        }
    }

    /// 带重试机制的请求
    /// - Parameters:
    ///   - endpoint: 接口端点
    ///   - maxRetries: 最大重试次数（默认3次）
    func requestWithRetry<T: Decodable>(
        _ endpoint: APIEndpoint,
        as type: T.Type = T.self,
        maxRetries: Int = 3
    ) async throws -> T {
        var lastError: APIError = .networkUnavailable

        for attempt in 1...maxRetries {
            do {
                return try await request(endpoint, as: type)
            } catch let error as APIError {
                lastError = error
                // 只有可重试的错误才继续
                guard error.isRetryable else { throw error }
                // 指数退避：第1次等1秒，第2次等2秒，第3次等4秒
                let delay = pow(2.0, Double(attempt - 1))
                try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            }
        }
        throw lastError
    }
}
