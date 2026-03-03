//
//  EnvironmentObjectDemoView.swift
//  swiftUILearn
//
//  【知识点】@EnvironmentObject 环境对象
//  场景：图书馆当前登录用户信息跨层级共享
//

import SwiftUI
import Combine

// MARK: - 全局用户状态（注入到环境中）
class LibraryUserStore: ObservableObject {
    @Published var currentUser: LibraryUser?
    @Published var isLoggedIn = false

    func login(name: String, role: LibraryUser.Role) {
        currentUser = LibraryUser(name: name, role: role, borrowedCount: Int.random(in: 0...20))
        isLoggedIn = true
    }

    func logout() {
        currentUser = nil
        isLoggedIn = false
    }
}

struct LibraryUser {
    let name: String
    let role: Role
    let borrowedCount: Int

    enum Role: String, CaseIterable {
        case reader = "普通读者"
        case vip = "VIP 会员"
        case librarian = "图书管理员"
    }
}

// MARK: - Demo 主视图
struct EnvironmentObjectDemoView: View {
    // @StateObject 在顶层创建实例
    @StateObject private var userStore = LibraryUserStore()
    @State private var userName = "张三"
    @State private var selectedRole = LibraryUser.Role.reader

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                DemoHeader(
                    title: "@EnvironmentObject",
                    subtitle: "@EnvironmentObject 将对象注入到视图树，无需逐层传参，任意深度的子视图都可访问。"
                )

                // 原理图
                GroupBox("🌳 视图树共享原理") {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("ContentView  .environmentObject(userStore)")
                            .font(.caption.monospaced()).foregroundStyle(.blue)
                        Text("  ├── HeaderView  @EnvironmentObject userStore ✅")
                            .font(.caption.monospaced()).foregroundStyle(.green)
                        Text("  └── BookListView")
                            .font(.caption.monospaced())
                        Text("       └── BookRow  @EnvironmentObject userStore ✅")
                            .font(.caption.monospaced()).foregroundStyle(.green)
                        Text("无需通过 BookListView 传递，跨层直接访问")
                            .font(.caption2).foregroundStyle(.secondary).padding(.top, 4)
                    }
                    .padding(8)
                }

                // 登录控制
                GroupBox("🔑 模拟登录") {
                    VStack(spacing: 12) {
                        if userStore.isLoggedIn {
                            // 已登录状态
                            HStack {
                                Image(systemName: "person.circle.fill")
                                    .font(.title)
                                    .foregroundStyle(.blue)
                                VStack(alignment: .leading) {
                                    Text(userStore.currentUser?.name ?? "")
                                        .font(.headline)
                                    Text(userStore.currentUser?.role.rawValue ?? "")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Button("退出", role: .destructive) {
                                    withAnimation { userStore.logout() }
                                }
                                .buttonStyle(.bordered)
                            }
                        } else {
                            // 未登录状态
                            TextField("输入用户名", text: $userName)
                                .textFieldStyle(.roundedBorder)

                            Picker("身份", selection: $selectedRole) {
                                ForEach(LibraryUser.Role.allCases, id: \.self) { role in
                                    Text(role.rawValue).tag(role)
                                }
                            }
                            .pickerStyle(.segmented)

                            Button("登录图书馆系统") {
                                withAnimation {
                                    userStore.login(name: userName, role: selectedRole)
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(userName.isEmpty)
                        }
                    }
                    .padding(8)
                }

                // 子视图自动获取 @EnvironmentObject
                if userStore.isLoggedIn {
                    GroupBox("📱 子视图中直接使用（无需传参）") {
                        // 注入到环境后，子视图直接用 @EnvironmentObject 读取
                        // 无需父视图显式传参
                        UserInfoWidget()
                            .environmentObject(userStore)
                        Divider()
                        BorrowRecordWidget()
                            .environmentObject(userStore)
                    }
                    .padding(8)
                }

                ConceptNote(items: [
                    ".environmentObject(obj)：将对象注入视图树，一次注入全局可用",
                    "@EnvironmentObject var store: MyStore：子视图读取，无需传参",
                    "适合场景：用户信息、主题设置、购物车等全局共享状态",
                    "不要滥用：局部状态用 @State，父子传递用 @Binding",
                    "Preview 注意：#Preview 中必须手动 .environmentObject() 否则崩溃"
                ])
            }
            .padding()
        }
        .navigationTitle("@EnvironmentObject")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 深层子视图（演示无需传参直接获取）

private struct UserInfoWidget: View {
    // 直接从环境中获取，不需要父视图传参
    @EnvironmentObject var userStore: LibraryUserStore

    var body: some View {
        HStack {
            Image(systemName: "person.badge.shield.checkmark")
                .foregroundStyle(.blue)
            Text("当前用户：\(userStore.currentUser?.name ?? "未登录")")
                .font(.footnote)
            Spacer()
            Text(userStore.currentUser?.role.rawValue ?? "")
                .font(.caption)
                .padding(.horizontal, 6).padding(.vertical, 2)
                .background(Color.blue.opacity(0.1))
                .clipShape(Capsule())
        }
        .padding(.vertical, 4)
    }
}

private struct BorrowRecordWidget: View {
    @EnvironmentObject var userStore: LibraryUserStore

    var body: some View {
        HStack {
            Image(systemName: "book.fill")
                .foregroundStyle(.orange)
            Text("当前借阅：\(userStore.currentUser?.borrowedCount ?? 0) 本")
                .font(.footnote)
            Spacer()
            Text(borrowLimit)
                .font(.caption)
                .foregroundStyle(isOverLimit ? .red : .green)
        }
        .padding(.vertical, 4)
    }

    private var borrowLimit: String {
        switch userStore.currentUser?.role {
        case .reader: return "限额 5 本"
        case .vip: return "限额 15 本"
        case .librarian: return "无限制"
        case nil: return ""
        }
    }

    private var isOverLimit: Bool {
        guard let user = userStore.currentUser else { return false }
        switch user.role {
        case .reader: return user.borrowedCount > 5
        case .vip: return user.borrowedCount > 15
        case .librarian: return false
        }
    }
}

#Preview {
    NavigationStack {
        EnvironmentObjectDemoView()
    }
}
