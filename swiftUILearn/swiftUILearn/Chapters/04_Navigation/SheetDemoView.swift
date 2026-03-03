//
//  SheetDemoView.swift
//  swiftUILearn
//
//  【知识点】Sheet / FullScreenCover 模态弹出
//  场景：新增书籍表单、书籍预览全屏
//

import SwiftUI

struct SheetDemoView: View {
    @State private var showAddBookSheet = false
    @State private var showPreviewSheet = false
    @State private var showFullScreenCover = false
    @State private var showDetents = false
    @State private var addedBooks: [String] = []

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                DemoHeader(
                    title: "Sheet & FullScreenCover",
                    subtitle: "Sheet 从底部弹出模态视图，FullScreenCover 全屏覆盖，两者都通过 Bool 控制显示。"
                )

                // ── 1. 基础 Sheet ──
                GroupBox("📋 基础 Sheet（半屏弹出）") {
                    VStack(spacing: 12) {
                        Button {
                            showAddBookSheet = true
                        } label: {
                            Label("新增书籍", systemImage: "plus.circle")
                        }
                        .buttonStyle(.borderedProminent)
                        // .sheet(isPresented: $bool) { 内容视图 }
                        .sheet(isPresented: $showAddBookSheet) {
                            AddBookSheetView { title in
                                addedBooks.append(title)
                            }
                        }

                        if !addedBooks.isEmpty {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("已添加的书籍：")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                ForEach(addedBooks, id: \.self) { title in
                                    Text("• \(title)")
                                        .font(.caption)
                                        .foregroundStyle(.primary)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(8)
                }

                // ── 2. 可调高度 Sheet（detents）──
                GroupBox("📐 可调高度 Sheet") {
                    VStack(spacing: 12) {
                        Button {
                            showDetents = true
                        } label: {
                            Label("书籍快速预览", systemImage: "doc.text.magnifyingglass")
                        }
                        .buttonStyle(.bordered)
                        .sheet(isPresented: $showDetents) {
                            BookPreviewSheet()
                                // .presentationDetents：设置允许的高度挡位
                                .presentationDetents([
                                    .fraction(0.35),    // 35% 屏幕高度
                                    .medium,            // 50% 屏幕高度
                                    .large              // 全屏
                                ])
                                // .presentationDragIndicator：显示顶部拖拽条
                                .presentationDragIndicator(.visible)
                        }

                        Text("拖拽可切换：35% → 50% → 全屏")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    .padding(8)
                }

                // ── 3. FullScreenCover 全屏 ──
                GroupBox("🖥 FullScreenCover 全屏弹出") {
                    VStack(spacing: 8) {
                        Button {
                            showFullScreenCover = true
                        } label: {
                            Label("全屏阅读模式", systemImage: "book.fill")
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.brown)
                        // .fullScreenCover：完全覆盖屏幕，不显示背后内容
                        .fullScreenCover(isPresented: $showFullScreenCover) {
                            FullReadingView()
                        }

                        Text("FullScreenCover 不可下拉关闭，需在内部提供关闭按钮")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    .padding(8)
                }

                ConceptNote(items: [
                    ".sheet(isPresented: $bool) {}：Bool 为 true 时弹出，可下拉关闭",
                    ".presentationDetents([.medium, .large])：设置 Sheet 高度挡位",
                    ".presentationDragIndicator(.visible)：显示顶部拖拽指示器",
                    ".fullScreenCover(isPresented: $bool) {}：全屏覆盖，不可下拉关闭",
                    "@Environment(\\.dismiss)：在弹出视图内部调用 dismiss() 关闭"
                ])
            }
            .padding()
        }
        .navigationTitle("Sheet & FullScreenCover")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 新增书籍 Sheet 内容
private struct AddBookSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var author = ""
    let onAdd: (String) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("书籍信息") {
                    TextField("书名（必填）", text: $title)
                    TextField("作者", text: $author)
                }
                Section {
                    Text("填写完整后点击右上角添加确认")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("新增书籍")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("添加") {
                        onAdd(title.isEmpty ? "未命名书籍" : title)
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}

// MARK: - 书籍快速预览 Sheet
private struct BookPreviewSheet: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("书籍预览").font(.headline)
                Spacer()
                Button { dismiss() } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal)
            .padding(.top)

            Divider()

            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("《活着》").font(.title2.bold())
                    Text("余华 著 | 南海出版公司").foregroundStyle(.secondary)
                    Text("内容简介：讲述了农村人福贵悲惨的人生遭遇，富贵是中国过去60年所有苦难的经历者和见证者...")
                        .font(.body)
                }
                .padding()
            }
        }
    }
}

// MARK: - 全屏阅读视图
private struct FullReadingView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.brown.opacity(0.1).ignoresSafeArea()

            VStack(spacing: 24) {
                Text("《活着》").font(.largeTitle.bold())

                ScrollView {
                    Text("""
                    我比现在年轻十岁的时候，获得了一个游手好闲的职业，去乡间收集民间歌谣。
                    那一年的整个夏天，我如同一只乱飞的麻雀，游荡在中国的田野里...
                    """)
                    .font(.body)
                    .lineSpacing(8)
                    .padding()
                }

                Button {
                    dismiss()  // 调用 dismiss 关闭全屏
                } label: {
                    Label("退出阅读", systemImage: "xmark")
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
    }
}

#Preview {
    NavigationStack {
        SheetDemoView()
    }
}
