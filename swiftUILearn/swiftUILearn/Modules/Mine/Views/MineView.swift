//
//  MineView.swift
//  swiftUILearn
//
//  "我的"页面
//

import SwiftUI

struct MineView: View {
    @StateObject private var viewModel = MineViewModel()

    var body: some View {
        NavigationStack {
            List {
                // ── 用户信息区 ──
                Section {
                    UserProfileSection(user: viewModel.user, isLoading: viewModel.isLoading)
                }

                // ── 功能菜单 ──
                Section {
                    ForEach(viewModel.menuItems) { item in
                        MenuRow(item: item, viewModel: viewModel)
                    }
                }

                // ── 退出登录 ──
                Section {
                    Button(role: .destructive) {
                        viewModel.logout()
                    } label: {
                        Label("退出登录", systemImage: "rectangle.portrait.and.arrow.right")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .navigationTitle("我的")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // 设置
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
        }
        .task {
            await viewModel.loadProfile(userId: 1)
        }
    }
}

// MARK: - 用户信息区

private struct UserProfileSection: View {
    let user: AppUser?
    let isLoading: Bool

    var body: some View {
        HStack(spacing: 16) {
            // 头像
            ZStack {
                Circle()
                    .fill(Color.blue.gradient)
                    .frame(width: 64, height: 64)

                if let user {
                    Text(String(user.name.prefix(1)))
                        .font(.title.bold())
                        .foregroundStyle(.white)
                } else {
                    Image(systemName: "person.fill")
                        .font(.title2)
                        .foregroundStyle(.white)
                }
            }

            if isLoading {
                VStack(alignment: .leading, spacing: 6) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 100, height: 16)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 140, height: 12)
                }
            } else if let user {
                VStack(alignment: .leading, spacing: 4) {
                    Text(user.name)
                        .font(.headline)
                    Text("@\(user.username)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(user.email)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            } else {
                Text("点击登录").font(.headline).foregroundStyle(.blue)
            }

            Spacer()
            Image(systemName: "chevron.right").foregroundStyle(.secondary)
        }
        .padding(.vertical, 8)
    }
}

// MARK: - 菜单行

private struct MenuRow: View {
    let item: ProfileMenuItem
    let viewModel: MineViewModel

    var body: some View {
        HStack(spacing: 14) {
            // 彩色图标背景
            RoundedRectangle(cornerRadius: 8)
                .fill(viewModel.iconColor(for: item.color).opacity(0.15))
                .frame(width: 34, height: 34)
                .overlay {
                    Image(systemName: item.icon)
                        .font(.subheadline)
                        .foregroundStyle(viewModel.iconColor(for: item.color))
                }

            Text(item.title)
                .font(.subheadline)

            Spacer()

            if let subtitle = item.subtitle {
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    MineView()
}
