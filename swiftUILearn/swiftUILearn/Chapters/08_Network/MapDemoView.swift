//
//  MapDemoView.swift
//  swiftUILearn
//
//  【知识点】Map 地图
//  场景：显示图书馆位置、标注地点
//

import SwiftUI
import MapKit

struct MapDemoView: View {
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 39.9042, longitude: 116.4074),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )
    @State private var selectedStyle = 0
    @State private var showMarkers = true

    // 示例图书馆位置
    private let libraries = [
        LibraryLocation(name: "国家图书馆", coordinate: CLLocationCoordinate2D(latitude: 39.9421, longitude: 116.3186)),
        LibraryLocation(name: "首都图书馆", coordinate: CLLocationCoordinate2D(latitude: 39.8743, longitude: 116.4740)),
        LibraryLocation(name: "海淀区图书馆", coordinate: CLLocationCoordinate2D(latitude: 39.9589, longitude: 116.3100))
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                DemoHeader(
                    title: "Map 地图",
                    subtitle: "SwiftUI 的 Map 视图提供了原生的地图显示能力，支持标注、标记和各种交互。"
                )

                // ── 1. 基础地图 ──
                GroupBox("🗺️ 基础地图") {
                    VStack(spacing: 12) {
                        Text("显示北京地区地图")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Map(position: $position) {
                        }
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(8)
                }

                // ── 2. 标注与标记 ──
                GroupBox("📍 Marker 与 Annotation") {
                    VStack(spacing: 12) {
                        Text("标记附近图书馆位置")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Map(position: $position) {
                            if showMarkers {
                                ForEach(libraries) { library in
                                    Marker(library.name, systemImage: "book.fill", coordinate: library.coordinate)
                                        .tint(.blue)
                                }

                                // Annotation 自定义标注
                                Annotation("中心", coordinate: CLLocationCoordinate2D(latitude: 39.9042, longitude: 116.4074)) {
                                    VStack {
                                        Image(systemName: "mappin.circle.fill")
                                            .font(.title)
                                            .foregroundStyle(.red)
                                        Text("北京")
                                            .font(.caption2)
                                            .padding(4)
                                            .background(.white.opacity(0.8))
                                            .clipShape(Capsule())
                                    }
                                }
                            }
                        }
                        .frame(height: 220)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                        Toggle("显示标注", isOn: $showMarkers)
                            .font(.caption)
                    }
                    .padding(8)
                }

                // ── 3. 地图样式 ──
                GroupBox("🔍 地图样式") {
                    VStack(spacing: 12) {
                        Picker("样式", selection: $selectedStyle) {
                            Text("标准").tag(0)
                            Text("卫星").tag(1)
                            Text("混合").tag(2)
                        }
                        .pickerStyle(.segmented)

                        Map(position: $position) {
                            ForEach(libraries) { library in
                                Marker(library.name, coordinate: library.coordinate)
                            }
                        }
                        .mapStyle(mapStyle)
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(8)
                }

                // ── 4. 地图交互 ──
                GroupBox("📏 地图控制") {
                    VStack(spacing: 12) {
                        Text("编程控制地图视角")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        HStack {
                            ForEach(libraries) { library in
                                Button(library.name.prefix(4).description) {
                                    withAnimation {
                                        position = .region(MKCoordinateRegion(
                                            center: library.coordinate,
                                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                                        ))
                                    }
                                }
                                .font(.caption)
                                .buttonStyle(.bordered)
                            }
                        }

                        Button("重置视图") {
                            withAnimation {
                                position = .region(MKCoordinateRegion(
                                    center: CLLocationCoordinate2D(latitude: 39.9042, longitude: 116.4074),
                                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                                ))
                            }
                        }
                        .font(.caption)
                        .buttonStyle(.bordered)
                    }
                    .padding(8)
                }

                ConceptNote(items: [
                    "Map(position:)：SwiftUI 原生地图视图，iOS 17+ 新 API",
                    "Marker：地图标记，支持系统图标和颜色",
                    "Annotation：自定义标注视图，可放任意 SwiftUI 视图",
                    "MapCameraPosition：控制地图视角，支持 region/camera",
                    ".mapStyle(.standard/.imagery/.hybrid)：切换地图样式"
                ])
            }
            .padding()
        }
        .navigationTitle("Map 地图")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var mapStyle: MapStyle {
        switch selectedStyle {
        case 1: return .imagery
        case 2: return .hybrid
        default: return .standard
        }
    }
}

// MARK: - 图书馆位置模型
private struct LibraryLocation: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

#Preview {
    NavigationStack {
        MapDemoView()
    }
}
