//
//  ModuleTabView.swift
//  swiftUILearn
//
//  实战模块：4个 TabBar 的根容器
//  架构总览：
//
//  ┌─────────────────────────────────────────────────┐
//  │                  ModuleTabView                   │
//  │                                                  │
//  │  ┌──────────┬──────────┬──────────┬──────────┐  │
//  │  │ HomeView │ MallView │ NewsView │ MineView │  │
//  │  └──────────┴──────────┴──────────┴──────────┘  │
//  │                                                  │
//  │  每个 Tab：                                       │
//  │  View ← ViewModel(ObservableObject)              │
//  │              ↓                                   │
//  │         NetworkManager (单例)                    │
//  │              ↓                                   │
//  │         APIEndpoint → URLSession → JSONDecoder   │
//  └─────────────────────────────────────────────────┘
//

import SwiftUI

struct ModuleTabView: View {
    @State private var selectedTab: Tab = .home

    // Tab 枚举定义（集中管理，方便扩展）
    enum Tab: String, CaseIterable {
        case home    = "首页"
        case mall    = "商城"
        case news    = "新闻"
        case mine    = "我的"

        var icon: String {
            switch self {
            case .home:  return "house.fill"
            case .mall:  return "bag.fill"
            case .news:  return "newspaper.fill"
            case .mine:  return "person.fill"
            }
        }

        var color: Color {
            switch self {
            case .home:  return .blue
            case .mall:  return .orange
            case .news:  return .green
            case .mine:  return .purple
            }
        }
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label(Tab.home.rawValue, systemImage: Tab.home.icon)
                }
                .tag(Tab.home)

            MallView()
                .tabItem {
                    Label(Tab.mall.rawValue, systemImage: Tab.mall.icon)
                }
                .tag(Tab.mall)

            NewsView()
                .tabItem {
                    Label(Tab.news.rawValue, systemImage: Tab.news.icon)
                }
                .tag(Tab.news)

            MineView()
                .tabItem {
                    Label(Tab.mine.rawValue, systemImage: Tab.mine.icon)
                }
                .tag(Tab.mine)
        }
        // Tab 选中颜色跟随当前 Tab 的主题色
        .tint(selectedTab.color)
    }
}

#Preview {
    ModuleTabView()
}
