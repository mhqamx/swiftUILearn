//
//  ProgressViewDemoView.swift
//  swiftUILearn
//
//  【知识点】ProgressView 进度
//  场景：加载指示器、阅读进度条、下载模拟
//

import SwiftUI

struct ProgressViewDemoView: View {
    @State private var readingProgress = 0.35
    @State private var downloadProgress = 0.0
    @State private var isDownloading = false
    @State private var downloadTimer: Timer?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                DemoHeader(
                    title: "ProgressView 进度",
                    subtitle: "ProgressView 有两种形式：不确定进度（加载中）和确定进度（进度条），都支持自定义样式。"
                )

                // ── 1. 不确定进度 ──
                GroupBox("⏳ 不确定进度（Loading）") {
                    VStack(spacing: 16) {
                        HStack(spacing: 30) {
                            VStack {
                                ProgressView()
                                Text("默认")
                                    .font(.caption)
                            }

                            VStack {
                                ProgressView()
                                    .scaleEffect(1.5)
                                Text("放大")
                                    .font(.caption)
                            }

                            VStack {
                                ProgressView()
                                    .tint(.orange)
                                Text("自定义颜色")
                                    .font(.caption)
                            }
                        }

                        ProgressView("加载书籍数据中...")
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(8)
                }

                // ── 2. 确定进度 ──
                GroupBox("📊 确定进度（阅读进度）") {
                    VStack(spacing: 12) {
                        ProgressView(value: readingProgress) {
                            Text("阅读进度")
                                .font(.caption)
                        } currentValueLabel: {
                            Text("\(Int(readingProgress * 100))%")
                                .font(.caption.bold())
                        }

                        ProgressView(value: readingProgress)
                            .tint(.green)

                        ProgressView(value: readingProgress)
                            .tint(.orange)
                            .scaleEffect(x: 1, y: 2, anchor: .center)

                        Slider(value: $readingProgress, in: 0...1)

                        Text("拖动滑块调整进度")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    .padding(8)
                }

                // ── 3. 自定义样式 ──
                GroupBox("🎨 自定义进度样式") {
                    VStack(spacing: 16) {
                        // 圆形进度
                        ZStack {
                            Circle()
                                .stroke(Color.gray.opacity(0.2), lineWidth: 8)
                            Circle()
                                .trim(from: 0, to: readingProgress)
                                .stroke(Color.blue, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                .rotationEffect(.degrees(-90))
                                .animation(.easeInOut, value: readingProgress)

                            VStack {
                                Text("\(Int(readingProgress * 100))%")
                                    .font(.title2.bold())
                                Text("已读")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .frame(width: 100, height: 100)

                        // 书籍进度条
                        HStack {
                            Image(systemName: "book.closed")
                                .foregroundStyle(.gray)
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.gray.opacity(0.2))
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.blue.gradient)
                                        .frame(width: geo.size.width * readingProgress)
                                }
                            }
                            .frame(height: 8)
                            Image(systemName: "book.fill")
                                .foregroundStyle(.blue)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(8)
                }

                // ── 4. Timer 驱动下载模拟 ──
                GroupBox("📖 下载模拟") {
                    VStack(spacing: 12) {
                        ProgressView(value: downloadProgress) {
                            HStack {
                                Text("下载电子书")
                                    .font(.caption)
                                Spacer()
                                Text("\(Int(downloadProgress * 100))%")
                                    .font(.caption.bold())
                            }
                        }
                        .tint(downloadProgress >= 1.0 ? .green : .blue)

                        HStack {
                            Button {
                                startDownload()
                            } label: {
                                Label(isDownloading ? "下载中..." : "开始下载",
                                      systemImage: isDownloading ? "arrow.down.circle" : "arrow.down.circle.fill")
                                    .font(.caption)
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(isDownloading)

                            if downloadProgress >= 1.0 {
                                Label("下载完成", systemImage: "checkmark.circle.fill")
                                    .font(.caption)
                                    .foregroundStyle(.green)
                            }

                            Spacer()

                            Button("重置") {
                                stopDownload()
                                downloadProgress = 0
                            }
                            .font(.caption)
                            .buttonStyle(.bordered)
                        }
                    }
                    .padding(8)
                }

                ConceptNote(items: [
                    "ProgressView()：不确定进度，显示旋转指示器",
                    "ProgressView(value:total:)：确定进度，value/total 计算百分比",
                    ".tint()：自定义进度条颜色",
                    "Circle().trim(from:to:)：自定义圆形进度条",
                    "Timer 驱动：通过定时器模拟真实的进度更新"
                ])
            }
            .padding()
        }
        .navigationTitle("ProgressView 进度")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear { stopDownload() }
    }

    private func startDownload() {
        isDownloading = true
        downloadProgress = 0
        downloadTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if downloadProgress < 1.0 {
                downloadProgress += 0.02
            } else {
                downloadProgress = 1.0
                stopDownload()
            }
        }
    }

    private func stopDownload() {
        isDownloading = false
        downloadTimer?.invalidate()
        downloadTimer = nil
    }
}

#Preview {
    NavigationStack {
        ProgressViewDemoView()
    }
}
