# iOS Figma Demo Builder 项目宪法 (Constitution)

## 1. 项目愿景与目标

构建一套完整的Swift原生iOS项目架构，实现从Figma设计稿（CSS格式）到可交互前端Demo的自动化转换系统。通过OpenSpec开发模式，打造高质量、可维护、可扩展的代码项目，支持组件化开发、自动化代码生成和规范化的团队协作。

## 2. 核心价值观

### 2.1 用户至上 (User First)
- 所有技术决策以最终用户体验为核心
- 界面设计简洁直观，降低用户学习成本
- 性能优化优先保障用户流畅体验

### 2.2 质量为本 (Quality First)
- 代码质量是项目成功的基石
- 每一行代码都经过深思熟虑
- 测试覆盖率不低于85%

### 2.3 开放透明 (Open & Transparent)
- 所有决策过程公开透明
- 代码和文档完全开源
- 欢迎社区贡献和反馈

### 2.4 持续改进 (Continuous Improvement)
- 定期回顾和优化开发流程
- 拥抱新技术和最佳实践
- 从每个项目中学习和成长

## 3. 技术架构原则

### 3.1 分层架构 (Layered Architecture)
```
┌─────────────────────────────────────┐
│           Presentation Layer        │
│  (UI Components & View Controllers) │
├─────────────────────────────────────┤
│           Business Logic Layer      │
│      (ViewModels & Use Cases)       │
├─────────────────────────────────────┤
│           Data Layer                │
│    (Repositories & Data Models)     │
├─────────────────────────────────────┤
│           Infrastructure Layer      │
│  (Networking, Storage, Utilities)   │
└─────────────────────────────────────┘
```

### 3.2 组件化设计 (Component-Based Design)
- 每个组件职责单一，高内聚低耦合
- 组件间通过明确定义的接口通信
- 支持组件的独立开发和测试

### 3.3 数据驱动 (Data-Driven Development)
- 业务逻辑与UI展示分离
- 使用响应式编程处理数据流
- Mock数据驱动开发和测试

## 4. 代码设计规范

### 4.1 命名规范 (Naming Conventions)

#### 文件命名
- Swift文件：采用PascalCase，如`HotelPackage.swift`
- 资源文件：采用kebab-case，如`hotel-icon.png`
- 测试文件：采用`[OriginalName]Tests.swift`格式

#### 类和结构体命名
```swift
// ✅ 好的命名
class HotelPackageViewController: UIViewController
struct UserRequirements
protocol HotelRepositoryProtocol

// ❌ 避免的命名
class HPViewController  // 缩写不清晰
struct UserData        // 过于宽泛
protocol Repo          // 不完整
```

#### 函数和变量命名
```swift
// ✅ 好的命名
func filterAndRankPackages(by requirements: UserRequirements) -> [HotelPackage]
let recommendedPackages: [HotelPackage]
var isLoading: Bool

// ❌ 避免的命名
func filter(by req: UR) -> [HP]  // 缩写过度
let rec_packages                // 下划线不规范
var loadingStatus               // 冗余命名
```

### 4.2 代码组织规范

#### 目录结构
```
Sources/
├── Application/                # 应用入口和配置
├── Presentation/               # UI层
│   ├── Scenes/                # 页面场景
│   ├── Components/            # 可复用组件
│   └── Extensions/            # UIKit扩展
├── Domain/                    # 业务领域层
│   ├── Models/               # 数据模型
│   ├── UseCases/             # 业务用例
│   └── Repositories/         # 数据仓库
├── Data/                      # 数据层
│   ├── Network/              # 网络请求
│   ├── LocalStorage/         # 本地存储
│   └── MockData/             # 模拟数据
└── Utilities/                 # 工具类
    ├── DesignSystem/         # 设计系统
    ├── Extensions/           # 扩展方法
    └── Helpers/              # 辅助工具
```

#### 单个文件结构
```swift
// MARK: - Imports
import UIKit
import Combine

// MARK: - Type Definitions
protocol SomeProtocol {
    // 协议定义
}

// MARK: - Main Implementation
class SomeClass {
    // MARK: - Properties
    // 属性定义
    
    // MARK: - Lifecycle
    // 生命周期方法
    
    // MARK: - Public Methods
    // 公共方法
    
    // MARK: - Private Methods
    // 私有方法
}

// MARK: - Extensions
extension SomeClass: SomeProtocol {
    // 协议实现
}
```

