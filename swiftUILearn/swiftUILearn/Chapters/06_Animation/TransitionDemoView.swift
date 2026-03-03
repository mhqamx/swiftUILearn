//
//  TransitionDemoView.swift
//  swiftUILearn
//
//  【知识点】Transition 过渡动画
//  场景：书籍添加/删除时的出现与消失效果
//

import SwiftUI

struct TransitionDemoView: View {
    @State private var showNewBook = false
    @State private var books: [String] = ["活着", "三体", "百年孤独"]
    @State private var selectedTransition = TransitionType.slide

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                DemoHeader(
                    title: "Transition 过渡",
                    subtitle: "Transition 定义视图出现（insert）和消失（removal）时的动画效果。"
                )

                // ── 1. 各种过渡类型对比 ──
                GroupBox("🎭 过渡类型选择") {
                    VStack(spacing: 12) {
                        Picker("过渡类型", selection: $selectedTransition) {
                            ForEach(TransitionType.allCases, id: \.self) { type in
                                Text(type.rawValue).tag(type)
                            }
                        }
                        .pickerStyle(.segmented)

                        Button {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                showNewBook.toggle()
                            }
                        } label: {
                            Label(showNewBook ? "隐藏书籍" : "显示书籍",
                                  systemImage: showNewBook ? "eye.slash" : "eye")
                        }
                        .buttonStyle(.borderedProminent)

                        // 被过渡动画控制的视图
                        if showNewBook {
                            NewBookCard()
                                // .transition：指定视图出现/消失时的动画效果
                                .transition(selectedTransition.transition)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(8)
                }

                // ── 2. 书单动态增减 ──
                GroupBox("📚 书单动态增减") {
                    VStack(spacing: 12) {
                        HStack {
                            Button {
                                withAnimation(.spring(duration: 0.3)) {
                                    books.append("新书 #\(books.count + 1)")
                                }
                            } label: {
                                Label("添加书籍", systemImage: "plus")
                            }
                            .buttonStyle(.bordered)

                            Button {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    if !books.isEmpty { books.removeLast() }
                                }
                            } label: {
                                Label("移除书籍", systemImage: "minus")
                            }
                            .buttonStyle(.bordered)
                            .disabled(books.isEmpty)
                        }

                        // 每个书籍卡片有各自的过渡动画
                        ForEach(books, id: \.self) { title in
                            HStack {
                                Image(systemName: "book.fill").foregroundStyle(.blue)
                                Text(title)
                                Spacer()
                            }
                            .padding(10)
                            .background(Color.blue.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            // 组合过渡：同时应用多个效果
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing).combined(with: .opacity),
                                removal: .move(edge: .leading).combined(with: .opacity)
                            ))
                        }
                    }
                    .padding(8)
                }

                ConceptNote(items: [
                    ".transition(.slide)：从左边滑入/滑出",
                    ".transition(.opacity)：淡入淡出",
                    ".transition(.scale)：缩放出现/消失",
                    ".transition(.move(edge: .bottom))：从指定边缘移入/移出",
                    ".asymmetric(insertion:removal:)：出现和消失使用不同过渡",
                    "transition1.combined(with: transition2)：组合多个过渡效果"
                ])
            }
            .padding()
        }
        .navigationTitle("Transition 过渡")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 过渡类型枚举
private enum TransitionType: String, CaseIterable {
    case slide = "Slide"
    case opacity = "Opacity"
    case scale = "Scale"
    case move = "Move"
    case combined = "Combined"

    var transition: AnyTransition {
        switch self {
        case .slide:    return .slide
        case .opacity:  return .opacity
        case .scale:    return .scale
        case .move:     return .move(edge: .bottom)
        case .combined: return .move(edge: .bottom).combined(with: .opacity)
        }
    }
}

// MARK: - 新书卡片
private struct NewBookCard: View {
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.green.gradient)
                .frame(width: 56, height: 72)
                .overlay {
                    Image(systemName: "sparkles")
                        .foregroundStyle(.white)
                }

            VStack(alignment: .leading, spacing: 4) {
                Text("新上架书籍")
                    .font(.headline)
                Text("刚刚到馆，欢迎借阅")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    NavigationStack {
        TransitionDemoView()
    }
}
