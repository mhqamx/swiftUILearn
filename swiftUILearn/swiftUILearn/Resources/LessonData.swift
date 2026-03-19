//
//  LessonData.swift
//  swiftUILearn
//
//  所有知识点和章节的注册表
//  新增 Demo 时，在此处注册即可自动出现在菜单中
//

import SwiftUI

// MARK: - 知识点注册表
/// 所有章节和知识点的数据源
struct LessonData {
    static let chapters: [Chapter] = [
        chapter01_Basics,
        chapter02_Layout,
        chapter03_State,
        chapter04_Navigation,
        chapter05_List,
        chapter06_Animation,
        chapter07_Persistence,
        chapter08_Network,
        chapter09_Controls,
        chapter10_Graphics,
        chapter11_RealWorld
    ]
}

// MARK: - 第一章：基础视图
private let chapter01_Basics = Chapter(
    title: "基础视图",
    icon: "square.grid.2x2",
    color: .blue,
    lessons: [
        Lesson(title: "Text 文本", description: "显示和样式化文本内容",
               icon: "textformat") { AnyView(TextDemoView()) },
        Lesson(title: "Image 图片", description: "展示图片和 SF Symbols 图标",
               icon: "photo") { AnyView(ImageDemoView()) },
        Lesson(title: "Button 按钮", description: "响应用户点击的交互控件",
               icon: "hand.tap") { AnyView(ButtonDemoView()) },
        Lesson(title: "TextField 输入框", description: "接收用户文本输入",
               icon: "keyboard") { AnyView(TextFieldDemoView()) },
        Lesson(title: "Toggle 开关", description: "布尔值的开关控件",
               icon: "toggle.on") { AnyView(ToggleDemoView()) },
        Lesson(title: "Slider 滑块", description: "在范围内选择连续值",
               icon: "slider.horizontal.3") { AnyView(SliderDemoView()) }
    ]
)

// MARK: - 第二章：布局系统
private let chapter02_Layout = Chapter(
    title: "布局系统",
    icon: "rectangle.3.group",
    color: .green,
    lessons: [
        Lesson(title: "Stack 堆叠布局", description: "VStack / HStack / ZStack 三种布局容器",
               icon: "square.3.layers.3d") { AnyView(StacksDemoView()) },
        Lesson(title: "Spacer & Padding", description: "间距与内边距控制",
               icon: "arrow.left.and.right") { AnyView(SpacerPaddingDemoView()) },
        Lesson(title: "GeometryReader", description: "获取视图尺寸和坐标信息",
               icon: "ruler") { AnyView(GeometryReaderDemoView()) },
        Lesson(title: "Grid 网格布局", description: "LazyVGrid 创建灵活的网格",
               icon: "grid") { AnyView(GridDemoView()) },
        Lesson(title: "ScrollView 滚动视图", description: "滚动容器与滚动控制",
               icon: "scroll") { AnyView(ScrollViewDemoView()) }
    ]
)

// MARK: - 第三章：状态管理
private let chapter03_State = Chapter(
    title: "状态管理",
    icon: "arrow.triangle.2.circlepath",
    color: .orange,
    lessons: [
        Lesson(title: "@State 本地状态", description: "视图内部的私有状态",
               icon: "circle.inset.filled") { AnyView(StateDemoView()) },
        Lesson(title: "@Binding 数据绑定", description: "父子视图之间的双向数据流",
               icon: "link") { AnyView(BindingDemoView()) },
        Lesson(title: "@StateObject / @ObservedObject", description: "ViewModel 的创建与观察",
               icon: "eye") { AnyView(ObservableDemoView()) },
        Lesson(title: "@EnvironmentObject", description: "跨多层视图共享数据",
               icon: "network") { AnyView(EnvironmentObjectDemoView()) },
        Lesson(title: "@Observable 宏", description: "iOS 17+ 新一代观察机制",
               icon: "sparkles") { AnyView(ObservableMacroDemoView()) }
    ]
)

// MARK: - 第四章：导航路由
private let chapter04_Navigation = Chapter(
    title: "导航路由",
    icon: "arrow.right.square",
    color: .purple,
    lessons: [
        Lesson(title: "NavigationStack", description: "栈式页面导航",
               icon: "square.stack") { AnyView(NavigationStackDemoView()) },
        Lesson(title: "Sheet & FullScreen", description: "模态弹出页面",
               icon: "arrow.up.square") { AnyView(SheetDemoView()) },
        Lesson(title: "Alert & Dialog", description: "警告弹窗与确认对话框",
               icon: "exclamationmark.triangle") { AnyView(AlertDemoView()) },
        Lesson(title: "TabView 标签页", description: "多标签页切换与轮播",
               icon: "square.grid.2x2") { AnyView(TabViewDemoView()) },
        Lesson(title: "Toolbar 工具栏", description: "导航栏按钮与键盘工具栏",
               icon: "menubar.rectangle") { AnyView(ToolbarDemoView()) }
    ]
)

