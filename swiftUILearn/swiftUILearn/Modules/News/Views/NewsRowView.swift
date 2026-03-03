//
//  NewsRowView.swift
//  swiftUILearn
//
//  新闻列表行视图 + 新闻详情视图
//

import SwiftUI

/// 新闻列表行
struct NewsRowView: View {
    let article: NewsArticle

    private let tagColors: [Color] = [.blue, .orange, .green, .purple, .red, .teal]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 12) {
                // 正文内容
                VStack(alignment: .leading, spacing: 8) {
                    Text(article.formattedTitle)
                        .font(.subheadline.bold())
                        .lineLimit(2)
                        .foregroundStyle(.primary)

                    Text(article.summary)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)

                    HStack(spacing: 8) {
                        // 分类标签
                        Text(article.category)
                            .font(.caption2.bold())
                            .padding(.horizontal, 6).padding(.vertical, 2)
                            .background(tagColors[article.userId % tagColors.count].opacity(0.12))
                            .foregroundStyle(tagColors[article.userId % tagColors.count])
                            .clipShape(Capsule())

                        // 发布时间
                        Image(systemName: "clock")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        Text(article.publishedAt)
                            .font(.caption2)
                            .foregroundStyle(.secondary)

                        Spacer()

                        // 阅读数
                        Image(systemName: "eye")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        Text("\(article.readCount)")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }

                // 右侧图片（实际项目用 AsyncImage）
                RoundedRectangle(cornerRadius: 8)
                    .fill(tagColors[article.userId % tagColors.count].opacity(0.15))
                    .frame(width: 80, height: 70)
                    .overlay {
                        Image(systemName: "newspaper.fill")
                            .foregroundStyle(tagColors[article.userId % tagColors.count].opacity(0.6))
                    }
            }
            .padding(.vertical, 12)

            Divider()
        }
        .padding(.horizontal)
    }
}

/// 新闻详情视图（NavigationLink 目标）
struct NewsDetailView: View {
    let article: NewsArticle
    @State private var isLiked = false
    @State private var isBookmarked = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // 标题
                Text(article.formattedTitle)
                    .font(.title2.bold())

                // 元信息
                HStack(spacing: 12) {
                    Label(article.category, systemImage: "tag")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Label(article.publishedAt, systemImage: "clock")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Label("\(article.readCount)", systemImage: "eye")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Divider()

                // 正文（重复显示模拟长文章）
                Text(article.body)
                    .font(.body)
                    .lineSpacing(8)

                Text(article.body + "\n\n" + article.body)
                    .font(.body)
                    .lineSpacing(8)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
        .navigationTitle("详情")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button {
                        isLiked.toggle()
                    } label: {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .foregroundStyle(isLiked ? .red : .primary)
                    }
                    Button {
                        isBookmarked.toggle()
                    } label: {
                        Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                    }
                }
            }
        }
    }
}
