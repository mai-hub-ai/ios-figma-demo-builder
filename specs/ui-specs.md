# UI设计规范文档

## UI规范结构

### 1. 设计原则 (Design Principles)
**商业转化原则**: 界面设计以促进预订转化为核心目标
**信息优先原则**: 重要信息（价格、日期、位置）突出显示
**激励驱动原则**: 通过促销、折扣等元素刺激用户行动
**信任建立原则**: 通过品牌标识、用户评价等建立用户信任

### 2. 色彩系统 (Color System) - 酒店预订专用
**商业转化色彩**:
- Primary CTA: `#FFD700` (金色，用于主要行动按钮)
- Secondary CTA: `#FF4500` (橙红色，用于促销提醒)
- Brand Primary: `#1A73E8` (商务蓝，品牌主色)
- Success: `#34A853` (绿色，确认和成功状态)

**信息层级色彩**:
- High Priority: `#FF4500` (红色，紧急促销、限时优惠)
- Medium Priority: `#FFD700` (黄色，重要行动、折扣信息)
- Low Priority: `#1A73E8` (蓝色，常规信息、链接)

**状态色彩**:
- Available: `#34A853` (绿色，可预订)
- Limited: `#FBBC05` (黄色，限量供应)
- Sold Out: `#EA4335` (红色，已售罄)
- Selected: `#4285F4` (蓝色，已选中)

**背景和文本**:
- Page Background: `#F8F9FA` (浅灰白)
- Card Background: `#FFFFFF` (纯白)
- Text Primary: `#202124` (深灰黑)
- Text Secondary: `#5F6368` (中灰)
- Text Hint: `#9AA0A6` (浅灰)

### 3. 字体系统 (Typography System) - 商业导向
**营销标题层级**:
- Hero Title: 28pt, Heavy (首页大标题，突出促销)
- Section Title: 22pt, Bold (板块标题)
- Card Title: 18pt, Semibold (卡片标题)
- Price Display: 20pt, Heavy (价格数字，特别加粗)

**信息文本层级**:
- Primary Text: 17pt, Regular (主要信息)
- Secondary Text: 15pt, Regular (次要信息)
- Detail Text: 13pt, Regular (详细信息)
- Caption: 11pt, Regular (说明文字)

**行动号召文本**:
- CTA Button: 18pt, Heavy (行动按钮文字)
- Link Text: 15pt, Medium (链接文字)
- Tag Text: 12pt, Medium (标签文字)

**特殊用途**:
- Discount Badge: 14pt, Bold (折扣标签)
- Time Sensitive: 13pt, Heavy (时效性信息)
- User Rating: 14pt, Medium (用户评分)

### 4. 间距系统 (Spacing System) - 酒店预订优化
**基础间距单位**: 4pt
**搜索区域间距**:
- xs: 4pt (元素内间距)
- s: 8pt (按钮内边距)
- m: 16pt (组件间间距)
- l: 24pt (行间间距)
- xl: 32pt (区块间距)

**卡片间距**:
- cardPadding: 16pt (卡片内边距)
- cardMargin: 12pt (卡片外边距)
- cardSpacing: 8pt (卡片元素间距)

**促销横幅间距**:
- bannerPadding: 16pt (横幅内边距)
- bannerMargin: 8pt (横幅间距)
- bannerCornerRadius: 8pt (圆角半径)

### 5. 酒店预订专用组件规范 (Hotel Booking Components)

#### 搜索区域组件 (Search Area Components)
**目的地输入框**:
- 背景色: Surface (`#FFFFFF`)
- 边框: 1pt `#DADCE0`
- 圆角: 8pt
- 内边距: 水平16pt, 垂直12pt
- 清除按钮: 右侧灰色叉号图标
- 占位符: "城市/区域/酒店名" (浅灰色)

**日期选择器**:
- 背景色: Surface (`#FFFFFF`)
- 边框: 1pt `#DADCE0` (左侧) 
- 圆角: 8pt (仅左侧)
- 内边距: 水平12pt, 垂直 10pt
- 日期格式: "MM月dd日" (如"12月29日")
- 状态指示: 入住/离店标签区分

**入住人数选择器**:
- 背景色: Surface (`#FFFFFF`)
- 边框: 1pt `#DADCE0` (左侧)
- 圆角: 8pt (仅左侧)
- 内边距: 水平12pt, 垂直 10pt
- 格式: "X间房 Y成人 Z儿童"

#### 筛选和排序组件 (Filter & Sort Components)
**筛选按钮**:
- 背景色: `#F1F3F4`
- 文字色: `#5F6368`
- 圆角: 20pt
- 内边距: 水平16pt, 垂直 8pt
- 图标: 右侧向下箭头
- 激活状态: 背景色变为品牌蓝 `#1A73E8`

