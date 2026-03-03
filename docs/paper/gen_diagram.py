#!/usr/bin/env python3
"""生成论文所需的架构图（PNG格式）- 使用 Hiragino Sans GB 中文字体"""

import os
import math
from PIL import Image, ImageDraw, ImageFont

OUTPUT_DIR = os.path.dirname(os.path.abspath(__file__))

# ── 字体加载 ──────────────────────────────────────────────────
FONT_REGULAR = '/System/Library/Fonts/Hiragino Sans GB.ttc'
FONT_BOLD_IDX = 2  # W6 = Bold
FONT_REG_IDX = 0   # W3 = Regular

def font(size, bold=False):
    return ImageFont.truetype(FONT_REGULAR, size, index=FONT_BOLD_IDX if bold else FONT_REG_IDX)

TITLE = font(22, bold=True)
HEADER = font(16, bold=True)
BODY = font(13)
SMALL = font(11)
TINY = font(10)

# ── 工具函数 ──────────────────────────────────────────────────
def make_bg(w, h, color=(248, 249, 252)):
    img = Image.new("RGB", (w, h), color)
    return img, ImageDraw.Draw(img)

def rrect(draw, x0, y0, x1, y1, r, fill, outline=None, lw=1):
    draw.rounded_rectangle([x0, y0, x1, y1], radius=r, fill=fill, outline=outline, width=lw)