### 4.3 Swift语言规范

#### 可选类型处理
```swift
// ✅ 推荐的可选处理
guard let package = selectedPackage else {
    showError("请选择套餐")
    return
}
// 使用package进行后续操作

// ❌ 避免强制解包
let package = selectedPackage!  // 危险！

// ❌ 避免过多嵌套
if selectedPackage != nil {
    let package = selectedPackage!
    // 嵌套代码
}
```

#### 错误处理
```swift
// ✅ 使用Result类型
enum HotelServiceError: Error {
    case networkFailure
    case invalidData
    case packageNotFound
}

func fetchPackages() -> AnyPublisher<[HotelPackage], HotelServiceError>

// ✅ 使用do-catch处理
do {
    let packages = try await hotelService.fetchPackages()
    updateUI(with: packages)
} catch HotelServiceError.networkFailure {
    showNetworkError()
} catch {
    showGenericError()
}
```

## 5. 代码安全规范

### 5.1 内存安全管理

#### 弱引用和循环引用
```swift
// ✅ 正确处理闭包中的循环引用
class SomeViewController: UIViewController {
    var dataService: DataService?
    
    func fetchData() {
        dataService?.fetchData { [weak self] result in
            guard let self = self else { return }
            // 安全使用self
        }
    }
}

// ✅ 使用unowned引用（确定不会为nil时）
class ParentViewController: UIViewController {
    let childController: ChildViewController
    
    init() {
        childController = ChildViewController()
        childController.parent = self  // unowned引用
    }
}

class ChildViewController: UIViewController {
    unowned let parent: ParentViewController
}
```

#### 资源释放
```swift
// ✅ 正确释放观察者
class SomeViewController: UIViewController {
    private var notificationObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotifications()
    }
    
    deinit {
        if let observer = notificationObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    private func setupNotifications() {
        notificationObserver = NotificationCenter.default.addObserver(
            forName: .UIKeyboardWillShow,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.keyboardWillShow()
        }
    }
}
```

### 5.2 数据安全

#### 用户数据保护
```swift
// ✅ 敏感数据加密存储
class SecureStorage {
    private let keychain = Keychain(service: "com.yourapp.service")
    
    func saveUserToken(_ token: String) {
        try? keychain.set(token, key: "user_token")
    }
    
    func getUserToken() -> String? {
        try? keychain.getString("user_token")
    }
}

// ✅ 网络传输加密
class APIClient {
    private let session: URLSession
    
    init() {
        let config = URLSessionConfiguration.default
        config.urlCache = nil  // 敏感请求不缓存
        self.session = URLSession(configuration: config)
    }
    
    func makeSecureRequest(url: URL) -> AnyPublisher<Data, Error> {
        var request = URLRequest(url: url)
        request.setValue("Bearer \(getToken())", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return session.dataTaskPublisher(for: request)
            .map(\.data)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
```

### 5.3 输入验证和防护

```swift
// ✅ 输入验证
class InputValidator {
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    static func isValidPhoneNumber(_ phone: String) -> Bool {
        let phoneRegex = "^\\d{11}$"  // 简单的11位手机号验证
        let phonePredicate = NSPredicate(format:"SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phone.replacingOccurrences(of: "-", with: ""))
    }
}

// ✅ 防止注入攻击
class SafeStringFormatter {
    static func sanitizeInput(_ input: String) -> String {
        return input
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
            .replacingOccurrences(of: "'", with: "&#x27;")
    }
}
```

## 6. 代码原子化规范

### 6.1 组件原子化原则

#### 原子组件 (Atoms)
```swift
// ✅ 原子组件 - 最小可复用单元
class PrimaryButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStyle()
    }
    
    private func setupStyle() {
        backgroundColor = DesignTokens.Colors.primary
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = DesignTokens.CornerRadius.medium
       .titleLabel?.font = DesignTokens.Typography.headline
    }
}

class SecondaryButton: UIButton {
    // 类似实现，不同的样式配置
}
```

#### 分子组件 (Molecules)
```swift
// ✅ 分子组件 - 原子组件的组合
class SearchBar: UIControl {
    private let textField = UITextField()
    private let searchButton = PrimaryButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
    }
    
    // 组合多个原子组件形成复合功能
}
```

#### 组织组件 (Organisms)
```swift
// ✅ 组织组件 - 复杂业务组件
class HotelPackageCard: UIControl {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let favoriteButton = UIButton()
    
    // 封装完整的酒店套餐展示逻辑
}
```

