//
//  MineViewModel.swift
//  swiftUILearn
//
//  "我的"页面 ViewModel
//

import Foundation
import Combine
import SwiftUI

@MainActor
class MineViewModel: ObservableObject {

    // MARK: - Published
    @Published var user: AppUser?
    @Published var isLoading = false
    @Published var error: APIError?
    @Published var isLoggedIn = false

    // 菜单配置（静态数据，不来自接口）
    let menuItems: [ProfileMenuItem] = [
        ProfileMenuItem(icon: "bag.fill",          title: "我的订单",  subtitle: "查看全部",  color: "orange",  action: .orders),
        ProfileMenuItem(icon: "heart.fill",         title: "我的收藏",  subtitle: nil,        color: "red",     action: .favorites),
        ProfileMenuItem(icon: "clock.fill",         title: "浏览历史",  subtitle: nil,        color: "blue",    action: .history),
        ProfileMenuItem(icon: "location.fill",      title: "收货地址",  subtitle: nil,        color: "green",   action: .address),
        ProfileMenuItem(icon: "gearshape.fill",     title: "设置",      subtitle: nil,        color: "gray",    action: .settings),
        ProfileMenuItem(icon: "info.circle.fill",   title: "关于",      subtitle: "v1.0.0",   color: "purple",  action: .about),
    ]

    private let network: NetworkManager

    init(network: NetworkManager = .shared) {
        self.network = network
    }

    // MARK: - 加载用户信息

    func loadProfile(userId: Int = 1) async {
        isLoading = true
        error = nil

        do {
            user = try await network.request(.userProfile(id: userId), as: AppUser.self)
            isLoggedIn = true
        } catch let apiError as APIError {
            error = apiError
        } catch {
            self.error = .unknown(error)
        }

        isLoading = false
    }

    // MARK: - 登出

    func logout() {
        user = nil
        isLoggedIn = false
    }

    // MARK: - 图标颜色映射
    func iconColor(for colorName: String) -> Color {
        switch colorName {
        case "orange":  return .orange
        case "red":     return .red
        case "blue":    return .blue
        case "green":   return .green
        case "gray":    return .gray
        case "purple":  return .purple
        default:        return .accentColor
        }
    }
}
