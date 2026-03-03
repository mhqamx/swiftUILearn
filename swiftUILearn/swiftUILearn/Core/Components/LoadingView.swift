//
//  LoadingView.swift
//  swiftUILearn
//
//  全局通用加载状态视图
//

import SwiftUI

/// 全屏加载占位视图
struct LoadingView: View {
    var message: String = "加载中..."

    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text(message)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

/// 内嵌小型加载指示器（用于列表末尾分页加载）
struct InlineLoadingView: View {
    var body: some View {
        HStack(spacing: 8) {
            ProgressView()
            Text("加载更多...")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

/// 骨架屏占位行（模拟列表行加载中的效果）
struct SkeletonRow: View {
    @State private var isAnimating = false

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .frame(width: 60, height: 60)
                .foregroundStyle(Color.gray.opacity(isAnimating ? 0.15 : 0.3))

            VStack(alignment: .leading, spacing: 8) {
                RoundedRectangle(cornerRadius: 4)
                    .frame(height: 14)
                    .foregroundStyle(Color.gray.opacity(isAnimating ? 0.15 : 0.3))

                RoundedRectangle(cornerRadius: 4)
                    .frame(width: 120, height: 10)
                    .foregroundStyle(Color.gray.opacity(isAnimating ? 0.15 : 0.3))
            }
        }
        .padding(.vertical, 4)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
    }
}

#Preview {
    VStack(spacing: 32) {
        LoadingView()
        InlineLoadingView()
        SkeletonRow()
        SkeletonRow()
    }
    .padding()
}
