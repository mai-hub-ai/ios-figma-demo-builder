# 技术架构文档 - 飞猪酒店套餐高保真原型

## 项目信息

| 项目 | 内容 |
|------|------|
| 项目名称 | fliggy-hotel-prototype |
| 负责人 | 樊雅璇 (埋铭) |
| 所属部门 | 飞猪 - 大住宿 - 住宿产品 NEXT-用户产品 - 导购产品 |
| 文档版本 | v1.1 |
| 创建时间 | 2026-03-24 |
| GitHub 仓库 | (待创建) |

---

## 0. 环境依赖与前置配置

### 0.1 必需依赖

| 依赖 | 最低版本 | 当前状态 | 安装/配置方式 |
|------|----------|----------|---------------|
| Node.js | 18+ | v22.22.1 已安装 | - |
| npm | 10+ | v10.9.4 已安装 | - |
| Git | 2.30+ | v2.39.5 已安装 | - |
| GitHub CLI (gh) | 2.0+ | v2.88.1 已安装 | **需登录：`gh auth login`** |
| Swift | 6.0+ | v6.0.3 已安装 | - |
| Homebrew | - | v5.1.0 已安装 | - |
| **Xcode** | **15+** | **未安装** | **App Store 下载（约 12GB）** |

### 0.2 用户需完成的配置清单

装好 Xcode 后依次执行：

```bash
# 1. 将 Xcode 设为活跃开发工具（装好 Xcode 后必须执行）
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer

# 2. 同意 Xcode 许可协议
sudo xcodebuild -license accept

# 3. 安装 iOS Simulator runtime（首次打开 Xcode 时会引导，也可命令行装）
xcodebuild -downloadPlatform iOS

# 4. GitHub CLI 登录
gh auth login
#    选 GitHub.com → HTTPS → 浏览器授权

# 5. Git 全局配置
git config --global user.name "你的名字"
git config --global user.email "你的邮箱"
```

### 0.3 Xcode 安装后自动可用的工具

| 工具 | 用途 |
|------|------|
| `xcrun simctl` | iOS 模拟器控制（启动/截图/安装应用） |
| `xcodebuild` | 构建 iOS 项目 |
| `swift build` | 编译 Swift 代码 |
| Instruments | 性能分析 |
| Simulator.app | iOS 模拟器 UI |

---

## 1. 系统架构

### 1.1 整体架构图

```
┌─────────────────────────────────────────────┐
│           Xcode → iOS Simulator              │
│              (iPhone 15 Pro)                 │
│  ┌───────────────────────────────────────┐   │
│  │     Swift App (WKWebView 壳)          │   │
│  │     加载 http://localhost:5173        │   │
│  └──────────────────┬────────────────────┘   │
└─────────────────────┼────────────────────────┘
                      │
┌─────────────────────▼────────────────────────┐
│               Vite Dev Server                 │
│              (HMR + Hot Reload)               │
└─────────────────────┬────────────────────────┘
                      │
┌─────────────────────▼────────────────────────┐
│               React 18 SPA                    │
│  ┌──────────┐  ┌──────────┐  ┌───────────┐   │
│  │ Pages    │→ │Containers│→ │Components │   │
│  └────┬─────┘  └────┬─────┘  └───────────┘   │
│       │              │                        │
│  ┌────▼─────┐  ┌────▼─────┐                  │
│  │  Router  │  │  Zustand │                   │
│  │(RR v7)   │  │  Store   │                   │
│  └──────────┘  └────┬─────┘                   │
│                     │                         │
│              ┌──────▼──────┐                  │
│              │   Axios     │                  │
│              │  (API 层)   │                  │
│              └──────┬──────┘                  │
│                     │                         │
│              ┌──────▼──────┐                  │
│              │     MSW     │                  │
│              │ (Mock 拦截) │                  │
│              └─────────────┘                  │
└───────────────────────────────────────────────┘
```

### 1.2 页面路由设计

| 路由路径 | 页面名称 | 说明 | 优先级 |
|----------|----------|------|--------|
| `/packages` | 套餐列表页 | 首页，搜索+筛选+列表 | P0 |
| `/packages/:id` | 套餐详情页 | 图片轮播+权益+价格 | P0 |
| `/calendar/:packageId` | 日历选择页 | 日期选择+房态+价格日历 | P0 |
| `/order/confirm` | 订单确认页 | 入住人信息+价格明细 | P0 |
| `/order/result/:orderId` | 支付结果页 | 支付成功/失败+订单摘要 | P1 |

### 1.3 用户流程

```
套餐列表 → 点击卡片 → 套餐详情 → 选择日期 → 日历选择
                                                 ↓
                         支付结果 ← 提交订单 ← 订单确认
```

