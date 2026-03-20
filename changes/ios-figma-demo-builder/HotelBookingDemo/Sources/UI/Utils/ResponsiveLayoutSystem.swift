//
//  ResponsiveLayoutSystem.swift
//  HotelBookingDemo
//
//  Created by Designer on 2024.
//

import UIKit

// MARK: - Device Size Categories
public enum DeviceSizeCategory {
    case compact   // iPhone SE, iPhone in landscape
    case regular   // iPhone, iPad mini
    case large     // iPad, iPad Pro
    
    public static var current: DeviceSizeCategory {
        let screenSize = UIScreen.main.bounds.size
        let screenWidth = min(screenSize.width, screenSize.height) // Use shorter dimension
        
        switch screenWidth {
        case 0..<400:
            return .compact
        case 400..<800:
            return .regular
        default:
            return .large
        }
    }
    
    public var name: String {
        switch self {
        case .compact: return "Compact"
        case .regular: return "Regular"
        case .large: return "Large"
        }
    }
}

// MARK: - Orientation
public enum InterfaceOrientation {
    case portrait
    case landscape
    
    public static var current: InterfaceOrientation {
        return UIDevice.current.orientation.isLandscape ? .landscape : .portrait
    }
    
    public var isPortrait: Bool { self == .portrait }
    public var isLandscape: Bool { self == .landscape }
}

// MARK: - Responsive Layout Manager
public class ResponsiveLayoutManager {
    
    public static let shared = ResponsiveLayoutManager()
    
    private init() {}
    
    // MARK: - Spacing Adaptation
    public func adaptiveSpacing(for category: DeviceSizeCategory) -> AdaptiveSpacing {
        switch category {
        case .compact:
            return AdaptiveSpacing(
                xs: Spacing.xxs,
                s: Spacing.xs,
                m: Spacing.s,
                l: Spacing.m,
                xl: Spacing.l
            )
        case .regular:
            return AdaptiveSpacing(
                xs: Spacing.xs,
                s: Spacing.s,
                m: Spacing.m,
                l: Spacing.l,
                xl: Spacing.xl
            )
        case .large:
            return AdaptiveSpacing(
                xs: Spacing.s,
                s: Spacing.m,
                m: Spacing.l,
                l: Spacing.xl,
                xl: Spacing.xxl
            )
        }
    }
    
    // MARK: - Font Size Adaptation
    public func adaptiveFontSize(for category: DeviceSizeCategory) -> AdaptiveFonts {
        switch category {
        case .compact:
            return AdaptiveFonts(
                caption: 11,
                body: 14,
                title: 18,
                headline: 22,
                display: 28
            )
        case .regular:
            return AdaptiveFonts(
                caption: 12,
                body: 16,
                title: 20,
                headline: 24,
                display: 32
            )
        case .large:
            return AdaptiveFonts(
                caption: 14,
                body: 18,
                title: 24,
                headline: 28,
                display: 36
            )
        }
    }
    
    // MARK: - Grid Layout
    public func columnCount(for category: DeviceSizeCategory, orientation: InterfaceOrientation) -> Int {
        switch (category, orientation) {
        case (.compact, .portrait):
            return 1
        case (.compact, .landscape):
            return 2
        case (.regular, .portrait):
            return 2
        case (.regular, .landscape):
            return 3
        case (.large, .portrait):
            return 3
        case (.large, .landscape):
            return 4
        }
    }
    
    // MARK: - Container Width
    public func containerWidth(for category: DeviceSizeCategory) -> CGFloat {
        switch category {
        case .compact:
            return UIScreen.main.bounds.width - (Spacing.m * 2)
        case .regular:
            return min(600, UIScreen.main.bounds.width - (Spacing.l * 2))
        case .large:
            return min(800, UIScreen.main.bounds.width - (Spacing.xl * 2))
        }
    }
    
    // MARK: - Image Sizes
    public func imageSize(for category: DeviceSizeCategory, type: ImageType) -> CGSize {
        switch type {
        case .thumbnail:
            switch category {
            case .compact: return CGSize(width: 60, height: 60)
            case .regular: return CGSize(width: 80, height: 80)
            case .large: return CGSize(width: 100, height: 100)
            }
        case .card:
            switch category {
            case .compact: return CGSize(width: 120, height: 80)
            case .regular: return CGSize(width: 160, height: 100)
            case .large: return CGSize(width: 200, height: 120)
            }
        case .hero:
            let width = containerWidth(for: category)
            return CGSize(width: width, height: width * 0.6)
        }
    }
}

