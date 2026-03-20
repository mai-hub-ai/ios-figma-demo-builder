# HotelBookingDemo

一个现代化的iOS酒店预订演示应用，采用MVVM+Coordinator架构模式。

## 项目结构

```
HotelBookingDemo/
├── Sources/
│   ├── Core/           # 核心架构组件
│   ├── Features/       # 功能模块
│   ├── UI/            # 界面组件
│   ├── Data/          # 数据层
│   └── Utils/         # 工具类
├── Tests/
├── Resources/
└── SupportingFiles/
```

## 技术栈

- **架构模式**: MVVM + Coordinator
- **最低支持版本**: iOS 12.0+
- **开发语言**: Swift 5.5+
- **包管理**: Swift Package Manager
- **代码规范**: SwiftLint

## 开发环境要求

- Xcode 13.0+
- iOS 12.0+ 模拟器或真机
- Swift 5.5+

## 快速开始

1. 克隆项目
2. 打开 `HotelBookingDemo.xcodeproj`
3. 选择目标设备并运行

## 代码质量

- 遵循 SwiftLint 代码规范
- 目标单元测试覆盖率 80%+
- 持续集成自动检查

## 团队协作

本项目采用多Agent协作开发模式：
- **Builder**: 项目架构师
- **Hunter**: 核心功能工程师  
- **Designer**: UI/UX工程师
- **Guardian**: 质量保证工程师
- **Deployer**: DevOps工程师