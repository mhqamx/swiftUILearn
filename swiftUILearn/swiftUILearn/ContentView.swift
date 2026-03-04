//
//  ContentView.swift
//  swiftUILearn
//
//  根容器：使用 NavigationSplitView 实现三栏布局
//  左栏：章节列表  中栏：知识点列表  右栏：Demo 展示
//

import SwiftUI

struct ContentView: View {
    // 当前选中的章节（左栏 → 中栏）
    @State private var selectedChapter: Chapter?
    // 当前选中的知识点（中栏 → 右栏）
    @State private var selectedLesson: Lesson?

    var body: some View {
        NavigationSplitView {
            // ── 左栏：章节列表 ──
            ChapterSidebarView(selectedChapter: $selectedChapter)

        } content: {
            // ── 中栏：知识点列表 ──
            if let chapter = selectedChapter {
                LessonListView(chapter: chapter, selectedLesson: $selectedLesson)
            } else {
                Text("请选择章节")
                    .foregroundStyle(.secondary)
            }

        } detail: {
            // ── 右栏：Demo 展示 ──
            if let lesson = selectedLesson {
                lesson.destination()
            } else {
                WelcomeView()
            }
        }
    }
}

// MARK: - 左栏：章节侧边栏
private struct ChapterSidebarView: View {
    @Binding var selectedChapter: Chapter?

    var body: some View {
        List(LessonData.chapters, selection: $selectedChapter) { chapter in
            Label {
                VStack(alignment: .leading, spacing: 2) {
                    Text(chapter.title)
                        .font(.headline)
                    Text("\(chapter.lessons.count) 个知识点")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            } icon: {
                Image(systemName: chapter.icon)
                    .foregroundStyle(chapter.color)
            }
            .tag(chapter)
        }
        .navigationTitle("📚 SwiftUI 学习")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - 中栏：知识点列表
private struct LessonListView: View {
    let chapter: Chapter
    @Binding var selectedLesson: Lesson?

    var body: some View {
        List(chapter.lessons, selection: $selectedLesson) { lesson in
            Label {
                VStack(alignment: .leading, spacing: 2) {
                    Text(lesson.title)
                        .font(.headline)
                    Text(lesson.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            } icon: {
                Image(systemName: lesson.icon)
                    .foregroundStyle(chapter.color)
            }
            .tag(lesson)
        }
        .navigationTitle(chapter.title)
    }
}

// MARK: - 右栏：欢迎页（未选中知识点时显示）
private struct WelcomeView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "books.vertical.fill")
                .font(.system(size: 64))
                .foregroundStyle(.brown)

            Text("欢迎来到 SwiftUI 图书馆")
                .font(.largeTitle.bold())

            Text("从左侧选择章节和知识点\n开始你的学习之旅")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
