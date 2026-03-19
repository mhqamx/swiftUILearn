//
//  GestureDemoView.swift
//  swiftUILearn
//
//  【知识点】Gesture 手势
//  场景：手势交互、拖拽卡片、缩放旋转、翻页效果
//

import SwiftUI

struct GestureDemoView: View {
    // 点击与长按
    @State private var tapCount = 0
    @State private var isLongPressed = false

    // 拖拽
    @State private var dragOffset: CGSize = .zero
    @State private var lastDragOffset: CGSize = .zero

    // 缩放与旋转
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var rotation: Angle = .zero
    @State private var lastRotation: Angle = .zero

    // 翻页
    @State private var currentPage = 0
    private let totalPages = 5

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                DemoHeader(
                    title: "Gesture 手势",
                    subtitle: "SwiftUI 提供了丰富的手势识别器，支持点击、长按、拖拽、缩放、旋转和手势组合。"
                )

                // ── 1. 点击与长按 ──
                GroupBox("👆 点击与长按") {
                    VStack(spacing: 16) {
                        // 双击
                        HStack(spacing: 20) {
                            VStack {
                                Image(systemName: "heart.fill")
                                    .font(.system(size: 40))
                                    .foregroundStyle(tapCount > 0 ? .red : .gray)
                                    .scaleEffect(tapCount > 0 ? 1.2 : 1.0)
                                    .animation(.spring(response: 0.3), value: tapCount)
                                    .onTapGesture(count: 2) {
                                        tapCount += 1
                                    }
                                Text("双击点赞 (\(tapCount))")
                                    .font(.caption)
                            }

                            VStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(isLongPressed ? Color.green.gradient : Color.blue.gradient)
                                    .frame(width: 80, height: 80)
                                    .overlay {
                                        Image(systemName: isLongPressed ? "checkmark" : "hand.tap")
                                            .foregroundStyle(.white)
                                            .font(.title2)
                                    }
                                    .scaleEffect(isLongPressed ? 0.9 : 1.0)
                                    .onLongPressGesture(minimumDuration: 0.5) {
                                        isLongPressed.toggle()
                                    }
                                Text("长按切换")
                                    .font(.caption)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(8)
                }

                // ── 2. 拖拽手势 ──
                GroupBox("↔️ 拖拽手势") {
                    VStack(spacing: 12) {
                        Text("拖拽移动书籍卡片")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.orange.gradient)
                                .frame(width: 120, height: 80)
                                .overlay {
                                    VStack {
                                        Image(systemName: "book.fill")
                                            .foregroundStyle(.white)
                                        Text("拖拽我")
                                            .font(.caption)
                                            .foregroundStyle(.white)
                                    }
                                }
                                .offset(dragOffset)
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            dragOffset = CGSize(
                                                width: lastDragOffset.width + value.translation.width,
                                                height: lastDragOffset.height + value.translation.height
                                            )
                                        }
                                        .onEnded { _ in
                                            lastDragOffset = dragOffset
                                        }
                                )
                        }
                        .frame(height: 150)

