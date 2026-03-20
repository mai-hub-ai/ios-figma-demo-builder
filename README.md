# 🏨 iOS Figma Demo Builder - 智能酒店预订演示应用

[![Build Status](https://img.shields.io/github/workflow/status/yourusername/ios-figma-demo-builder/CI?style=flat-square)](https://github.com/yourusername/ios-figma-demo-builder/actions)
[![License](https://img.shields.io/github/license/yourusername/ios-figma-demo-builder?style=flat-square)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-iOS-blue?style=flat-square)](https://developer.apple.com/ios/)
[![Swift](https://img.shields.io/badge/swift-5.5+-orange?style=flat-square)](https://swift.org)
[![Stars](https://img.shields.io/github/stars/yourusername/ios-figma-demo-builder?style=social)](https://github.com/yourusername/ios-figma-demo-builder)

> 一个现代化的iOS酒店预订演示应用程序，展示了MVVM+Coordinator架构与Figma CSS集成能力。通过创新的多Agent协作开发模式，实现了从设计稿到可交互代码的自动化转换。

## 🌟 项目亮点

### 🔧 技术创新
- **Figma CSS自动转换**: 独创的CSS到UIKit自动映射技术
- **智能推荐引擎**: 基于用户需求的酒店套餐智能匹配算法
- **原子化设计系统**: 完整的Design Tokens和组件库体系
- **多Agent协作架构**: 创新的团队开发模式实践

### 🏗️ 架构优势
- **MVVM+Coordinator**: 清晰的关注点分离和导航管理
- **依赖注入**: 基于容器的服务解析实现松耦合
- **协议导向设计**: 灵活且可测试的组件接口
- **模块化结构**: 高内聚低耦合的代码组织

## 📁 项目结构

```
ios-figma-demo-builder/
├── Sources/
│   ├── Core/              # 核心架构层
│   │   ├── Protocols/     # 基础协议定义
│   │   ├── BaseCoordinator.swift  # 协调器基类
│   │   ├── BaseViewModel.swift    # 视图模型基类
│   │   └── DIContainer.swift      # 依赖注入容器
│   ├── Features/          # 业务功能模块
│   │   ├── HotelSearch/   # 酒店搜索功能
│   │   ├── Booking/       # 预订系统
│   │   └── Profile/       # 用户管理
│   ├── UI/               # 用户界面组件
│   │   ├── Components/    # 可复用UI组件
│   │   ├── DesignSystem/  # 设计系统
│   │   ├── Utils/         # UI工具类
│   │   └── ViewControllers/ # 视图控制器
│   ├── Data/             # 数据访问层
│   │   ├── Models/        # 数据模型
│   │   ├── Repositories/  # 数据仓库
│   │   ├── UseCases/      # 业务用例
│   │   └── MockData/      # 模拟数据
│   └── Utils/            # 通用工具类
│       ├── CSSParser/     # Figma CSS解析器
│       └── Helpers/       # 辅助扩展
├── Tests/                # 测试套件
│   ├── UnitTests/        # 单元测试
│   ├── IntegrationTests/ # 集成测试
│   └── UITests/          # UI测试
├── Resources/            # 资源文件
└── SupportingFiles/      # 配置文件
```

## 🚀 快速开始

### 系统要求
- Xcode 13.0 或更高版本
- iOS 12.0+ 部署目标
- Swift 5.5+

### 安装步骤

1. **克隆项目**
```bash
git clone https://github.com/yourusername/ios-figma-demo-builder.git
cd ios-figma-demo-builder
```

2. **打开项目**
```bash
open HotelBookingDemo.xcodeproj
```

3. **构建运行**
- 选择目标设备（模拟器或真机）
- 按 `⌘+R` 构建并运行

### Figma集成配置

启用Figma CSS解析功能：

1. 从Figma导出设计为CSS格式
2. 将CSS文件放置到项目Resources目录
3. CSS解析器将自动处理设计令牌和组件样式

## 🎯 核心功能

### 🏨 智能酒店推荐
```swift
let requirements = UserRequirements(
    destination: "北京",
    checkInDate: Date(),
    checkOutDate: Date().addingTimeInterval(86400 * 3),
    guests: 2,
    rooms: 1,
    preferences: [.luxury, .familyFriendly]
)

let recommendations = try await recommendationEngine.recommendHotels(for: requirements)
```

### 🎨 设计系统
```swift
// 使用Design Tokens
let primaryColor = DesignTokens.Colors.primary
let headlineFont = DesignTokens.Typography.headline

// 创建组件
let button = CustomButton(style: .primary, size: .large)
let card = CardView(style: .elevated)
```

### 🔄 Figma CSS转换
```swift
let cssContent = try String(contentsOfFile: "design.css")
let parsedStyles = CSSParser().parse(cssContent)
let uiComponents = ComponentFactory().createComponents(from: parsedStyles)
```

## 🧪 测试体系

### 运行测试
```bash
# 运行所有测试
xcodebuild test -scheme HotelBookingDemo -destination 'platform=iOS Simulator,name=iPhone 14'

# 运行特定测试套件
swift test --filter ArchitectureTests
swift test --filter UIDesignTests
```

### 质量标准
- **代码覆盖率**: 目标85%+
- **SwiftLint**: 强制执行代码规范
- **持续集成**: 自动化测试和构建
- **代码审查**: 严格的PR审查流程

## 👥 多Agent协作模式

本项目采用创新的多角色分工协作开发模式：

| 角色 | 职责 | 贡献 |
|------|------|------|
| **Builder** | 项目架构师 | 架构设计、模块整合、技术决策 |
| **Hunter** | 数据工程师 | 数据模型、业务逻辑、推荐算法 |
| **Designer** | UI/UX工程师 | 设计系统、组件开发、样式转换 |
| **Guardian** | 质量守护者 | 测试体系、代码质量、安全保障 |
| **Deployer** | DevOps专家 | 部署自动化、CI/CD、运维支持 |

## 📊 技术栈

### 核心技术
- **语言**: Swift 5.5+
- **框架**: UIKit
- **架构**: MVVM + Coordinator
- **设计模式**: 依赖注入、工厂模式、观察者模式

### 开发工具
- **Xcode**: 13.0+
- **SwiftLint**: 代码质量检查
- **GitHub Actions**: CI/CD流水线
- **Figma**: 设计协作平台

## 🤝 贡献指南

我们欢迎任何形式的贡献！

### 贡献流程
1. Fork 项目仓库
2. 创建功能分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m 'Add amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 创建 Pull Request

### 代码规范
- 遵循 [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- 通过 SwiftLint 检查
- 编写相应的单元测试
- 更新相关文档

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解更多详情。

## 🙏 致谢

- 现代iOS架构模式的启发
- Swift和UIKit的强大功能
- Figma团队的设计协作工具
- 开源社区的持续支持

## 📞 联系方式

如有问题或建议，请通过以下方式联系我们：
- 提交 [Issue](https://github.com/yourusername/ios-figma-demo-builder/issues)
- 发送邮件至: your-email@example.com
- 加入我们的 [Discussions](https://github.com/yourusername/ios-figma-demo-builder/discussions)

---

<p align="center">
  <a href="#top">回到顶部</a> | 
  <a href="https://github.com/yourusername/ios-figma-demo-builder/graphs/contributors">贡献者</a> | 
  <a href="https://github.com/yourusername/ios-figma-demo-builder/releases">发布版本</a>
</p>