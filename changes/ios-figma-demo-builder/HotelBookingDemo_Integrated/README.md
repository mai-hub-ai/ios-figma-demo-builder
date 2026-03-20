# HotelBookingDemo 🏨

[![Build Status](https://github.com/username/HotelBookingDemo/workflows/CI/badge.svg)](https://github.com/username/HotelBookingDemo/actions)
[![License](https://img.shields.io/github/license/username/HotelBookingDemo)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-iOS-blue)](https://developer.apple.com/ios/)
[![Swift](https://img.shields.io/badge/swift-5.5%2B-orange)](https://swift.org)

一个现代化的iOS酒店预订演示应用，采用MVVM+Coordinator架构模式，支持Figma设计导入和智能推荐功能。

## 🌟 特性

- 🏨 **智能酒店推荐** - 基于用户偏好和历史行为的个性化推荐
- 🎨 **Figma设计支持** - 直接导入Figma CSS样式自动生成UI组件
- 📱 **响应式设计** - 完美适配iPhone和iPad各种屏幕尺寸
- 🔍 **高级搜索** - 多维度筛选和智能搜索功能
- 📊 **数据分析** - 实时价格趋势和酒店对比分析
- 🌙 **深色模式** - 原生深色主题支持

## 🚀 快速开始

### 环境要求
- Xcode 13.0+
- iOS 12.0+
- Swift 5.5+

### 安装步骤

1. 克隆项目
```bash
git clone https://github.com/username/HotelBookingDemo.git
cd HotelBookingDemo
```

2. 打开项目
```bash
open HotelBookingDemo.xcodeproj
```

3. 构建和运行
- 选择目标设备
- 点击运行按钮或按 `Cmd+R`

### 使用Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/username/HotelBookingDemo.git", from: "1.0.0")
]
```

## 🏗️ 架构设计

### 核心架构模式
```
MVVM + Coordinator
├── Core/           # 核心架构组件
├── Data/           # 数据层和业务逻辑
├── UI/             # 界面组件和设计系统
├── Features/       # 功能模块
└── Utils/          # 工具类和辅助函数
```

### 主要组件

**数据层 (Data)**
- `HotelPackage` - 酒店数据模型
- `UserRequirements` - 用户需求模型
- `HotelRepository` - 数据访问层
- `RecommendationEngine` - 推荐算法引擎

**界面层 (UI)**
- `DesignTokens` - 设计系统令牌
- `ComponentFactory` - 组件工厂
- `FigmaStyleConverter` - Figma样式转换器
- `AutoLayoutHelper` - 自动布局助手

**核心层 (Core)**
- `BaseCoordinator` - 协调器基类
- `BaseViewModel` - 视图模型基类
- `DIContainer` - 依赖注入容器

## 🎨 Figma集成

### CSS导入流程
1. 从Figma导出CSS样式文件
2. 使用内置转换器处理CSS
3. 自动生成对应的UIKit组件
4. 应用到项目中

### 支持的CSS属性
- 颜色 (background-color, color)
- 字体 (font-family, font-size, font-weight)
- 布局 (margin, padding, width, height)
- 边框 (border, border-radius)
- 阴影 (box-shadow)

## 🧪 测试

### 运行测试
```bash
# 运行所有测试
swift test

# 运行特定测试
swift test --filter "TestClass"

# 生成覆盖率报告
./Scripts/test.sh
```

### 测试覆盖率
- 目标覆盖率: ≥ 80%
- 单元测试: Core和Data层
- UI测试: 界面交互测试
- 集成测试: 模块间协作测试

## 📖 文档

### 开发文档
- [架构设计文档](Documentation/ARCHITECTURE_NOTES.md)
- [API参考文档](Documentation/API_REFERENCE.md)
- [设计系统指南](Documentation/DESIGN_SYSTEM.md)

### 贡献指南
- [贡献指南](CONTRIBUTING.md)
- [代码规范](Documentation/CODING_STANDARDS.md)
- [发布流程](Documentation/RELEASE_PROCESS.md)

## 🤝 贡献

欢迎任何形式的贡献！请查看我们的[贡献指南](CONTRIBUTING.md)了解详情。

### 贡献者名单
<!-- ALL-CONTRIBUTORS-LIST:START -->
<!-- ALL-CONTRIBUTORS-LIST:END -->

## 📄 许可证

本项目采用MIT许可证。详情请查看[LICENSE](LICENSE)文件。

## 📞 联系我们

- **问题报告**: [GitHub Issues](../../issues)
- **功能建议**: [GitHub Discussions](../../discussions)
- **邮件联系**: team@project.com
- **Twitter**: [@HotelBookingDemo](https://twitter.com/HotelBookingDemo)

---

<p align="center">
  Made with ❤️ by the HotelBookingDemo Team
</p>