                        Button("重置位置") {
                            withAnimation(.spring) {
                                dragOffset = .zero
                                lastDragOffset = .zero
                            }
                        }
                        .font(.caption)
                        .buttonStyle(.bordered)
                    }
                    .padding(8)
                }

                // ── 3. 缩放与旋转 ──
                GroupBox("🔍 缩放与旋转") {
                    VStack(spacing: 12) {
                        Text("双指缩放和旋转操作封面")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Image(systemName: "book.closed.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(.purple.gradient)
                            .scaleEffect(scale)
                            .rotationEffect(rotation)
                            .gesture(
                                MagnifyGesture()
                                    .onChanged { value in
                                        scale = lastScale * value.magnification
                                    }
                                    .onEnded { _ in
                                        lastScale = scale
                                    }
                            )
                            .gesture(
                                RotateGesture()
                                    .onChanged { value in
                                        rotation = lastRotation + value.rotation
                                    }
                                    .onEnded { _ in
                                        lastRotation = rotation
                                    }
                            )
                            .frame(height: 120)

                        HStack {
                            Text("缩放: \(String(format: "%.1f", scale))x")
                            Text("旋转: \(String(format: "%.0f", rotation.degrees))°")
                        }
                        .font(.caption.monospaced())
                        .foregroundStyle(.secondary)

                        Button("重置") {
                            withAnimation(.spring) {
                                scale = 1.0
                                lastScale = 1.0
                                rotation = .zero
                                lastRotation = .zero
                            }
                        }
                        .font(.caption)
                        .buttonStyle(.bordered)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(8)
                }

                // ── 4. 手势组合 ──
                GroupBox("🔗 手势组合") {
                    VStack(spacing: 12) {
                        Text("长按后才能拖拽（.sequenced）")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        SequencedGestureDemo()
                    }
                    .padding(8)
                }

                // ── 5. 翻页效果 ──
                GroupBox("📖 拖拽翻页") {
                    VStack(spacing: 12) {
                        Text("左右拖拽翻页")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        PageSwipeView(currentPage: $currentPage, totalPages: totalPages)

                        HStack {
                            ForEach(0..<totalPages, id: \.self) { i in
                                Circle()
                                    .fill(i == currentPage ? Color.blue : Color.gray.opacity(0.3))
                                    .frame(width: 8, height: 8)
                            }
                        }
                    }
                    .padding(8)
                }

                ConceptNote(items: [
                    "TapGesture(count:)：单击/双击/多次点击手势",
                    "LongPressGesture(minimumDuration:)：长按手势，可设最短时间",
                    "DragGesture：拖拽手势，通过 onChanged/onEnded 跟踪位移",
                    "MagnifyGesture / RotateGesture：缩放和旋转手势",
                    ".simultaneously：同时识别两个手势",
                    ".sequenced(before:)：顺序手势，如长按后拖拽",
                    "@GestureState：手势结束后自动重置的状态"
                ])
            }
            .padding()
        }
        .navigationTitle("Gesture 手势")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 顺序手势演示
private struct SequencedGestureDemo: View {
    @State private var isActivated = false
    @State private var offset: CGSize = .zero

    var body: some View {
        let longPress = LongPressGesture(minimumDuration: 0.5)
            .onEnded { _ in
                withAnimation { isActivated = true }
            }

        let drag = DragGesture()
            .onChanged { value in
                if isActivated {
                    offset = value.translation
                }
            }
            .onEnded { _ in
                withAnimation(.spring) {
                    offset = .zero
                    isActivated = false
                }
            }

        RoundedRectangle(cornerRadius: 12)
            .fill(isActivated ? Color.green.gradient : Color.blue.gradient)
            .frame(width: 100, height: 70)
            .overlay {
                VStack {
                    Image(systemName: isActivated ? "arrow.up.and.down.and.arrow.left.and.right" : "hand.tap")
                        .foregroundStyle(.white)
                    Text(isActivated ? "可拖拽" : "长按激活")
                        .font(.caption2)
                        .foregroundStyle(.white)
                }
            }
            .offset(offset)
            .gesture(longPress.sequenced(before: drag))
            .frame(height: 100)
    }
}

// MARK: - 翻页视图
private struct PageSwipeView: View {
    @Binding var currentPage: Int
    let totalPages: Int
    @State private var swipeOffset: CGFloat = 0

    private let bookColors: [Color] = [.blue, .green, .orange, .purple, .pink]

    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(bookColors[currentPage % bookColors.count].gradient)
            .frame(height: 120)
            .overlay {
                VStack {
                    Image(systemName: "book.fill")
                        .font(.title)
                    Text("第 \(currentPage + 1) 章")
                        .font(.headline)
                }
                .foregroundStyle(.white)
            }
            .offset(x: swipeOffset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        swipeOffset = value.translation.width
                    }
                    .onEnded { value in
                        let threshold: CGFloat = 50
                        withAnimation(.spring) {
                            if value.translation.width < -threshold && currentPage < totalPages - 1 {
                                currentPage += 1
                            } else if value.translation.width > threshold && currentPage > 0 {
                                currentPage -= 1
                            }
                            swipeOffset = 0
                        }
                    }
            )
    }
}

#Preview {
    NavigationStack {
        GestureDemoView()
    }
}