### 6.2 状态管理原子化

```swift
// ✅ 原子化状态管理
class ViewState<T> {
    @Published var value: Result<T, Error>?
    
    func loading() {
        value = .success(placeholderValue())
    }
    
    func success(_ data: T) {
        value = .success(data)
    }
    
    func failure(_ error: Error) {
        value = .failure(error)
    }
    
    private func placeholderValue() -> T {
        // 返回占位值的逻辑
    }
}

// 使用示例
class HotelListViewModel: ObservableObject {
    @Published var packagesState = ViewState<[HotelPackage]>()
    @Published var isLoading = false
    
    func loadPackages() {
        isLoading = true
        packagesState.loading()
        
        hotelService.fetchPackages()
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.packagesState.failure(error)
                    }
                },
                receiveValue: { [weak self] packages in
                    self?.packagesState.success(packages)
                }
            )
            .store(in: &cancellables)
    }
}
```

### 6.3 网络请求原子化

```swift
// ✅ 原子化网络请求
class APIEndpoint {
    static let baseURL = "https://api.yourapp.com"
    
    enum Hotels {
        static func list(parameters: [String: String]? = nil) -> URLRequest {
            var components = URLComponents(string: "\(baseURL)/hotels")!
            components.queryItems = parameters?.map { URLQueryItem(name: $0.key, value: $0.value) }
            
            var request = URLRequest(url: components.url!)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            return request
        }
        
        static func detail(id: String) -> URLRequest {
            let url = URL(string: "\(baseURL)/hotels/\(id)")!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            return request
        }
    }
}

// ✅ 原子化响应处理
class APIResponseHandler {
    static func handle<T: Decodable>(_ data: Data) throws -> T {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingFailed(error)
        }
    }
    
    static func handleError(_ data: Data?) -> APIError {
        guard let data = data,
              let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) else {
            return APIError.unknown
        }
        return APIError.serverError(errorResponse.message)
    }
}
```

## 7. Git提交规范

### 7.1 分支管理策略 (Git Flow)

```
main (生产分支)
  ├── release/v1.0.0 (发布分支)
  │   └── hotfix/security-patch (紧急修复)
  │
develop (开发主分支)
  ├── feature/user-authentication
  ├── feature/hotel-recommendation
  ├── feature/design-system
  └── bugfix/login-issue
```

#### 分支命名规范
```bash
# 功能开发
feature/[功能描述]              # 如: feature/hotel-package-display

# 缺陷修复  
bugfix/[问题描述]               # 如: bugfix/fix-crash-on-search

# 热修复
hotfix/[紧急问题]               # 如: hotfix/security-vulnerability

# 发布准备
release/v[版本号]              # 如: release/v1.2.0

# 实验性开发
experiment/[实验内容]          # 如: experiment/new-animation-engine
```

### 7.2 提交信息规范 (Conventional Commits)

#### 提交格式
```
<type>(<scope>): <subject>
<BLANK LINE>
<body>
<BLANK LINE>
<footer>
```

#### 提交类型 (Types)
- `feat`: 新功能 (feature)
- `fix`: 缺陷修复 (bug fix)
- `docs`: 文档变更
- `style`: 代码格式调整 (不影响功能)
- `refactor`: 代码重构 (不新增功能也不修复bug)
- `perf`: 性能优化
- `test`: 测试相关
- `chore`: 构建过程或辅助工具的变动

#### 示例提交
```bash
# ✅ 好的提交信息
feat(recommendation): 添加酒店套餐推荐算法

- 实现基于用户偏好的推荐逻辑
- 支持多维度排序(热度、评分、价格)
- 添加推荐结果缓存机制

Closes #123

# ✅ 修复提交
fix(chat): 修复消息发送失败的问题

- 修正网络超时设置
- 添加重试机制
- 优化错误提示信息

Fixes #456

# ✅ 文档更新
docs(readme): 更新项目使用说明

- 添加快速开始指南
- 完善API文档链接
- 修正安装步骤
```

### 7.3 代码审查规范

#### Pull Request要求
```markdown
## Pull Request模板

### 描述
简要描述这次变更的内容和目的

### 变更类型
- [ ] 功能新增
- [ ] 缺陷修复
- [ ] 性能优化
- [ ] 代码重构
- [ ] 文档更新

### 影响范围
- 影响的模块和功能
- 可能的风险点

### 测试情况
- [ ] 单元测试通过
- [ ] 集成测试通过
- [ ] 手动测试验证
- [ ] 性能测试完成

### 相关Issue
Closes #[Issue编号]
```

