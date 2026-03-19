//
//  TabViewDemoView.swift
//  swiftUILearn
//
//  【知识点】TabView 标签页
//  场景：书架、收藏、设置标签页切换
//

import SwiftUI

struct TabViewDemoView: View {
    @State private var selectedTab = 0
    @State private var unreadCount = 3

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                DemoHeader(
                    title: "TabView 标签页",
                    subtitle: "TabView 用于创建多标签页的界面，是 App 底部导航的核心组件。"
                )

                // ── 1. 基础 TabView ──
                GroupBox("📱 基础 TabView") {
                    VStack(spacing: 12) {
                        Text("3 个标签页切换")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        TabView {
                            // 书架
                            VStack {
                                Image(systemName: "books.vertical.fill")
                                    .font(.largeTitle)
                                    .foregroundStyle(.blue)
                                Text("我的书架")
                                    .font(.headline)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .tabItem {
                                Label("书架", systemImage: "books.vertical")
                            }

                            // 收藏
                            VStack {
                                Image(systemName: "heart.fill")
                                    .font(.largeTitle)
                                    .foregroundStyle(.red)
                                Text("我的收藏")
                                    .font(.headline)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .tabItem {
                                Label("收藏", systemImage: "heart")
                            }

                            // 设置
                            VStack {
                                Image(systemName: "gearshape.fill")
                                    .font(.largeTitle)
                                    .foregroundStyle(.gray)
                                Text("设置")
                                    .font(.headline)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .tabItem {
                                Label("设置", systemImage: "gearshape")
                            }
                        }
                        .frame(height: 200)
                    }
                    .padding(8)
                }

                // ── 2. Badge 角标 ──
                GroupBox("🔢 Badge 角标") {
                    VStack(spacing: 12) {
                        Text("使用 .badge() 显示未读数量")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        TabView {
                            Text("消息列表")
                                .tabItem {
                                    Label("消息", systemImage: "message")
                                }
                                .badge(unreadCount)

                            Text("通知列表")
                                .tabItem {
                                    Label("通知", systemImage: "bell")
                                }
                                .badge("New")
                        }
                        .frame(height: 120)

                        Stepper("未读消息数：\(unreadCount)", value: $unreadCount, in: 0...99)
                            .font(.caption)
                    }
                    .padding(8)
                }

                // ── 3. Page 样式 ──
                GroupBox("🎠 Page 轮播样式") {
                    VStack(spacing: 12) {
                        Text(".tabViewStyle(.page) 实现翻页轮播")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        TabView {
                            ForEach(1...5, id: \.self) { i in
                                RoundedRectangle(cornerRadius: 12)
                                    .fill([Color.blue, .green, .orange, .purple, .pink][i - 1].gradient)
                                    .overlay {
                                        VStack {
                                            Image(systemName: "book.fill")
                                                .font(.largeTitle)
                                            Text("推荐书籍 \(i)")
                                                .font(.headline)
                                        }
                                        .foregroundStyle(.white)
                                    }
                                    .padding(.horizontal, 8)
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .always))
                        .frame(height: 180)
                    }
                    .padding(8)
                }

                // ── 4. 编程切换 ──
                GroupBox("🔀 编程切换 Tab") {
                    VStack(spacing: 12) {
                        Text("通过 @State selection 控制当前标签")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        HStack {
                            ForEach(0..<3) { index in
                                Button {
                                    withAnimation { selectedTab = index }
                                } label: {
                                    Text(["书架", "收藏", "设置"][index])
                                        .font(.caption)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(selectedTab == index ? Color.blue : Color.gray.opacity(0.2))
                                        .foregroundStyle(selectedTab == index ? .white : .primary)
                                        .clipShape(Capsule())
                                }
                            }
                        }

                        TabView(selection: $selectedTab) {
                            Text("📚 书架内容").tag(0)
                            Text("❤️ 收藏内容").tag(1)
                            Text("⚙️ 设置内容").tag(2)
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .frame(height: 80)
                    }
                    .padding(8)
                }

                ConceptNote(items: [
                    ".tabItem { Label() }：定义标签页图标和文字",
                    ".badge(count)：在标签上显示角标数字或文字",
                    ".tabViewStyle(.page)：切换为页面轮播样式",
                    "TabView(selection:)：通过绑定变量编程切换标签页",
                    "iOS 18+ Tab 类型：新的 Tab 写法，可定义 role 和自定义行为"
                ])
            }
            .padding()
        }
        .navigationTitle("TabView 标签页")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        TabViewDemoView()
    }
}