def text_c(draw, cx, cy, text, fnt, color=(30, 30, 30)):
    bb = draw.textbbox((0, 0), text, font=fnt)
    tw, th = bb[2] - bb[0], bb[3] - bb[1]
    draw.text((cx - tw // 2, cy - th // 2), text, font=fnt, fill=color)

def arrow_down(draw, x, y1, y2, color=(150, 150, 150)):
    draw.line([(x, y1), (x, y2)], fill=color, width=2)
    draw.polygon([(x - 6, y2 - 8), (x + 6, y2 - 8), (x, y2)], fill=color)

def arrow_right(draw, x1, y, x2, color, label=None, label_font=None, label_y=None, label_color=None):
    draw.line([(x1, y), (x2, y)], fill=color, width=2)
    d = 1 if x2 > x1 else -1
    draw.polygon([(x2 - d * 10, y - 6), (x2 - d * 10, y + 6), (x2, y)], fill=color)
    if label and label_font:
        ly = label_y if label_y else y - 18
        draw.text(((x1 + x2) // 2 - 20, ly), label, font=label_font, fill=label_color or color)


# ═════════════════════════════════════════════════════════════
# 图1：整体架构图
# ═════════════════════════════════════════════════════════════
def gen_arch_diagram():
    W, H = 900, 560
    img, d = make_bg(W, H)

    text_c(d, W // 2, 28, "SwiftUI 学习工程 — 整体架构图", TITLE)

    # Layer 1: UI 层
    rrect(d, 30, 60, 870, 160, 12, (220, 235, 255), (100, 140, 220), 2)
    d.text((50, 68), "UI 层 (View Layer)", font=HEADER, fill=(60, 80, 180))
    ui_items = [
        ("01 基础视图", 60), ("02 布局系统", 185), ("03 状态管理", 310),
        ("04 导航路由", 435), ("05 列表数据", 560), ("06 动画过渡", 685), ("07 持久化", 800)
    ]
    for name, x in ui_items:
        rrect(d, x, 94, x + 115, 148, 8, (255, 255, 255), (100, 140, 220), 1)
        text_c(d, x + 57, 121, name, BODY, (50, 70, 160))

    # Layer 2: ViewModel 层
    rrect(d, 30, 185, 870, 285, 12, (220, 255, 220), (80, 180, 100), 2)
    d.text((50, 193), "ViewModel 层 (Business Logic)", font=HEADER, fill=(40, 140, 60))
    vms = [("HomeViewModel", 60), ("MallViewModel", 240), ("NewsViewModel", 420), ("MineViewModel", 600), ("ObservableObject", 770)]
    for name, x in vms:
        rrect(d, x, 218, x + 165, 270, 8, (255, 255, 255), (80, 180, 100), 1)
        text_c(d, x + 82, 244, name, BODY, (30, 120, 50))

    # Layer 3: 网络层
    rrect(d, 30, 310, 580, 410, 12, (255, 240, 215), (200, 140, 60), 2)
    d.text((50, 318), "网络层 (Network Layer)", font=HEADER, fill=(160, 100, 30))
    for name, x in [("NetworkManager", 60), ("APIEndpoint", 240), ("APIError", 420)]:
        rrect(d, x, 344, x + 155, 398, 8, (255, 255, 255), (200, 140, 60), 1)
        text_c(d, x + 77, 371, name, BODY, (140, 80, 20))

    # Layer 3: 数据模型层
    rrect(d, 600, 310, 870, 410, 12, (255, 220, 240), (180, 80, 140), 2)
    d.text((618, 318), "数据模型层", font=HEADER, fill=(150, 50, 110))
    for name, x in [("NewsArticle", 618), ("Product", 750)]:
        rrect(d, x, 344, x + 110, 398, 8, (255, 255, 255), (180, 80, 140), 1)
        text_c(d, x + 55, 371, name, BODY, (130, 40, 90))

    # Layer 4: 基础设施层
    rrect(d, 30, 435, 870, 535, 12, (235, 235, 235), (160, 160, 160), 2)
    d.text((50, 443), "基础设施 (Infrastructure)", font=HEADER, fill=(100, 100, 100))
    for name, x in [("URLSession / async-await", 60), ("UserDefaults / AppStorage", 280), ("FileManager / CoreData", 500), ("NavigationStack / Split", 720)]:
        rrect(d, x, 470, x + 200, 523, 8, (255, 255, 255), (160, 160, 160), 1)
        text_c(d, x + 100, 496, name, BODY, (80, 80, 80))

    # 箭头
    for y1, y2 in [(160, 185), (285, 310), (410, 435)]:
        arrow_down(d, W // 2, y1, y2)

    img.save(os.path.join(OUTPUT_DIR, "fig1_architecture.png"), "PNG")
    print("✅ fig1_architecture.png")


# ═════════════════════════════════════════════════════════════
# 图2：MVVM 数据流图
# ═════════════════════════════════════════════════════════════
def gen_mvvm_diagram():
    W, H = 800, 380
    img, d = make_bg(W, H)

    text_c(d, W // 2, 20, "MVVM 架构数据流图", TITLE)

    # 三个核心区域
    regions = [
        (40, 110, 230, 280, (220, 235, 255), (100, 140, 220), "View", "SwiftUI 视图层", "@StateObject\n@Published 订阅"),
        (280, 70, 520, 310, (220, 255, 220), (80, 180, 100), "ViewModel", "业务逻辑层", "@Published\nasync/await\n@MainActor"),
        (560, 110, 760, 280, (255, 240, 215), (200, 140, 60), "Model", "数据模型层", "Codable\nIdentifiable"),
    ]

    for x0, y0, x1, y1, fill, outline, title, subtitle, detail in regions:
        rrect(d, x0, y0, x1, y1, 14, fill, outline, 2)
        cx = (x0 + x1) // 2
        cy_t = y0 + 30
        text_c(d, cx, cy_t, title, font(18, True), (30, 30, 30))
        text_c(d, cx, cy_t + 22, subtitle, SMALL, (80, 80, 80))
        lines = detail.split('\n')
        for i, ln in enumerate(lines):
            text_c(d, cx, cy_t + 52 + i * 18, ln, TINY, (100, 100, 100))

    # 箭头 View -> ViewModel
    arrow_right(d, 230, 175, 280, (100, 140, 220), "用户操作", SMALL, 157, (80, 100, 160))
    # 箭头 ViewModel -> View (反向)
    arrow_right(d, 280, 215, 230, (80, 180, 100), "@Published 更新", SMALL, 218, (60, 140, 80))
    # 箭头 ViewModel -> Model
    arrow_right(d, 520, 175, 560, (200, 140, 60), "请求数据", SMALL, 157, (160, 110, 30))
    # 箭头 Model -> ViewModel (反向)
    arrow_right(d, 560, 215, 520, (80, 180, 100), "返回模型", SMALL, 218, (60, 140, 80))

    # 底部说明
    d.text((40, 340), "数据流向：用户操作 → ViewModel 处理 → Model 层读写 → @Published 通知 → View 自动重绘", font=SMALL, fill=(120, 120, 120))

    img.save(os.path.join(OUTPUT_DIR, "fig2_mvvm.png"), "PNG")
    print("✅ fig2_mvvm.png")


# ═════════════════════════════════════════════════════════════
# 图3：学习路径图
# ═════════════════════════════════════════════════════════════
def gen_learning_path():
    W, H = 860, 420
    img, d = make_bg(W, H)

    text_c(d, W // 2, 20, "SwiftUI 学习路径设计", TITLE)

    chapters = [
        ("Ch.01", "基础视图", (50, 120, 200)),
        ("Ch.02", "布局系统", (60, 160, 220)),
        ("Ch.03", "状态管理", (220, 100, 60)),
        ("Ch.04", "导航路由", (140, 80, 200)),
        ("Ch.05", "列表数据", (60, 180, 160)),
        ("Ch.06", "动画过渡", (200, 150, 50)),
        ("Ch.07", "持久化", (160, 80, 120)),
    ]

    # 蛇形排列
    xs = [60, 170, 280, 390, 500, 610, 720]
    ys = [80, 190, 80, 190, 80, 190, 80]
    bw, bh = 90, 90

    prev_cx, prev_cy = None, None
    for i, ((ch, name, color), x, y) in enumerate(zip(chapters, xs, ys)):
        x1, y1 = x + bw, y + bh
        cx, cy = x + bw // 2, y + bh // 2

        bg = tuple(min(c + 160, 255) for c in color)
        rrect(d, x, y, x1, y1, 12, bg, color, 2)
        text_c(d, cx, cy - 12, ch, SMALL, color)
        text_c(d, cx, cy + 10, name, BODY, (30, 30, 30))

        if prev_cx is not None:
            # 连线
            d.line([(prev_cx, prev_cy), (cx, cy)], fill=(180, 180, 180), width=2)
            dx, dy = cx - prev_cx, cy - prev_cy
            length = math.sqrt(dx * dx + dy * dy)
            ux, uy = dx / length, dy / length
            px, py = -uy, ux
            tip = (cx - int(ux * 14), cy - int(uy * 14))
            d.polygon([
                (tip[0] + int(px * 6), tip[1] + int(py * 6)),
                (tip[0] - int(px * 6), tip[1] - int(py * 6)),
                (cx, cy)
            ], fill=(180, 180, 180))

        prev_cx, prev_cy = cx, cy

    # 实战模块
    rrect(d, 180, 310, 680, 395, 14, (255, 245, 220), (200, 140, 50), 2)
    text_c(d, 430, 340, "实战模块：MVVM + 网络请求 + TabBar", HEADER, (140, 100, 20))
    text_c(d, 430, 370, "综合运用所有章节知识点", SMALL, (160, 120, 40))

    img.save(os.path.join(OUTPUT_DIR, "fig3_learning_path.png"), "PNG")
    print("✅ fig3_learning_path.png")


# ═════════════════════════════════════════════════════════════
# 图4：状态管理对比表
# ═════════════════════════════════════════════════════════════
def gen_state_comparison():
    W, H = 820, 360
    img, d = make_bg(W, H)

    text_c(d, W // 2, 20, "SwiftUI 状态管理属性包装器对比", TITLE)

    headers = ["属性包装器", "作用域", "所有权", "使用场景", "持久化"]
    col_w = [160, 120, 120, 220, 80]
    col_x = [20]
    for w in col_w[:-1]:
        col_x.append(col_x[-1] + w)

    rows = [
        ("@State", "视图私有", "视图拥有", "简单状态(计数器、开关)", "否"),
        ("@Binding", "父子通信", "无(引用)", "子视图修改父状态", "否"),
        ("@StateObject", "视图+ViewModel", "视图拥有", "ViewModel 创建入口", "否"),
        ("@ObservedObject", "跨视图", "外部传入", "传递已有 ViewModel", "否"),
        ("@EnvironmentObject", "全局共享", "祖先注入", "App 级别全局状态", "否"),
        ("@AppStorage", "UserDefaults", "系统管理", "用户偏好持久化", "是"),
    ]

    ROW_H = 40
    HDR_H = 36
    y = 50

    # 表头
    rrect(d, 18, y, W - 18, y + HDR_H, 8, (60, 100, 180))
    for hdr, x, w in zip(headers, col_x, col_w):
        text_c(d, x + w // 2, y + HDR_H // 2, hdr, font(13, True), (255, 255, 255))
    y += HDR_H

    # 数据行
    stripe = [(245, 248, 255), (255, 255, 255)]
    for ri, row in enumerate(rows):
        bg = stripe[ri % 2]
        rrect(d, 18, y, W - 18, y + ROW_H, 0, bg, (220, 220, 220), 1)
        for ci, (cell, x, w) in enumerate(zip(row, col_x, col_w)):
            fc = (60, 100, 180) if ci == 0 else (50, 50, 50)
            fn = font(12, ci == 0) if ci == 0 else font(11)
            text_c(d, x + w // 2, y + ROW_H // 2, cell, fn, fc)
        y += ROW_H

    d.text((20, y + 8), "* 所有属性包装器均为 SwiftUI 内置，无需第三方依赖", font=TINY, fill=(150, 150, 150))

    img.save(os.path.join(OUTPUT_DIR, "fig4_state_comparison.png"), "PNG")
    print("✅ fig4_state_comparison.png")


gen_arch_diagram()
gen_mvvm_diagram()
gen_learning_path()
gen_state_comparison()
print("\n所有图片生成完成！")
