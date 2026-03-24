# Constitution - 飞猪酒店套餐原型技术宪法

> 本文档为项目不可违反的顶层约束，所有代码提交和技术决策必须符合以下规则。

---

## 1. 核心使命

**唯一目标：产出可在 iOS 模拟器上演示的高保真可交互原型，高效通过阿里内部评审。**

### 不可逾越的底线

| 编号 | 规则 | 说明 |
|------|------|------|
| C-01 | 必须产出可交互 Demo | 非静态图、非截图 |
| C-02 | 必须 1:1 还原 Figma 设计稿 | 像素级对齐 |
| C-03 | 必须支持 iOS Simulator Safari 访问 | `host: 0.0.0.0` 已配置 |
| C-04 | 必须使用 Mock 数据 | 不依赖后端进度 |
| C-05 | 不接受纯 HTML 文件交付 | 必须是工程化项目 |
| C-06 | 不接受低保真线框图 | 必须高保真还原 |

---

## 2. 技术栈锁定（不可变更）

| 领域 | 选型 | 版本 |
|------|------|------|
| 前端框架 | React | 18.x |
| 开发语言 | TypeScript | 5.x |
| 构建工具 | Vite | 8.x |
| 样式方案 | Tailwind CSS | 3.x |
| 状态管理 | Zustand | 5.x |
| 路由 | React Router | 7.x |
| UI 组件库 | Ant Design Mobile | 5.x |
| Mock 服务 | MSW | 2.x |
| 测试 | Playwright + Vitest | - |

**变更流程：** 任何技术栈变更需提交书面申请 → 技术评审 → PoC 验证 → 全员同步。

---

## 3. 分层架构（强制）

```
页面层 (src/pages/)           ← 路由入口，负责布局
    ↓
容器层 (src/containers/)      ← 组合组件，连接 Store
    ↓
业务组件层 (src/components/business/)  ← 领域组件，含业务逻辑
    ↓
UI 原子层 (src/components/ui/)         ← 纯展示，无业务逻辑
```

### 层间依赖规则

- UI 层 **禁止** 导入 Store 或调用 API
- 业务组件层 **禁止** 直接操作路由
- 容器层 **必须** 通过 Props 向下传递数据
- 页面层 **禁止** 包含业务逻辑

---

## 4. 样式规范（强制）

### 4.1 分工原则

- **antd-mobile**: 复杂交互组件（Picker、Calendar、Popup、Dialog、Swiper）
- **Tailwind CSS**: 布局、间距、自定义 UI、文字样式
- **禁止**: 全局 CSS 类名、行内 style（复杂动画除外）

### 4.2 飞猪品牌色

- 主色: `#FF8800` (primary-500)
- 色阶: primary-50 ~ primary-900 (已配置在 tailwind.config.js)
- 功能色: success `#52C41A` / warning `#FAAD14` / error `#F5222D` / info `#1890FF`

### 4.3 字体层级

| Token | 字号 | 行高 | 字重 | Tailwind class |
|-------|------|------|------|----------------|
| H1 | 24px | 32px | 600 | `text-h1` |
| H2 | 20px | 28px | 600 | `text-h2` |
| H3 | 18px | 26px | 600 | `text-h3` |
| Body-L | 16px | 24px | 400 | `text-body-l` |
| Body-M | 14px | 22px | 400 | `text-body-m` |
| Body-S | 12px | 18px | 400 | `text-body-s` |

### 4.4 间距基准 (4px)

`xs:4px` / `sm:8px` / `md:12px` / `lg:16px` / `xl:24px` / `2xl:32px`

### 4.5 圆角

`sm:4px` / `md:8px` / `lg:12px` / `full:9999px`

---

## 5. Mock 数据规范（强制）

- 使用 MSW v2 拦截 `/api/*` 请求
- Mock 数据必须使用 `@faker-js/faker` 中文 locale 生成
- 必须模拟延迟（`await delay(200~500)`）
- 必须覆盖边界情况：空列表、加载中、错误状态
- API 响应统一格式：`{ code: number, message: string, data: T }`

---

## 6. 组件开发规范

### Props 规则
- 必须显式声明所有依赖（Props 传入，禁止组件内部隐式调用 Store）
- 回调函数必须通过 Props 传入
- 必须提供 `className` 可选 prop 用于样式覆盖

### 命名规则
- 组件文件名：PascalCase（如 `PackageCard.tsx`）
- Hook 文件名：camelCase 以 `use` 开头（如 `usePackageList.ts`）
- Store 文件名：camelCase 以 `Store` 结尾（如 `hotelStore.ts`）
- 类型文件名：camelCase（如 `hotel.ts`）

---

## 7. 移动端适配规范

- `#root` 最大宽度 430px，居中显示
- 必须处理 iOS safe area（`env(safe-area-inset-*)`）
- 禁止用户缩放（viewport `user-scalable=no`）
- 使用 `-webkit-overflow-scrolling: touch` 优化滚动
- 触摸反馈使用 `-webkit-tap-highlight-color: transparent`

---

## 8. 质量门禁

在提交代码前，以下检查必须全部通过：

```bash
npm run typecheck   # TypeScript 类型检查
npm run build       # 生产构建
npm run lint        # ESLint 代码规范
npm run test        # Vitest 单元测试
```
