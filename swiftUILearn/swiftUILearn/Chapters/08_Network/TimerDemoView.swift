//
//  TimerDemoView.swift
//  swiftUILearn
//
//  【知识点】Timer & TimelineView
//  场景：阅读计时器、自动轮播、实时时钟
//

import SwiftUI

struct TimerDemoView: View {
    // 计时器
    @State private var elapsedSeconds = 0
    @State private var timerRunning = false
    @State private var timer: Timer?

    // 自动轮播
    @State private var currentQuoteIndex = 0
    @State private var autoPlayTimer: Timer?
    @State private var isAutoPlaying = false

    // 倒计时
    @State private var remainingSeconds = 300
    @State private var countdownTimer: Timer?
    @State private var isCountingDown = false

    private let quotes = [
        "读书破万卷，下笔如有神。",
        "书中自有黄金屋。",
        "学而不思则罔，思而不学则殆。",
        "知识就是力量。",
        "活到老，学到老。"
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                DemoHeader(
                    title: "Timer & TimelineView",
                    subtitle: "Timer 用于定时执行任务，TimelineView 用于按时间线更新视图，两者都是实时更新 UI 的重要工具。"
                )

                // ── 1. 阅读计时器 ──
                GroupBox("⏱️ 阅读计时器") {
                    VStack(spacing: 16) {
                        Text(timeString(from: elapsedSeconds))
                            .font(.system(size: 48, weight: .thin, design: .monospaced))
                            .foregroundStyle(.blue)

                        HStack(spacing: 20) {
                            Button {
                                if timerRunning {
                                    stopTimer()
                                } else {
                                    startTimer()
                                }
                            } label: {
                                Label(timerRunning ? "暂停" : "开始",
                                      systemImage: timerRunning ? "pause.fill" : "play.fill")
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(timerRunning ? .orange : .blue)

                            Button {
                                stopTimer()
                                elapsedSeconds = 0
                            } label: {
                                Label("重置", systemImage: "arrow.counterclockwise")
                            }
                            .buttonStyle(.bordered)
                            .disabled(elapsedSeconds == 0)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(8)
                }

                // ── 2. 自动轮播 ──
                GroupBox("📖 名言自动轮播") {
                    VStack(spacing: 12) {
                        Text(quotes[currentQuoteIndex])
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .animation(.easeInOut, value: currentQuoteIndex)

                        HStack {
                            ForEach(0..<quotes.count, id: \.self) { i in
                                Circle()
                                    .fill(i == currentQuoteIndex ? Color.blue : Color.gray.opacity(0.3))
                                    .frame(width: 8, height: 8)
                            }
                        }

                        Button {
                            if isAutoPlaying {
                                stopAutoPlay()
                            } else {
                                startAutoPlay()
                            }
                        } label: {
                            Label(isAutoPlaying ? "停止轮播" : "自动轮播",
                                  systemImage: isAutoPlaying ? "stop.fill" : "play.fill")
                                .font(.caption)
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding(8)
                }

                // ── 3. TimelineView ──
                GroupBox("🕐 TimelineView 实时时钟") {
                    VStack(spacing: 12) {
                        Text("TimelineView 按时间线驱动视图更新")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        TimelineView(.periodic(from: .now, by: 1.0)) { context in
                            VStack(spacing: 8) {
                                Text(context.date.formatted(date: .abbreviated, time: .standard))
                                    .font(.title3.monospaced())
                                    .foregroundStyle(.blue)

                                Text("每秒自动更新")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .padding(8)
                }

                // ── 4. 借阅倒计时 ──
                GroupBox("⏳ 借阅到期倒计时") {
                    VStack(spacing: 12) {
                        Text(timeString(from: remainingSeconds))
                            .font(.system(size: 36, weight: .medium, design: .monospaced))
                            .foregroundStyle(remainingSeconds < 60 ? .red : .green)

                        Text(remainingSeconds < 60 ? "即将到期！" : "距离归还截止")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        HStack(spacing: 12) {
                            Button {
                                if isCountingDown {
                                    stopCountdown()
                                } else {
                                    startCountdown()
                                }
                            } label: {
                                Label(isCountingDown ? "暂停" : "开始倒计时",
                                      systemImage: isCountingDown ? "pause.fill" : "play.fill")
                                    .font(.caption)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(isCountingDown ? .orange : .green)

                            Button {
                                stopCountdown()
                                remainingSeconds = 300
                            } label: {
                                Label("重置 5 分钟", systemImage: "arrow.counterclockwise")
                                    .font(.caption)
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(8)
                }

                ConceptNote(items: [
                    "Timer.scheduledTimer：创建定时器，定期执行回调",
                    "TimelineView(.periodic)：SwiftUI 原生时间线视图，按间隔刷新",
                    "Timer.invalidate()：停止定时器，避免内存泄漏",
                    "onReceive(timer)：另一种方式，监听 Timer.publish 的值变化",
                    "TimelineView 适合纯展示（时钟），Timer 适合需要逻辑的场景（计时器）"
                ])
            }
            .padding()
        }
        .navigationTitle("Timer & TimelineView")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            stopTimer()
            stopAutoPlay()
            stopCountdown()
        }
    }

    // MARK: - Timer 方法

    private func timeString(from seconds: Int) -> String {
        let mins = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", mins, secs)
    }

    private func startTimer() {
        timerRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            elapsedSeconds += 1
        }
    }

    private func stopTimer() {
        timerRunning = false
        timer?.invalidate()
        timer = nil
    }

    private func startAutoPlay() {
        isAutoPlaying = true
        autoPlayTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
            withAnimation {
                currentQuoteIndex = (currentQuoteIndex + 1) % quotes.count
            }
        }
    }

    private func stopAutoPlay() {
        isAutoPlaying = false
        autoPlayTimer?.invalidate()
        autoPlayTimer = nil
    }

    private func startCountdown() {
        guard remainingSeconds > 0 else { return }
        isCountingDown = true
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if remainingSeconds > 0 {
                remainingSeconds -= 1
            } else {
                stopCountdown()
            }
        }
    }

    private func stopCountdown() {
        isCountingDown = false
        countdownTimer?.invalidate()
        countdownTimer = nil
    }
}

#Preview {
    NavigationStack {
        TimerDemoView()
    }
}