// MARK: - 第五章：列表与数据
private let chapter05_List = Chapter(
    title: "列表与数据",
    icon: "list.bullet",
    color: .teal,
    lessons: [
        Lesson(title: "List 基础", description: "展示可滚动的数据列表",
               icon: "list.bullet.rectangle") { AnyView(ListBasicsDemoView()) },
        Lesson(title: "Section 分组", description: "将列表数据按组划分",
               icon: "list.bullet.indent") { AnyView(ListSectionDemoView()) },
        Lesson(title: "Searchable 搜索", description: "为列表添加搜索功能",
               icon: "magnifyingglass") { AnyView(SearchableDemoView()) },
        Lesson(title: "Swipe Actions 侧滑", description: "侧滑显示操作按钮",
               icon: "arrow.left.arrow.right") { AnyView(SwipeActionsDemoView()) }
    ]
)

// MARK: - 第六章：动画与手势
private let chapter06_Animation = Chapter(
    title: "动画与手势",
    icon: "wand.and.stars",
    color: .pink,
    lessons: [
        Lesson(title: "基础动画", description: "withAnimation 和隐式动画",
               icon: "play.circle") { AnyView(BasicAnimationDemoView()) },
        Lesson(title: "Transition 过渡", description: "视图出现与消失的过渡效果",
               icon: "arrow.left.and.right.righttriangle.left.righttriangle.right") { AnyView(TransitionDemoView()) },
        Lesson(title: "MatchedGeometry", description: "跨视图的几何匹配动画",
               icon: "arrow.up.left.and.arrow.down.right") { AnyView(MatchedGeometryDemoView()) },
        Lesson(title: "Gesture 手势", description: "点击、拖拽、缩放、旋转等手势交互",
               icon: "hand.draw") { AnyView(GestureDemoView()) }
    ]
)

// MARK: - 第七章：数据持久化
private let chapter07_Persistence = Chapter(
    title: "数据持久化",
    icon: "externaldrive",
    color: .brown,
    lessons: [
        Lesson(title: "@AppStorage", description: "简单数据的本地持久化",
               icon: "internaldrive") { AnyView(AppStorageDemoView()) },
        Lesson(title: "FileManager", description: "读写本地文件",
               icon: "folder") { AnyView(FileManagerDemoView()) },
        Lesson(title: "CoreData 基础", description: "结构化数据的数据库存储",
               icon: "cylinder") { AnyView(CoreDataDemoView()) },
        Lesson(title: "SwiftData 基础", description: "现代化的数据持久化框架",
               icon: "cylinder.split.1x2") { AnyView(SwiftDataDemoView()) }
    ]
)

// MARK: - 第八章：网络与系统集成
private let chapter08_Network = Chapter(
    title: "网络与系统集成",
    icon: "globe",
    color: .cyan,
    lessons: [
        Lesson(title: "URLSession + async/await", description: "现代 Swift 并发网络请求",
               icon: "arrow.down.circle") { AnyView(NetworkRequestDemoView()) },
        Lesson(title: "PhotosPicker 相册", description: "原生相册选择器",
               icon: "photo.on.rectangle") { AnyView(PhotosPickerDemoView()) },
        Lesson(title: "ShareLink 分享", description: "原生分享控件",
               icon: "square.and.arrow.up") { AnyView(ShareLinkDemoView()) },
        Lesson(title: "Map 地图", description: "地图显示与标注",
               icon: "map") { AnyView(MapDemoView()) },
        Lesson(title: "Timer & TimelineView", description: "定时器与时间线视图",
               icon: "timer") { AnyView(TimerDemoView()) }
    ]
)

// MARK: - 第九章：选择控件
private let chapter09_Controls = Chapter(
    title: "选择控件",
    icon: "filemenu.and.selection",
    color: .mint,
    lessons: [
        Lesson(title: "Picker 选择器", description: "通用选择器与日期、颜色选择",
               icon: "list.bullet.circle") { AnyView(PickerDemoView()) },
        Lesson(title: "ProgressView 进度", description: "加载指示器与进度条",
               icon: "circle.dashed") { AnyView(ProgressViewDemoView()) },
        Lesson(title: "Menu & ContextMenu", description: "下拉菜单与长按上下文菜单",
               icon: "ellipsis.circle") { AnyView(MenuDemoView()) },
        Lesson(title: "@FocusState 焦点", description: "输入框焦点管理与键盘工具栏",
               icon: "keyboard.badge.eye") { AnyView(FocusStateDemoView()) }
    ]
)

// MARK: - 第十章：图形与样式
private let chapter10_Graphics = Chapter(
    title: "图形与样式",
    icon: "paintbrush",
    color: .purple,
    lessons: [
        Lesson(title: "Shape & Path", description: "自定义图形绘制",
               icon: "star.circle") { AnyView(ShapePathDemoView()) },
        Lesson(title: "Color & Gradient", description: "颜色系统与渐变效果",
               icon: "paintpalette") { AnyView(ColorGradientDemoView()) },
        Lesson(title: "ViewModifier & @ViewBuilder", description: "自定义修饰符与视图构建器",
               icon: "wand.and.rays") { AnyView(ViewModifierDemoView()) },
        Lesson(title: "Swift Charts 图表", description: "原生图表框架",
               icon: "chart.bar") { AnyView(ChartsDemoView()) }
    ]
)

// MARK: - 第十一章：实战模块（TabBar + 网络请求）
private let chapter11_RealWorld = Chapter(
    title: "实战模块",
    icon: "hammer.fill",
    color: .indigo,
    lessons: [
        Lesson(title: "完整 App 架构", description: "TabBar + MVVM + 网络请求实战",
               icon: "square.stack.3d.up.fill") { AnyView(ModuleTabView()) }
    ]
)
