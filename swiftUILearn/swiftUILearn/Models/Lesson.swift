//
//  Lesson.swift
//  swiftUILearn
//
//  知识点和章节的数据模型
//

import SwiftUI

// MARK: - 知识点模型
/// 代表一个独立的 SwiftUI 知识点 Demo
struct Lesson: Identifiable, Hashable {
    let id = UUID()
    let title: String           // 知识点名称，如 "Text 文本"
    let description: String     // 一句话描述
    let icon: String            // SF Symbol 图标名
    /// 生成对应 Demo 视图的闭包
    /// 使用 AnyView 包装，以便存储在数组中
    let destination: () -> AnyView

    // Hashable 和 Equatable 只比较 id
    static func == (lhs: Lesson, rhs: Lesson) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

// MARK: - 章节模型
/// 代表一个学习章节，包含多个知识点
struct Chapter: Identifiable, Hashable {
    let id = UUID()
    let title: String           // 章节名称，如 "第一章：基础视图"
    let icon: String            // SF Symbol 图标名
    let color: Color            // 章节主题色
    let lessons: [Lesson]       // 该章节包含的知识点列表

    static func == (lhs: Chapter, rhs: Chapter) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