// MARK: - Adaptive Data Structures
public struct AdaptiveSpacing {
    public let xs: CGFloat
    public let s: CGFloat
    public let m: CGFloat
    public let l: CGFloat
    public let xl: CGFloat
    
    public init(xs: CGFloat, s: CGFloat, m: CGFloat, l: CGFloat, xl: CGFloat) {
        self.xs = xs
        self.s = s
        self.m = m
        self.l = l
        self.xl = xl
    }
}

public struct AdaptiveFonts {
    public let caption: CGFloat
    public let body: CGFloat
    public let title: CGFloat
    public let headline: CGFloat
    public let display: CGFloat
    
    public func font(for style: UIFont.TextStyle) -> UIFont {
        let size: CGFloat
        switch style {
        case .caption1, .caption2:
            size = caption
        case .body, .callout:
            size = body
        case .title3, .title2:
            size = title
        case .title1:
            size = headline
        case .largeTitle:
            size = display
        default:
            size = body
        }
        return UIFont.systemFont(ofSize: size)
    }
}

public enum ImageType {
    case thumbnail
    case card
    case hero
}

// MARK: - Responsive View Protocol
public protocol ResponsiveView: UIView {
    func updateForDeviceSize(_ sizeCategory: DeviceSizeCategory, orientation: InterfaceOrientation)
}

// MARK: - Responsive Stack View
public class ResponsiveStackView: UIStackView, ResponsiveView {
    
    private var compactAxis: NSLayoutConstraint.Axis = .vertical
    private var regularAxis: NSLayoutConstraint.Axis = .vertical
    private var largeAxis: NSLayoutConstraint.Axis = .vertical
    
    public func setAdaptiveAxis(compact: NSLayoutConstraint.Axis, regular: NSLayoutConstraint.Axis, large: NSLayoutConstraint.Axis) {
        self.compactAxis = compact
        self.regularAxis = regular
        self.largeAxis = large
        updateAxisForCurrentSize()
    }
    
    public func updateForDeviceSize(_ sizeCategory: DeviceSizeCategory, orientation: InterfaceOrientation) {
        updateAxisForCurrentSize()
        updateSpacingForCurrentSize()
    }
    
    private func updateAxisForCurrentSize() {
        let currentCategory = DeviceSizeCategory.current
        switch currentCategory {
        case .compact:
            axis = compactAxis
        case .regular:
            axis = regularAxis
        case .large:
            axis = largeAxis
        }
    }
    
    private func updateSpacingForCurrentSize() {
        let layoutManager = ResponsiveLayoutManager.shared
        let adaptiveSpacing = layoutManager.adaptiveSpacing(for: DeviceSizeCategory.current)
        spacing = adaptiveSpacing.m
    }
}

// MARK: - Responsive Container View
public class ResponsiveContainerView: UIView, ResponsiveView {
    
    public func updateForDeviceSize(_ sizeCategory: DeviceSizeCategory, orientation: InterfaceOrientation) {
        // Update container properties based on device size
        updateCornerRadius(for: sizeCategory)
        updatePadding(for: sizeCategory)
    }
    
    private func updateCornerRadius(for category: DeviceSizeCategory) {
        switch category {
        case .compact:
            layer.cornerRadius = BorderRadius.small
        case .regular:
            layer.cornerRadius = BorderRadius.medium
        case .large:
            layer.cornerRadius = BorderRadius.large
        }
    }
    
    private func updatePadding(for category: DeviceSizeCategory) {
        let layoutManager = ResponsiveLayoutManager.shared
        let adaptiveSpacing = layoutManager.adaptiveSpacing(for: category)
        
        // This would typically be used with AutoLayout constraints
        // that reference these spacing values
        print("Updating padding for \(category.name): \(adaptiveSpacing.m)")
    }
}

// MARK: - Grid Layout Manager
public class GridLayoutManager {
    
