//
//  PhotosPickerDemoView.swift
//  swiftUILearn
//
//  【知识点】PhotosPicker 相册
//  场景：选择书籍封面、批量选图
//

import SwiftUI
import PhotosUI

struct PhotosPickerDemoView: View {
    // 单张选择
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: Image?

    // 多张选择
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImages: [Image] = []

    // 加载状态
    @State private var isLoading = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                DemoHeader(
                    title: "PhotosPicker 相册",
                    subtitle: "PhotosPicker 是 SwiftUI 原生的相册选择器，无需请求相册权限即可使用。"
                )

                // ── 1. 单张选择 ──
                GroupBox("🖼️ 单张选择") {
                    VStack(spacing: 12) {
                        Text("选择一张书籍封面")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        if let selectedImage {
                            selectedImage
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        } else {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.1))
                                .frame(height: 150)
                                .overlay {
                                    VStack {
                                        Image(systemName: "photo")
                                            .font(.largeTitle)
                                            .foregroundStyle(.gray)
                                        Text("暂无图片")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                        }

                        PhotosPicker(selection: $selectedItem, matching: .images) {
                            Label("选择封面", systemImage: "photo.on.rectangle")
                        }
                        .buttonStyle(.borderedProminent)
                        .onChange(of: selectedItem) { _, newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                    selectedImage = Image(uiImage: uiImage)
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(8)
                }

                // ── 2. 多张选择 ──
                GroupBox("📷 多张选择") {
                    VStack(spacing: 12) {
                        Text("最多选择 4 张图片")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        if !selectedImages.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(0..<selectedImages.count, id: \.self) { index in
                                        selectedImages[index]
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                    }
                                }
                            }
                        }

                        PhotosPicker(
                            selection: $selectedItems,
                            maxSelectionCount: 4,
                            matching: .images
                        ) {
                            Label("选择多张图片", systemImage: "photo.stack")
                        }
                        .buttonStyle(.bordered)
                        .onChange(of: selectedItems) { _, newItems in
                            Task {
                                selectedImages = []
                                for item in newItems {
                                    if let data = try? await item.loadTransferable(type: Data.self),
                                       let uiImage = UIImage(data: data) {
                                        selectedImages.append(Image(uiImage: uiImage))
                                    }
                                }
                            }
                        }

                        Text("已选 \(selectedImages.count) 张")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(8)
                }

                // ── 3. 加载处理 ──
                GroupBox("🔄 loadTransferable") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("异步加载选择的图片数据")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("// 加载图片数据")
                            Text("let data = try await item")
                            Text("    .loadTransferable(type: Data.self)")
                            Text("let image = UIImage(data: data)")
                        }
                        .font(.caption.monospaced())
                        .foregroundStyle(.secondary)
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.blue.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .padding(8)
                }

                // ── 4. 内容过滤 ──
                GroupBox("🎯 内容过滤") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("通过 matching 参数过滤内容类型")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        FilterRow(name: ".images", desc: "只显示图片")
                        FilterRow(name: ".screenshots", desc: "只显示截图")
                        FilterRow(name: ".videos", desc: "只显示视频")
                        FilterRow(name: ".livePhotos", desc: "只显示实况照片")
                        FilterRow(name: ".any(of: [.images, .videos])", desc: "图片和视频")
                        FilterRow(name: ".not(.screenshots)", desc: "排除截图")
                    }
                    .padding(8)
                }

                ConceptNote(items: [
                    "PhotosPicker：SwiftUI 原生选择器，无需请求相册权限",
                    "PhotosPickerItem：选中的相册项，需异步加载数据",
                    "loadTransferable(type:)：异步加载并转换数据",
                    "maxSelectionCount：限制最大选择数量",
                    "matching：PHPickerFilter 过滤器，筛选图片/视频/截图等"
                ])
            }
            .padding()
        }
        .navigationTitle("PhotosPicker 相册")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct FilterRow: View {
    let name: String
    let desc: String

    var body: some View {
        HStack(spacing: 8) {
            Text(name)
                .font(.caption.monospaced())
                .foregroundStyle(.orange)
            Spacer()
            Text(desc)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    NavigationStack {
        PhotosPickerDemoView()
    }
}
