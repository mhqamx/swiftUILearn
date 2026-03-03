# SwiftUI 学习工程设计文档

**日期：** 2026-02-13
**项目：** swiftUILearn
**目标用户：** 有 Swift 基础、零 SwiftUI 经验的开发者

---

## 一、项目目标

构建一个以**图书馆管理系统**为主题的 SwiftUI 交互式学习工程，覆盖入门到进阶的核心知识点。每个知识点都是一个可独立运行的 Demo，通过侧边菜单浏览，配有中文注释和实际场景示例。

---

## 二、整体架构

### 目录结构

```
swiftUILearn/
├── App/
│   └── swiftUILearnApp.swift        # 应用入口
├── Main/
│   └── ContentView.swift            # NavigationSplitView 根容器
├── Models/
│   └── Lesson.swift                 # 知识点数据模型（章节、标题、描述）
├── Chapters/
│   ├── 01_Basics/                   # 第一章：基础视图
│   ├── 02_Layout/                   # 第二章：布局系统
│   ├── 03_State/                    # 第三章：状态管理
│   ├── 04_Navigation/               # 第四章：导航与路由
│   ├── 05_List/                     # 第五章：列表与数据
│   ├── 06_Animation/                # 第六章：动画与过渡
│   └── 07_Persistence/              # 第七章：数据持久化
└── Resources/
    └── LessonData.swift             # 所有知识点注册表（章节 + 知识点列表）
```

### 导航结构

采用 `NavigationSplitView` 三栏布局：
- **左栏**：7个章节列表
- **中栏**：当前章节的知识点列表
- **右栏**：选中知识点的 Demo 页面

iPhone 上自动折叠为 `NavigationStack` 栈式导航。

---

## 三、知识点规划

以图书馆管理系统为贯穿主题，所有示例围绕"书籍、借阅、读者、分类"展开。

| 章节 | 知识点 | 图书馆场景 |
|------|--------|------------|
| **第一章 基础视图** | Text、Image、Button、TextField、Toggle、Slider | 书籍卡片、搜索框、借阅开关、评分 |
| **第二章 布局系统** | VStack/HStack/ZStack、Spacer、Padding、GeometryReader、Grid | 书架布局、书籍封面网格、详情页 |
| **第三章 状态管理** | @State、@Binding、@StateObject、@ObservedObject、@EnvironmentObject | 借阅状态、收藏书单、全局用户信息 |
| **第四章 导航路由** | NavigationStack、NavigationLink、sheet、fullScreenCover、alert | 书籍详情跳转、新增弹窗、删除确认 |
| **第五章 列表数据** | List、ForEach、Section、搜索、下拉刷新、侧滑删除 | 书籍列表、分类浏览、借阅记录 |
| **第六章 动画过渡** | withAnimation、transition、matchedGeometryEffect、自定义动画 | 借书动画、上架效果、页面切换 |
| **第七章 数据持久化** | @AppStorage、UserDefaults、FileManager、CoreData 基础 | 记住登录状态、保存书单、离线数据 |

---

## 四、页面统一格式

每个知识点 Demo 页面遵循统一结构：

```
┌─────────────────────────────────┐
│  📖 知识点标题                    │
│  一句话说明这个知识点的用途         │
├─────────────────────────────────┤
│                                 │
│   【可交互 Demo 区域】             │
│   （书籍卡片 / 列表 / 动画等）      │
│                                 │
├─────────────────────────────────┤
│  💡 核心概念注释                  │
│  // 关键代码说明                  │
└─────────────────────────────────┘
```

---

## 五、技术约定

- **最低支持：** iOS 17
- **架构：** MVVM（State/ObservableObject）
- **自包含：** 每个 Demo 文件不依赖其他 Demo
- **注释语言：** 中文注释 + 英文代码标识符
- **预览：** 每个 Demo 使用 `#Preview` 宏，可独立预览
- **主题色：** 使用图书馆棕色/暖色调，SF Symbols 图标

---

## 六、数据模型

```swift
// 知识点模型
struct Lesson: Identifiable, Hashable {
    let id: UUID
    let title: String        // 知识点名称
    let description: String  // 一句话描述
    let chapter: Chapter     // 所属章节
}

// 章节模型
struct Chapter: Identifiable, Hashable {
    let id: UUID
    let title: String        // 章节名称
    let icon: String         // SF Symbol 图标
    let lessons: [Lesson]    // 知识点列表
}
```
