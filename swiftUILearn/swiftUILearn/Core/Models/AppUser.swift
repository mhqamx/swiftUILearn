//
//  AppUser.swift
//  swiftUILearn
//
//  用户数据模型
//  对应 JSONPlaceholder /users 接口
//

import Foundation

struct AppUser: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let phone: String
    let website: String
    let address: UserAddress
    let company: UserCompany
}

struct UserAddress: Codable, Equatable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
}

struct UserCompany: Codable, Equatable {
    let name: String
    let catchPhrase: String
    let bs: String
}

// MARK: - 用户信息项（"我的"页面的菜单配置）
struct ProfileMenuItem: Identifiable {
    let id = UUID()
    let icon: String        // SF Symbol 名称
    let title: String
    let subtitle: String?
    let color: String       // 图标颜色（十六进制或系统颜色名）
    let action: MenuAction

    enum MenuAction {
        case orders         // 我的订单
        case favorites      // 我的收藏
        case history        // 浏览历史
        case address        // 收货地址
        case settings       // 设置
        case about          // 关于
        case logout         // 退出登录
    }
}