#### 代码审查检查清单
```markdown
## 代码审查清单

### 功能完整性
□ 代码实现了PR描述的所有功能
□ 边界条件和异常情况已处理
□ 错误处理机制完善

### 代码质量
□ 命名规范符合约定
□ 函数职责单一，复杂度合理
□ 没有重复代码
□ 注释清晰准确

### 安全性
□ 没有安全漏洞
□ 敏感信息处理得当
□ 输入验证完整

### 性能
□ 没有明显的性能问题
□ 内存使用合理
□ 网络请求优化

### 测试覆盖
□ 相关测试用例已添加
□ 测试覆盖率达标
□ 关键路径已测试
```

## 8. GitHub集成规范

### 8.1 仓库结构
```
ios-figma-demo-builder/
├── .github/
│   ├── workflows/
│   │   ├── ci.yml              # 持续集成
│   │   ├── code-quality.yml    # 代码质量检查
│   │   └── release.yml         # 自动发布
│   ├── ISSUE_TEMPLATE/
│   │   ├── bug_report.md
│   │   └── feature_request.md
│   └── PULL_REQUEST_TEMPLATE.md
├── Sources/                    # 源代码
├── Tests/                      # 测试代码
├── Documentation/              # 项目文档
├── Scripts/                    # 构建脚本
├── .gitignore
├── README.md
├── LICENSE
└── Package.swift              # Swift Package配置
```

### 8.2 自动化工作流

#### 持续集成 (CI)
```yaml
# .github/workflows/ci.yml
name: Continuous Integration

on:
  push:
    branches: [ develop, main ]
  pull_request:
    branches: [ develop ]

jobs:
  build-and-test:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Xcode
        uses: maxim-lobanov/setup-xcode@v1
        with:
          xcode-version: '14.2'
      
      - name: Build project
        run: |
          xcodebuild -workspace HotelRecommendation.xcworkspace \
                     -scheme HotelRecommendation \
                     -destination 'platform=iOS Simulator,name=iPhone 14' \
                     clean build
      
      - name: Run tests
        run: |
          xcodebuild -workspace HotelRecommendation.xcworkspace \
                     -scheme HotelRecommendation \
                     -destination 'platform=iOS Simulator,name=iPhone 14' \
                     test
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          file: ./coverage/*.json
```

#### 代码质量检查
```yaml
# .github/workflows/code-quality.yml
name: Code Quality

on:
  pull_request:
    branches: [ develop ]

jobs:
  quality-check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: SwiftLint
        run: |
          swiftlint --strict
      
      - name: Periphery (Dead Code Detection)
        run: |
          periphery scan --strict
```

## 9. 团队协作规范

### 9.1 沟通机制
- **每日站会**: 上午9:30，同步进展和阻塞问题
- **技术讨论**: 每周三下午2:00，技术方案评审
- **代码审查**: PR创建后24小时内完成审查
- **紧急问题**: 通过即时通讯工具实时沟通

### 9.2 决策流程
```
技术决策 → 核心开发者讨论 → 文档记录 → 团队通知 → 实施执行
    ↑                                            ↓
    └───────────── 反馈收集 ←─── 结果评估 ←────┘
```

### 9.3 文档维护
- 所有技术决策必须文档化
- 重要会议要有会议纪要
- 代码变更要及时更新相关文档
- 定期审查和更新过时文档

## 10. 质量保证标准

### 10.1 代码质量门禁
- **编译通过率**: 100%
- **测试覆盖率**: ≥ 85%
- **SwiftLint违规**: 0个error，warning < 10个
- **代码复杂度**: 单个函数圈复杂度 ≤ 10

### 10.2 性能基准
- **应用启动时间**: < 2秒
- **内存占用**: < 100MB (模拟器)
- **帧率**: ≥ 55 FPS (UI流畅度)
- **网络请求**: 95%请求 < 1秒响应

### 10.3 安全标准
- **静态安全扫描**: 0个高危漏洞
- **依赖安全检查**: 所有第三方库无已知漏洞
- **数据传输**: 敏感数据必须加密
- **权限申请**: 最小化权限原则

---
*本文档最后更新: 2024年3月*
*版本: 1.0.0*