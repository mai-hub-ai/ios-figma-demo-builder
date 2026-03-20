# 🧪 测试策略文档

**项目**: HotelBookingDemo  
**版本**: v1.0  
**最后更新**: 2024-03-20  

## 🎯 测试目标

确保应用在各种使用场景下都能稳定、可靠地运行，提供优秀的用户体验。

## 🏗️ 测试架构

### 测试金字塔模型

```
        ┌─────────────────┐
        │   E2E Tests     │  ← 最少 (5-10%)
        │  (UI自动化测试)  │
        └─────────────────┘
               │
        ┌─────────────────┐
        │ Integration     │  ← 中等 (20-30%)
        │    Tests        │
        └─────────────────┘
               │
        ┌─────────────────┐
        │   Unit Tests    │  ← 最多 (60-75%)
        │ (组件单元测试)   │
        └─────────────────┘
```

## 🔧 测试类型详解

### 1. 单元测试 (Unit Tests)

#### 覆盖范围
- **Models**: 数据模型和结构
- **ViewModels**: 业务逻辑和状态管理
- **Services**: 网络请求、数据存储等服务
- **Utilities**: 工具函数和扩展

#### 测试重点
```swift
// 示例：ViewModel测试
class HotelSearchViewModelTests: XCTestCase {
    func testSearchWithValidInput() {
        // Given
        let viewModel = HotelSearchViewModel()
        let searchQuery = "北京"
        
        // When
        viewModel.searchHotels(query: searchQuery)
        
        // Then
        XCTAssertTrue(viewModel.isLoading)
        XCTAssertNotNil(viewModel.searchResults)
    }
}
```

#### 质量要求
- 每个公共方法至少有一个测试用例
- 覆盖正常流程和异常流程
- Mock外部依赖，确保测试独立性

### 2. 集成测试 (Integration Tests)

#### 覆盖范围
- **网络层集成**: API调用和响应处理
- **数据持久化**: CoreData/UserDefaults操作
- **组件间通信**: Coordinator与ViewController交互
- **第三方SDK**: 地图、支付等功能集成

#### 测试重点
```swift
// 示例：网络服务集成测试
class NetworkServiceIntegrationTests: XCTestCase {
    func testHotelSearchAPI() {
        // Given
        let expectation = XCTestExpectation(description: "API调用完成")
        let service = HotelAPIService()
        
        // When
        service.searchHotels(location: "上海") { result in
            // Then
            switch result {
            case .success(let hotels):
                XCTAssertGreaterThan(hotels.count, 0)
            case .failure(let error):
                XCTFail("API调用失败: \(error)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
}
```

### 3. UI测试 (UI Tests)

#### 覆盖范围
- **核心用户流程**: 搜索、预订、支付等
- **界面交互**: 按钮点击、列表滚动、表单填写
- **导航流程**: 页面跳转和返回
- **边界情况**: 空数据、网络错误等场景

#### 测试重点
```swift
// 示例：UI流程测试
class HotelSearchUITests: XCTestCase {
    func testSearchFlow() {
        let app = XCUIApplication()
        app.launch()
        
        // 测试搜索流程
        let searchField = app.searchFields["搜索酒店"]
        searchField.tap()
        searchField.typeText("三亚度假酒店")
        
        app.buttons["搜索"].tap()
        
        // 验证结果
        XCTAssertTrue(app.tables.cells.count > 0)
        XCTAssertTrue(app.staticTexts["价格"].exists)
    }
}
```

## 📊 测试数据策略

### 测试数据管理
- **Mock数据**: 用于单元测试，确保测试可重复
- **Staging环境**: 用于集成测试，接近真实数据
- **生产数据子集**: 用于性能测试，保证真实性

### 数据生成工具
```swift
// Mock数据工厂
struct MockDataFactory {
    static func createHotelPackage(id: String = UUID().uuidString) -> HotelPackage {
        return HotelPackage(
            id: id,
            name: "测试酒店\(Int.random(in: 1...100))",
            location: "北京市朝阳区",
            price: Double.random(in: 200...2000),
            rating: Double.random(in: 3.0...5.0),
            amenities: [.wifi, .parking, .restaurant],
            images: ["hotel_image_\(id).jpg"],
            description: "这是一家优质的测试酒店"
        )
    }
}
```

## 🔧 测试环境配置

### 本地开发环境
```yaml
# .swiftlint.yml - 本地代码质量检查
disabled_rules:
  - todo
opt_in_rules:
  - force_unwrapping
  - implicit_return

included:
  - Sources
  - Tests
```

### CI/CD环境
```yaml
# GitHub Actions配置片段
test-job:
  runs-on: macos-latest
  steps:
    - name: Run unit tests
      run: swift test --enable-code-coverage
      
    - name: Check coverage threshold
      run: |
        COVERAGE=$(xccov view --report .build/debug/codecov/*.profdata | grep "HotelBookingDemo" | awk '{print $4}' | sed 's/%//')
        if (( $(echo "$COVERAGE < 80" | bc -l) )); then
          echo "Coverage $COVERAGE% is below threshold"
          exit 1
        fi
```

## 📈 测试质量指标

### 核心指标
| 指标 | 目标值 | 计算方式 | 更新频率 |
|------|--------|----------|----------|
| 测试覆盖率 | ≥ 80% | 已覆盖代码行数/总代码行数 | 每次提交 |
| 测试通过率 | ≥ 98% | 通过测试数/总测试数 | 每次构建 |
| 平均修复时间 | ≤ 2天 | 缺陷发现到修复的时间 | 每周统计 |
| 测试执行时间 | ≤ 10分钟 | 完整测试套件执行时间 | 每日监控 |

### 质量门禁
```swift
// 测试覆盖率检查脚本
func checkCoverageThreshold() throws {
    let minimumCoverage: Double = 80.0
    let currentCoverage = try getCoverageFromReport()
    
    guard currentCoverage >= minimumCoverage else {
        throw CoverageError.belowThreshold(
            expected: minimumCoverage,
            actual: currentCoverage
        )
    }
}
```

## 🚀 测试执行策略

### 本地开发
- **快速反馈**: 保存时运行相关测试
- **完整验证**: 提交前运行完整测试套件
- **TDD实践**: 先写测试，再实现功能

### 持续集成
- **每次提交**: 运行核心单元测试
- **每日构建**: 运行完整测试套件
- **发布前**: 执行所有测试类型

### 发布验证
- **Beta测试**: 内部测试团队验证
- **灰度发布**: 小范围用户验证
- **全量发布**: 监控线上质量指标

## 🛠️ 测试工具和框架

### 主要工具
- **XCTest**: Apple官方测试框架
- **Quick/Nimble**: BDD测试框架
- **SnapshotTesting**: UI快照测试
- **OHHTTPStubs**: 网络请求Mock
- **Cuckoo**: Mock生成工具

### 辅助工具
- **SwiftLint**: 代码质量检查
- **Xcode Instruments**: 性能分析
- **Fastlane**: 自动化测试部署
- **TestFlight**: Beta测试分发

## 📚 最佳实践

### 测试编写原则
1. **FIRST原则**
   - Fast: 快速执行
   - Independent: 独立运行
   - Repeatable: 可重复执行
   - Self-validating: 自验证结果
   - Timely: 及时编写

2. **AAA模式**
   - Arrange: 准备测试数据和环境
   - Act: 执行被测功能
   - Assert: 验证预期结果

### 维护策略
- 定期清理过时测试
- 重构测试代码保持可读性
- 更新测试以适应功能变更
- 监控测试执行性能

---
*文档维护: Guardian Agent*  
*适用范围: HotelBookingDemo项目*