**价格/评分排序**:
- 背景色: `#F1F3F4`
- 文字色: `#5F6368`
- 圆角: 20pt
- 内边距: 水平16pt, 垂直 8pt
- 图标: 右侧排序图标

#### 行动号召按钮 (Call-to-Action Buttons)
**主要搜索按钮**:
- 背景色: `#FFD700` (金色)
- 文字色: `#202124` (深色)
- 圆角: 8pt
- 内边距: 水平24pt, 垂直 16pt
- 字体: 18pt Heavy
- 阴影: Y=2pt, Blur=4pt, Opacity=20%
- 点击效果: 背色轻微变暗

**促销按钮**:
- 背景色: `#FF4500` (橙红)
- 文字色: `#FFFFFF` (白色)
- 圆角: 6pt
- 内边距: 水平12pt, 垂直 6pt
- 字体: 14pt Bold
- 最小尺寸: 44pt × 30pt

#### 酒店卡片组件 (Hotel Card Components)
**基础卡片**:
- 背景色: Surface (`#FFFFFF`)
- 圆角: 12pt
- 阴影: Y=2pt, Blur=8pt, Opacity=10%
- 内边距: 16pt
- 外边距: 12pt (垂直)

**价格展示**:
- 主价格: 24pt Heavy, `#EA4335` (红色)
- 副价格: 14pt Regular, `#5F6368` (灰色)
- 优惠标签: 12pt Bold, 白色文字, 红色背景

**评分展示**:
- 评分数字: 16pt Heavy, `#202124`
- 星级图标: 16pt, `#FBBC05` (黄色)
- 评价数量: 13pt Regular, `#5F6368`

#### 促销横幅组件 (Promotion Banner Components)
**机酒联订横幅**:
- 背景色: `#EA4335` (红色渐变)
- 文字色: `#FFFFFF`
- 圆角: 8pt
- 内边距: 16pt
- 图标: 飞机+酒店组合图标
- 动画: 轻微脉冲效果吸引注意

**红包抵扣横幅**:
- 背景色: `#FFD700` (黄色渐变)  
- 文字色: `#202124`
- 圆角: 8pt
- 内边距: 16pt
- 图标: 红包图标
- 时效提示: "限时抢购"标签

### 6. 布局规范 (Layout Guidelines)

#### 响应式断点
- Compact (iPhone): < 600pt
- Regular (iPad): ≥ 600pt

#### 安全区域
- 顶部安全区: 状态栏高度
- 底部安全区: Home Indicator高度
- 水平边距: 16pt (手机) / 24pt (平板)

#### 网格系统
- 列数: 4列 (手机) / 8列 (平板)
- 列间距: 16pt
- 外边距: 16pt

### 7. 交互规范 (Interaction Guidelines)

#### 触控目标
- 最小触控尺寸: 44pt × 44pt
- 推荐触控尺寸: 48pt × 48pt

#### 动效规范
**基础动效**:
- 持续时间: 0.25s
- 缓动函数: easeInOut
- 触发时机: 用户操作反馈

**页面转场**:
- 导航转场: slide (水平滑入)
- 模态弹窗: coverVertical (从底部弹出)

#### 反馈机制
**加载状态**:
- 加载指示器: ActivityIndicator
- 骨架屏: 浅灰色占位块
- 进度条: 线性进度指示

**错误提示**:
- Toast提示: 底部弹出，3秒消失
- Alert弹窗: 重要错误确认
- 行内错误: 红色文字+图标

### 8. 可访问性规范 (Accessibility Guidelines)

#### 文字可读性
- 最小字体: 11pt
- 对比度要求: 文字与背景≥4.5:1
- 行高比例: 1.2-1.5倍

#### VoiceOver支持
- 所有交互元素必须有accessibilityLabel
- 图片必须有accessibilityLabel
- 自定义控件需要实现accessibilityTrait

#### 动态字体
- 支持系统字体大小调整
- 文字容器需要自适应高度
- 布局不能因字体变大而破损

---

## 设计令牌 (Design Tokens)

```swift
// Colors.swift
enum Colors {
    static let primary = UIColor(hex: "#007AFF")
    static let secondary = UIColor(hex: "#34C759") 
    static let background = UIColor(hex: "#F2F2F7")
    static let surface = UIColor.white
    
    // States
    static let success = UIColor(hex: "#34C759")
    static let warning = UIColor(hex: "#FFCC00")
    static let error = UIColor(hex: "#FF3B30")
}

// Typography.swift  
enum Typography {
    static let largeTitle = UIFont.systemFont(ofSize: 34, weight: .bold)
    static let title1 = UIFont.systemFont(ofSize: 28, weight: .semibold)
    static let body = UIFont.systemFont(ofSize: 17, weight: .regular)
}

// Spacing.swift
enum Spacing {
    static let xs: CGFloat = 4
    static let s: CGFloat = 8
    static let m: CGFloat = 16
    static let l: CGFloat = 24
}
```