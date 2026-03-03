//
//  AppStorageDemoView.swift
//  swiftUILearn
//
//  【知识点】@AppStorage 数据持久化
//  场景：记住图书馆偏好设置（字体大小、主题、最后搜索词）
//

import SwiftUI

struct AppStorageDemoView: View {
    // @AppStorage：自动读写 UserDefaults
    // 参数是 UserDefaults 的 key 名称
    // 应用关闭后再次打开，值仍然保留
    @AppStorage("library.fontSize") private var fontSize: Double = 16.0
    @AppStorage("library.isDarkMode") private var isDarkMode: Bool = false
    @AppStorage("library.lastSearch") private var lastSearch: String = ""
    @AppStorage("library.borrowCount") private var totalBorrowCount: Int = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                DemoHeader(
                    title: "@AppStorage",
                    subtitle: "@AppStorage 是 UserDefaults 的 SwiftUI 封装，像 @State 一样使用，但数据持久保存。"
                )

                // ── 1. 基础使用 ──
                GroupBox("⚙️ 图书馆偏好设置") {
                    VStack(spacing: 16) {

                        // 字体大小设置（Double）
                        HStack {
                            Text("阅读字号：\(Int(fontSize))pt")
                                .font(.footnote)
                            Spacer()
                            Slider(value: $fontSize, in: 12...24, step: 1)
                                .frame(width: 140)
                                .tint(.blue)
                        }

                        Divider()

                        // 深色模式（Bool）
                        Toggle("深色阅读模式", isOn: $isDarkMode)

                        Divider()

                        // 最近搜索（String）
                        HStack {
                            Image(systemName: "clock.arrow.circlepath")
                                .foregroundStyle(.secondary)
                                .font(.footnote)
                            Text("上次搜索：")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                            Text(lastSearch.isEmpty ? "（无）" : lastSearch)
                                .font(.footnote.bold())
                                .foregroundStyle(lastSearch.isEmpty ? .tertiary : .primary)
                        }

                        // 模拟搜索操作
                        HStack(spacing: 8) {
                            ForEach(["活着", "三体", "唐诗"], id: \.self) { keyword in
                                Button(keyword) {
                                    // 修改 @AppStorage 变量 = 写入 UserDefaults
                                    lastSearch = keyword
                                }
                                .font(.caption)
                                .buttonStyle(.bordered)
                            }
                        }
                    }
                    .padding(8)
                }

                // ── 2. 持久化效果演示 ──
                GroupBox("📊 借阅次数统计（持久化）") {
                    VStack(spacing: 12) {
                        Text("累计借阅：\(totalBorrowCount) 次")
                            .font(.title2.bold())
                            .foregroundStyle(.blue)

                        Text("关闭应用重新打开，这个数字依然保留")
                            .font(.caption2)
                            .foregroundStyle(.secondary)

                        HStack(spacing: 12) {
                            Button("借阅一本") {
                                totalBorrowCount += 1
                            }
                            .buttonStyle(.borderedProminent)

                            Button("重置", role: .destructive) {
                                totalBorrowCount = 0
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(8)
                }

                // ── 3. 预览效果 ──
                GroupBox("👁 实时预览") {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("《活着》— 余华 著")
                            .font(.system(size: fontSize, weight: .bold))

                        Text("这是一段示例文字，字体大小根据上方设置实时变化。调整滑块可以改变字号。")
                            .font(.system(size: fontSize))
                            .lineSpacing(4)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(12)
                    .background(isDarkMode ? Color.black : Color.white)
                    .foregroundStyle(isDarkMode ? Color.white : Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(8)
                }

                ConceptNote(items: [
                    "@AppStorage(\"key\")：自动绑定 UserDefaults，像 @State 一样使用",
                    "支持类型：String、Int、Double、Bool、Data、URL",
                    "应用关闭后数据保留，适合用户偏好、最近记录等",
                    "修改变量 = 写入 UserDefaults，读取变量 = 从 UserDefaults 读取",
                    "不适合存储大量数据：大数据应使用 CoreData 或 FileManager"
                ])
            }
            .padding()
        }
        .navigationTitle("@AppStorage")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        AppStorageDemoView()
    }
}
