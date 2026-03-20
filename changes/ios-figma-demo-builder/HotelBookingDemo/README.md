# HotelBookingDemo

[![Build Status](https://github.com/yourusername/HotelBookingDemo/workflows/CI/badge.svg)](https://github.com/yourusername/HotelBookingDemo/actions)
[![License](https://img.shields.io/github/license/yourusername/HotelBookingDemo)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-iOS-blue)](https://developer.apple.com/ios/)
[![Swift](https://img.shields.io/badge/swift-5.5+-orange)](https://swift.org)

A modern iOS hotel booking demo application showcasing MVVM+Coordinator architecture with Figma CSS integration capabilities.

## 🏗️ Architecture Overview

This project demonstrates a clean, scalable iOS application architecture featuring:

- **MVVM+Coordinator Pattern**: Clear separation of concerns and navigation management
- **Dependency Injection**: Loose coupling through container-based service resolution
- **Protocol-Oriented Design**: Flexible and testable component interfaces
- **Figma CSS Integration**: Automatic design-to-code conversion pipeline

## 📁 Project Structure

```
HotelBookingDemo/
├── Sources/
│   ├── Core/              # Architecture foundation
│   │   ├── Protocols/     # Core protocols and interfaces
│   │   ├── BaseCoordinator.swift
│   │   ├── BaseViewModel.swift
│   │   └── DIContainer.swift
│   ├── Features/          # Business logic modules
│   │   ├── HotelSearch/   # Search functionality
│   │   ├── Booking/       # Reservation system
│   │   └── Profile/       # User management
│   ├── UI/               # User interface components
│   │   ├── Components/    # Reusable UI components
│   │   ├── Views/         # Custom views
│   │   └── ViewControllers/ # Screen controllers
│   ├── Data/             # Data layer
│   │   ├── Models/        # Data models
│   │   ├── Repositories/  # Data access layer
│   │   └── Network/       # API clients
│   └── Utils/            # Utility classes
│       ├── CSSParser/     # Figma CSS parsing
│       ├── Helpers/       # Helper extensions
│       └── Constants/     # Application constants
├── Tests/                # Test suite
├── Resources/            # Asset files
└── SupportingFiles/      # Configuration files
```

## 🚀 Getting Started

### Prerequisites

- Xcode 13.0 or later
- iOS 12.0+ deployment target
- Swift 5.5+

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/HotelBookingDemo.git
cd HotelBookingDemo
```

2. Open the project in Xcode:
```bash
open HotelBookingDemo.xcodeproj
```

3. Build and run the project (⌘+R)

### Figma Integration Setup

To enable Figma CSS parsing:

1. Export your Figma design as CSS
2. Place the CSS file in the project's Resources directory
3. The CSS parser will automatically process design tokens and component styles

## 🧪 Testing

Run all tests using:
```bash
xcodebuild test -scheme HotelBookingDemo -destination 'platform=iOS Simulator,name=iPhone 14'
```

Or run specific test suites:
```bash
# Unit tests
swift test --filter UnitTests

# UI tests
swift test --filter UITests
```

## 📊 Code Quality

This project maintains high code quality standards:

- **SwiftLint**: Enforced code style and conventions
- **Code Coverage**: Target 80%+ test coverage
- **Continuous Integration**: Automated testing and building
- **Documentation**: Comprehensive inline documentation

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Quick Start for Contributors

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Team

This project was developed using a multi-agent collaborative approach:

- **Builder**: Project architecture and integration
- **Hunter**: Data models and business logic
- **Designer**: UI components and design system
- **Guardian**: Quality assurance and testing
- **Deployer**: DevOps and deployment automation

## 🙏 Acknowledgments

- Inspired by modern iOS architecture patterns
- Built with Swift and UIKit
- Design system powered by Figma integration