//
//  ErrorView.swift
//  swiftUILearn
//
//  全局通用错误状态视图
//

import SwiftUI

/// 全屏错误提示视图（带重试按钮）
struct ErrorView: View {
    let error: Error
    let retryAction: (() -> Void)?

    init(error: Error, retryAction: (() -> Void)? = nil) {
        self.error = error
        self.retryAction = retryAction
    }

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 52))
                .foregroundStyle(.secondary)

            Text("加载失败")
                .font(.headline)

            Text(error.localizedDescription)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            if let retry = retryAction {
                Button("重新加载") {
                    retry()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

/// 空数据状态视图
struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String?
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 52))
                .foregroundStyle(.secondary)

            Text(title)
                .font(.headline)

            if let subtitle {
                Text(subtitle)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            if let title = actionTitle, let action {
                Button(title, action: action)
                    .buttonStyle(.bordered)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

#Preview {
    VStack {
        ErrorView(error: URLError(.notConnectedToInternet)) {
            print("retry")
        }
        EmptyStateView(
            icon: "newspaper",
            title: "暂无新闻",
            subtitle: "当前没有可用的新闻内容",
            actionTitle: "刷新",
            action: { print("refresh") }
        )
    }
}