    public static let shared = GridLayoutManager()
    
    public func createGridLayout(
        itemCount: Int,
        containerWidth: CGFloat,
        itemHeight: CGFloat,
        sizeCategory: DeviceSizeCategory,
        orientation: InterfaceOrientation
    ) -> GridLayoutInfo {
        
        let columnCount = ResponsiveLayoutManager.shared.columnCount(for: sizeCategory, orientation: orientation)
        let rowCount = Int(ceil(Double(itemCount) / Double(columnCount)))
        
        let layoutManager = ResponsiveLayoutManager.shared
        let adaptiveSpacing = layoutManager.adaptiveSpacing(for: sizeCategory)
        
        let totalSpacing = adaptiveSpacing.m * CGFloat(columnCount - 1)
        let itemWidth = (containerWidth - totalSpacing) / CGFloat(columnCount)
        
        return GridLayoutInfo(
            columnCount: columnCount,
            rowCount: rowCount,
            itemWidth: itemWidth,
            itemHeight: itemHeight,
            horizontalSpacing: adaptiveSpacing.m,
            verticalSpacing: adaptiveSpacing.m
        )
    }
}

public struct GridLayoutInfo {
    public let columnCount: Int
    public let rowCount: Int
    public let itemWidth: CGFloat
    public let itemHeight: CGFloat
    public let horizontalSpacing: CGFloat
    public let verticalSpacing: CGFloat
    
    public var totalWidth: CGFloat {
        return CGFloat(columnCount) * itemWidth + CGFloat(columnCount - 1) * horizontalSpacing
    }
    
    public var totalHeight: CGFloat {
        return CGFloat(rowCount) * itemHeight + CGFloat(rowCount - 1) * verticalSpacing
    }
}

// MARK: - Device Size Observer
public protocol DeviceSizeObserver: AnyObject {
    func deviceSizeDidChange(to category: DeviceSizeCategory, orientation: InterfaceOrientation)
}

public class DeviceSizeMonitor {
    
    public static let shared = DeviceSizeMonitor()
    
    private var observers: [DeviceSizeObserver] = []
    private var currentSizeCategory: DeviceSizeCategory = .regular
    private var currentOrientation: InterfaceOrientation = .portrait
    
    private init() {
        setupNotifications()
        updateCurrentDeviceState()
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(deviceOrientationDidChange),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
    }
    
    @objc private func deviceOrientationDidChange() {
        DispatchQueue.main.async {
            self.updateCurrentDeviceState()
        }
    }
    
    private func updateCurrentDeviceState() {
        let newSizeCategory = DeviceSizeCategory.current
        let newOrientation = InterfaceOrientation.current
        
        if newSizeCategory != currentSizeCategory || newOrientation != currentOrientation {
            currentSizeCategory = newSizeCategory
            currentOrientation = newOrientation
            notifyObservers()
        }
    }
    
    private func notifyObservers() {
        observers.forEach { observer in
            observer.deviceSizeDidChange(to: currentSizeCategory, orientation: currentOrientation)
        }
    }
    
    public func addObserver(_ observer: DeviceSizeObserver) {
        observers.append(observer)
        observer.deviceSizeDidChange(to: currentSizeCategory, orientation: currentOrientation)
    }
    
    public func removeObserver(_ observer: DeviceSizeObserver) {
        observers.removeAll { $0 === observer }
    }
}

// MARK: - UIKit Extensions
public extension UIView {
    var deviceSizeCategory: DeviceSizeCategory {
        return DeviceSizeCategory.current
    }
    
    var interfaceOrientation: InterfaceOrientation {
        return InterfaceOrientation.current
    }
    
    func adaptToCurrentDeviceSize() {
        if let responsiveView = self as? ResponsiveView {
            responsiveView.updateForDeviceSize(DeviceSizeCategory.current, orientation: InterfaceOrientation.current)
        }
    }
}

public extension UIViewController {
    func setupResponsiveLayout() {
        view.adaptToCurrentDeviceSize()
        
        // Add device size observer if view controller conforms to protocol
        if let observer = self as? DeviceSizeObserver {
            DeviceSizeMonitor.shared.addObserver(observer)
        }
    }
}