---

## 2. 数据模型

### 2.1 核心实体

#### HotelPackage (酒店套餐)

| 字段 | 类型 | 说明 |
|------|------|------|
| id | string (UUID) | 套餐唯一标识 |
| hotelName | string | 酒店名称 |
| hotelStar | number | 酒店星级 (4-5) |
| title | string | 套餐标题 |
| coverImage | string | 封面图 URL |
| roomType | RoomType | 房型信息 |
| benefits | PackageBenefit[] | 套餐权益列表 |
| priceInfo | PriceInfo | 价格信息 |
| nights | number | 住宿晚数 |
| includeBreakfast | boolean | 是否含早 |
| status | PackageStatus | 可售状态 |
| salesCount | number | 已售数量 |
| rating | number | 用户评分 |

#### Order (订单)

| 字段 | 类型 | 说明 |
|------|------|------|
| id | string (UUID) | 订单唯一标识 |
| orderNo | string | 订单号 (16位数字) |
| packageId | string | 关联套餐 ID |
| checkInDate | string | 入住日期 |
| checkOutDate | string | 离店日期 |
| guestInfo | GuestInfo | 入住人信息 |
| totalPrice | number | 订单总价 |
| status | OrderStatus | 订单状态 |

> 完整类型定义见 `src/types/hotel.ts`

---

## 3. API 接口设计

### 3.1 接口清单

| 方法 | 路径 | 说明 | 请求参数 | 响应 |
|------|------|------|----------|------|
| GET | `/api/packages` | 套餐列表 | page, pageSize, keyword, sortBy | PaginatedData\<HotelPackage\> |
| GET | `/api/packages/:id` | 套餐详情 | - | HotelPackage |
| GET | `/api/packages/:id/availability` | 日期可用性 | month | DateAvailability[] |
| POST | `/api/orders` | 创建订单 | packageId, checkInDate, guestInfo... | Order |
| GET | `/api/orders/:id` | 订单详情 | - | Order |

### 3.2 统一响应格式

```typescript
interface ApiResponse<T> {
  code: number;      // 200=成功, 400=参数错误, 500=服务错误
  message: string;   // 响应说明
  data: T;           // 业务数据
}
```

### 3.3 分页格式

```typescript
interface PaginatedData<T> {
  list: T[];
  total: number;
  page: number;
  pageSize: number;
}
```

---

## 4. 状态管理设计

使用 Zustand 分 Store 管理：

| Store | 文件 | 职责 |
|-------|------|------|
| usePackageListStore | hotelStore.ts | 套餐列表数据、分页、筛选 |
| usePackageDetailStore | hotelStore.ts | 当前套餐详情、日历可用性 |
| useOrderStore | hotelStore.ts | 订单创建、当前订单状态 |

---

## 5. 目录结构

```
fliggy-hotel-prototype/               # GitHub 仓库根目录
├── web/                              # React Web 工程
│   ├── index.html                    # HTML 入口 (iOS viewport 已配置)
│   ├── vite.config.ts                # Vite 配置 (host: 0.0.0.0)
│   ├── tailwind.config.js            # Tailwind 飞猪设计系统
│   ├── tsconfig.app.json             # TS 配置 (含 @/ alias)
│   ├── playwright.config.ts          # E2E 测试配置 (iPhone 15 Pro)
│   ├── vitest.config.ts              # 单元测试配置
│   ├── src/
│   │   ├── main.tsx                  # 入口 (含 MSW 初始化)
│   │   ├── App.tsx                   # 路由配置
│   │   ├── index.css                 # Tailwind + 全局样式
│   │   ├── types/hotel.ts            # 完整类型定义
│   │   ├── store/hotelStore.ts       # Zustand Stores
│   │   ├── services/
│   │   │   ├── api.ts                # Axios API 封装
│   │   │   └── mockData.ts           # Faker 数据工厂 (zh_CN)
│   │   ├── mocks/
│   │   │   ├── handlers.ts           # MSW 请求处理器
│   │   │   └── browser.ts            # MSW 浏览器注册
│   │   ├── components/
│   │   │   ├── ui/                   # 原子组件 (待开发)
│   │   │   └── business/             # 业务组件 (待开发)
│   │   ├── containers/               # 容器层 (待开发)
│   │   ├── pages/                    # 页面层 (待开发)
│   │   ├── hooks/                    # 自定义 Hooks
│   │   └── utils/format.ts           # 格式化工具函数
│   └── tests/
│       ├── unit/setup.ts             # 单元测试配置
│       └── e2e/navigation.spec.ts    # E2E 基础导航测试
│
├── ios/                              # Swift WKWebView 壳工程 (待搭建)
│   ├── FliggyShell.xcodeproj
│   └── FliggyShell/
│       ├── WebViewController.swift   # WKWebView 主控制器
│       ├── Info.plist
│       └── Assets.xcassets
│
├── specs/                            # 技术规范文档
│   ├── CONSTITUTION.md               # 技术宪法
│   └── ARCHITECTURE.md               # 本文档
│
├── .github/
│   └── workflows/
│       └── ci.yml                    # GitHub Actions CI
│
├── .gitignore
└── README.md
```

