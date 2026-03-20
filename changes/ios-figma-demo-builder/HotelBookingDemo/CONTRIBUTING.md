# Contributing to HotelBookingDemo

Thank you for your interest in contributing to HotelBookingDemo! This document provides guidelines and procedures for contributing to the project.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Testing Guidelines](#testing-guidelines)
- [Pull Request Process](#pull-request-process)
- [Issue Reporting](#issue-reporting)

## 🤝 Code of Conduct

This project adheres to a code of conduct that promotes respectful and inclusive collaboration. By participating, you agree to maintain a welcoming environment for all contributors.

## 🚀 Getting Started

### Prerequisites
- Xcode 13.0+
- Swift 5.5+
- Git

### Setting Up Development Environment

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/yourusername/HotelBookingDemo.git
   cd HotelBookingDemo
   ```
3. Install dependencies (if any)
4. Open `HotelBookingDemo.xcodeproj` in Xcode
5. Run tests to ensure everything works: `⌘+U`

## 🔧 Development Workflow

### Branch Naming Convention
- `feature/` - New features
- `bugfix/` - Bug fixes
- `hotfix/` - Critical production fixes
- `refactor/` - Code refactoring
- `docs/` - Documentation changes

### Commit Message Format
Follow [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
type(scope): brief description

Detailed description of changes

Refs: #123
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes
- `refactor`: Code refactoring
- `test`: Test additions/modifications
- `chore`: Maintenance tasks

### Example Commit Messages
```
feat(search): implement hotel search functionality

Added search view controller with filtering capabilities
- Integrated with hotel repository
- Added price range filtering
- Implemented location-based sorting

Refs: #45
```

## 📝 Coding Standards

### Swift Style Guide
- Follow [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- Use SwiftLint for automatic style checking
- Maintain consistent naming conventions:
  - Classes: UpperCamelCase
  - Functions/Variables: lowerCamelCase
  - Constants: UPPER_SNAKE_CASE

### Architecture Compliance
- Respect MVVM+Coordinator pattern
- Maintain protocol-oriented design
- Use dependency injection for loose coupling
- Keep view controllers thin

### Code Organization
```
// MARK: - Lifecycle
override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupConstraints()
    bindViewModel()
}

// MARK: - UI Setup
private func setupUI() {
    // UI configuration
}

// MARK: - Private Methods
private func bindViewModel() {
    // Binding logic
}
```

## 🧪 Testing Guidelines

### Test Coverage Requirements
- Minimum 80% code coverage
- All public interfaces must be tested
- Include edge case testing
- Maintain test documentation

### Test Structure
```swift
class FeatureNameTests: XCTestCase {
    
    // MARK: - Setup
    override func setUpWithError() throws {
        // Test setup
    }
    
    // MARK: - Tests
    func testExpectedBehavior() {
        // Given
        let sut = SystemUnderTest()
        
        // When
        let result = sut.performAction()
        
        // Then
        XCTAssertEqual(result, expectedValue)
    }
    
    func testEdgeCaseHandling() {
        // Test edge cases
    }
}
```

### Running Tests
```bash
# All tests
xcodebuild test -scheme HotelBookingDemo

# Specific test class
xcodebuild test -scheme HotelBookingDemo -only-testing:HotelBookingDemoTests/FeatureNameTests

# Generate code coverage
xcodebuild test -scheme HotelBookingDemo -enableCodeCoverage YES
```

## 📤 Pull Request Process

### Before Submitting
1. Ensure all tests pass
2. Run SwiftLint and fix any violations
3. Update documentation if needed
4. Verify code coverage meets requirements
5. Squash related commits

### PR Template
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests added/updated
- [ ] Integration tests passed
- [ ] UI tests verified

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] Documentation updated
- [ ] No new warnings introduced
```

### Review Process
1. Automated checks run on submission
2. Code review by team members
3. Address feedback and make requested changes
4. Final approval and merge

## 🐛 Issue Reporting

### Bug Reports
Use the bug report template:
```markdown
## Expected Behavior
Description of what should happen

## Actual Behavior
Description of what actually happens

## Steps to Reproduce
1. Step one
2. Step two
3. Observed behavior

## Environment
- Device: [e.g., iPhone 14]
- OS: [e.g., iOS 16.0]
- Xcode Version: [e.g., 14.0]
- App Version: [e.g., 1.0.0]

## Additional Context
Screenshots, logs, or other relevant information
```

### Feature Requests
Describe:
- Problem to solve
- Proposed solution
- Alternative approaches considered
- Impact and benefits

## 📚 Additional Resources

- [Project Wiki](https://github.com/yourusername/HotelBookingDemo/wiki)
- [Architecture Documentation](docs/architecture.md)
- [API Documentation](docs/api.md)
- [Design System](docs/design-system.md)

## 🤝 Questions?

Feel free to reach out through:
- GitHub Issues
- Project Discussions
- Team Slack channel

Thank you for contributing to HotelBookingDemo!