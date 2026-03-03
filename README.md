# SwiftUI Learn

一个系统化的 SwiftUI 学习项目，涵盖从基础视图到完整 App 实战的全部知识体系。通过 **27 个可交互 Demo** 和 **4 个实战模块**，循序渐进地掌握 SwiftUI 开发。

## 项目概览

项目分为两大部分：

- **教学章节** — 7 个章节、27 个知识点 Demo，使用 `NavigationSplitView` 三栏浏览
- **实战模块** — 首页 / 商城 / 新闻 / 我的，完整 MVVM + 网络请求架构

## 学习章节

| 章节 | 知识点 | 内容 |
|------|--------|------|
| 第一章 基础视图 | 6 个 | Text、Image、Button、TextField、Toggle、Slider |
| 第二章 布局系统 | 4 个 | Stack、Spacer & Padding、GeometryReader、Grid |
| 第三章 状态管理 | 4 个 | @State、@Binding、@StateObject、@EnvironmentObject |
| 第四章 导航路由 | 3 个 | NavigationStack、Sheet、Alert |
| 第五章 列表与数据 | 4 个 | List、Section、Searchable、Swipe Actions |
| 第六章 动画与过渡 | 3 个 | Basic Animation、Transition、MatchedGeometry |
| 第七章 数据持久化 | 3 个 | @AppStorage、FileManager、CoreData |

每个 Demo 都包含可交互的演示区域和底部知识点说明，支持实时操作和效果预览。

## 实战模块

基于 MVVM 架构的 4 个真实 App 模块：

- **首页** — 轮播 Banner、快速入口九宫格、推荐内容
- **商城** — 商品网格布局、分页加载、搜索与排序
- **新闻** — 新闻列表、分页加载、搜索与侧滑操作
- **我的** — 用户信息、菜单项、设置选项

网络数据基于 [JSONPlaceholder](https://jsonplaceholder.typicode.com) API。

## 项目结构

```
swiftUILearn/
├── swiftUILearnApp.swift              # 应用入口
├── ContentView.swift                  # 三栏导航根容器
├── Core/
│   ├── Network/                       # 网络层（NetworkManager、APIEndpoint、APIError）
│   ├── Models/                        # 数据模型（NewsArticle、Product、AppUser）
│   └── Components/                    # 通用 UI 组件（LoadingView、ErrorView）
├── Chapters/                          # 学习章节（27 个 Demo）
│   ├── 01_Basics/
│   ├── 02_Layout/
│   ├── 03_State/
│   ├── 04_Navigation/
│   ├── 05_List/
│   ├── 06_Animation/
│   └── 07_Persistence/
├── Modules/                           # 实战模块（MVVM）
│   ├── App/ModuleTabView.swift
│   ├── Home/
│   ├── News/
│   ├── Mall/
│   └── Mine/
├── Models/Lesson.swift                # 知识点数据模型
├── Main/SharedComponents.swift        # 共享 UI 组件
└── Resources/LessonData.swift         # 章节注册表
```

## 技术栈

- **SwiftUI** — 声明式 UI 框架
- **Swift Concurrency** — async/await、async let、@MainActor
- **URLSession** — 网络请求 + Codable 解析
- **CoreData** — 关系数据库持久化
- **MVVM** — View + ViewModel（ObservableObject）架构
- **NavigationSplitView** — 自适应 iPad / iPhone 的三栏布局

## 环境要求

- Xcode 15.0+
- iOS 17.0+
- Swift 5.9+

## 运行方式

1. 克隆仓库
   ```bash
   git clone https://github.com/mhqamx/swiftUILearn.git
   ```
2. 用 Xcode 打开 `swiftUILearn/swiftUILearn.xcodeproj`
3. 选择模拟器或真机，点击运行

## License

MIT