---

## 6. iOS 模拟器方案

### 6.1 方案：Swift WKWebView 壳工程

采用原生 iOS 项目包裹 Web 内容，而非在模拟器 Safari 中手动输入 URL。

**优势：**
- 全屏沉浸式体验，无 Safari 地址栏/工具栏
- safe area、状态栏行为与真机一致
- 贴近飞猪 App 内 H5 的真实运行环境（native 壳 + webview）
- Xcode 直接选设备跑模拟器，一键 Cmd+R 运行

**架构：**

```
┌─────────────────────────────────────┐
│      Xcode → iOS Simulator          │
│         (iPhone 15 Pro)             │
│  ┌───────────────────────────────┐  │
│  │    Swift App (WKWebView 壳)   │  │
│  │                               │  │
│  │   加载 http://localhost:5173  │  │
│  │                               │  │
│  │   ┌───────────────────────┐   │  │
│  │   │   React 18 SPA        │   │  │
│  │   │   (Vite Dev Server)   │   │  │
│  │   └───────────────────────┘   │  │
│  └───────────────────────────────┘  │
└─────────────────────────────────────┘
```

**壳工程技术细节：**
- 语言：Swift 5.9+
- 最低部署版本：iOS 17.0
- Target 设备：iPhone 15 Pro
- 核心组件：`WKWebView` + `WKWebViewConfiguration`
- 全屏 webview，隐藏状态栏可选
- 支持 JavaScript 与 native 通信（预留）
- 支持 Safari Web Inspector 调试

**开发流程：**

```
终端 1:  cd web && npm run dev              ← Vite 开发服务器
终端 2:  Xcode 打开 ios/ 工程 → Cmd+R      ← 壳工程跑模拟器
         Vite HMR → WebView 实时热更新      ← 改代码即刷新
```

### 6.2 Web 端已做的移动端适配

- `viewport-fit=cover` + safe area CSS 变量
- `apple-mobile-web-app-capable` PWA 支持
- `user-scalable=no` 禁止缩放
- `-webkit-overflow-scrolling: touch` 惯性滚动
- `max-width: 430px` iPhone 15 Pro 宽度适配
- `-webkit-tap-highlight-color: transparent` 去除触摸高亮

---

## 7. GitHub 工作流

### 7.1 仓库结构

采用 monorepo 方式，Web 工程和 iOS 壳工程放在同一个 GitHub 仓库：

```
fliggy-hotel-prototype/    (仓库根)
├── web/                   React Web 工程
├── ios/                   Swift WKWebView 壳工程
├── specs/                 技术规范文档
├── .github/workflows/     CI 流水线
└── README.md
```

### 7.2 Git 分支策略

| 分支 | 用途 | 保护规则 |
|------|------|----------|
| `main` | 稳定版本，可随时演示 | 禁止直推，必须 PR |
| `dev` | 日常开发集成 | 默认开发分支 |
| `feature/*` | 功能分支 | 如 `feature/page-package-list` |
| `fix/*` | 修复分支 | 如 `fix/calendar-scroll` |

### 7.3 提交规范 (Conventional Commits)

```
feat(page): 完成套餐列表页开发
fix(mock): 修复日历数据生成逻辑
docs(spec): 更新 Architecture 文档
chore(deps): 升级 antd-mobile 版本
```

### 7.4 GitHub Actions CI

```yaml
# .github/workflows/ci.yml
name: CI
on: [push, pull_request]
jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: 22 }
      - run: cd web && npm ci
      - run: cd web && npm run typecheck
      - run: cd web && npm run lint
      - run: cd web && npm run build
      - run: cd web && npm run test
```

### 7.5 首次提交流程

```bash
cd fliggy-hotel-prototype
git init
git add .
git commit -m "feat: 初始化项目骨架"

# 创建 GitHub 远程仓库并推送
gh repo create fliggy-hotel-prototype --private --source=. --push
```

---

## 8. 质量保障

| 检查项 | 命令 | 通过标准 |
|--------|------|----------|
| TypeScript | `npm run typecheck` | 0 errors |
| Production Build | `npm run build` | 构建成功 |
| ESLint | `npm run lint` | 0 errors |
| Unit Test | `npm run test` | All passed |
| E2E Test | `npm run test:e2e` | All passed |
