# 🤝 贡献指南

感谢您对iOS Figma Demo Builder项目的关注！我们欢迎各种形式的贡献，无论大小。

## 📋 贡献方式

### 💻 代码贡献
- 实现新功能
- 修复bug
- 优化现有代码
- 改进性能
- 增强测试覆盖

### 📝 文档贡献
- 完善现有文档
- 翻译文档
- 编写教程和指南
- 创建示例代码

### 🎨 设计贡献
- UI/UX改进建议
- 设计系统优化
- 图标和插图创作

### 🐛 问题反馈
- 报告bug
- 提出功能建议
- 分享使用体验

## 🚀 快速开始

### 1. Fork项目
点击GitHub页面右上角的"Fork"按钮创建项目副本。

### 2. 克隆到本地
```bash
git clone https://github.com/yourusername/ios-figma-demo-builder.git
cd ios-figma-demo-builder
```

### 3. 创建功能分支
```bash
git checkout -b feature/your-amazing-feature
```

### 4. 开发和测试
```bash
# 运行测试确保没有破坏现有功能
xcodebuild test -scheme HotelBookingDemo

# 运行SwiftLint检查代码质量
swiftlint
```

### 5. 提交更改
```bash
git add .
git commit -m "feat: add amazing feature"
git push origin feature/your-amazing-feature
```

### 6. 创建Pull Request
在GitHub上创建PR，详细描述您的更改。

## 📝 代码规范

### Git提交规范
我们使用[Conventional Commits](https://www.conventionalcommits.org/)规范：

```
<type>(<scope>): <subject>

<body>

<footer>
```

**类型(Type)**:
- `feat`: 新功能
- `fix`: Bug修复
- `docs`: 文档更新
- `style`: 代码格式调整
- `refactor`: 代码重构
- `perf`: 性能优化
- `test`: 测试相关
- `chore`: 构建过程或辅助工具变动

**示例**:
```bash
feat(search): 添加智能酒店搜索功能

- 实现基于关键词的酒店搜索
- 支持地理位置筛选
- 添加搜索历史记录功能

Closes #123
```

### Swift编码规范
- 遵循[Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- 使用SwiftLint进行代码质量检查
- 保持一致的命名约定
- 编写清晰的注释和文档

### 项目特定规范
```swift
// ✅ 好的命名
class HotelPackageViewController: UIViewController
struct UserRequirements
protocol HotelRepositoryProtocol

// ✅ 清晰的函数签名
func filterAndRankPackages(by requirements: UserRequirements) -> [HotelPackage]

// ✅ 适当的注释
/// 智能推荐引擎
/// 根据用户需求推荐最适合的酒店套餐
class RecommendationEngine {
    // 实现细节
}
```

## 🧪 测试要求

### 测试覆盖标准
- 新功能必须包含相应的单元测试
- 业务逻辑测试覆盖率不低于85%
- UI组件需要集成测试
- 关键路径必须有端到端测试

### 测试编写指南
```swift
// ✅ 完整的测试结构
class HotelSearchUseCaseTests: XCTestCase {
    
    var sut: HotelSearchUseCase!
    var mockRepository: MockHotelRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockHotelRepository()
        sut = HotelSearchUseCase(repository: mockRepository)
    }
    
    func testSearchWithValidParameters_returnsResults() {
        // Given
        let searchParams = SearchParameters(keyword: "北京", dates: ...)
        
        // When
        let result = sut.searchHotels(with: searchParams)
        
        // Then
        XCTAssertNotNil(result)
        XCTAssertTrue(!result.isEmpty)
    }
}
```

## 📊 Pull Request流程

### PR检查清单
在提交PR前，请确保：

- [ ] 代码通过所有测试
- [ ] SwiftLint检查无错误
- [ ] 添加了必要的测试用例
- [ ] 更新了相关文档
- [ ] 遵循了编码规范
- [ ] PR描述清晰完整

### PR模板
```markdown
## 描述
简要描述这次变更的内容和目的

## 变更类型
- [ ] 功能新增
- [ ] 缺陷修复  
- [ ] 性能优化
- [ ] 代码重构
- [ ] 文档更新

## 影响范围
- 影响的模块和功能
- 可能的风险点

## 测试情况
- [ ] 单元测试通过
- [ ] 集成测试通过
- [ ] 手动测试验证

## 相关Issue
Closes #[Issue编号]
```

## 🎯 开发环境设置

### 必需工具
- Xcode 13.0+
- Swift 5.5+
- SwiftLint
- Git

### 推荐工具
- SourceTree (Git GUI客户端)
- Charles Proxy (网络调试)
- Simulator Status Magic (截图美化)

### 环境配置
```bash
# 安装SwiftLint
brew install swiftlint

# 克隆项目
git clone https://github.com/yourusername/ios-figma-demo-builder.git
cd ios-figma-demo-builder

# 运行初始设置脚本
./scripts/setup.sh
```

## 🏗️ 项目架构理解

### 核心模块
1. **Core**: 基础架构和协议定义
2. **Features**: 业务功能实现
3. **UI**: 用户界面组件
4. **Data**: 数据访问层
5. **Utils**: 通用工具类

### 开发流程
```
需求分析 → 技术设计 → 编码实现 → 测试验证 → 代码审查 → 合并发布
```

## 🆘 需要帮助？

### 获取支持
- 查看[问题列表](https://github.com/yourusername/ios-figma-demo-builder/issues)
- 参与[讨论区](https://github.com/yourusername/ios-figma-demo-builder/discussions)
- 联系项目维护者

### 常见问题
**Q: 如何运行项目？**
A: 确保安装了Xcode 13+，打开HotelBookingDemo.xcodeproj即可运行。

**Q: 测试失败怎么办？**
A: 检查是否安装了所有依赖，运行`swiftlint`检查代码质量问题。

**Q: 如何贡献文档？**
A: 直接编辑对应的Markdown文件，提交PR即可。

## 🎉 社区准则

### 行为准则
- 保持友善和尊重
- 提供建设性的反馈
- 包容不同的观点
- 关注解决问题而非指责

### 认可贡献
我们会通过以下方式认可贡献者：
- GitHub贡献者列表
- 项目README鸣谢
- 重大贡献者的特殊标识

## 📞 联系方式

- **Issues**: [提交问题](https://github.com/yourusername/ios-figma-demo-builder/issues)
- **Discussions**: [参与讨论](https://github.com/yourusername/ios-figma-demo-builder/discussions)
- **Email**: your-email@example.com

---

再次感谢您的贡献！让我们一起打造更好的项目！🌟