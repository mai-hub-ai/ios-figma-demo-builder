//
//  ThemeManager.swift
//  HotelBookingDemo
//
//  Created by Designer on 2024.
//

import UIKit

public enum Theme: String, CaseIterable {
    case light = "Light"
    case dark = "Dark"
    
    var displayName: String {
        switch self {
        case .light:
            return "浅色模式"
        case .dark:
            return "深色模式"
        }
    }
}

public protocol Themeable {
    func applyTheme(_ theme: Theme)
}

public class ThemeManager {
    public static let shared = ThemeManager()
    
    private init() {}
    
    private var currentTheme: Theme = .light
    private var themeObservers: [Themeable] = []
    
    public var theme: Theme {
        get { currentTheme }
        set {
            guard currentTheme != newValue else { return }
            currentTheme = newValue
            notifyThemeChange()
        }
    }
    
    public func registerObserver(_ observer: Themeable) {
        themeObservers.append(observer)
        observer.applyTheme(currentTheme)
    }
    
    public func unregisterObserver(_ observer: Themeable) {
        themeObservers.removeAll { $0 === observer }
    }
    
    private func notifyThemeChange() {
        themeObservers.forEach { $0.applyTheme(currentTheme) }
    }
    
    // MARK: - Theme-Specific Colors
    public func backgroundColor(for theme: Theme) -> UIColor {
        switch theme {
        case .light:
            return Colors.background
        case .dark:
            return UIColor(hex: "#121212")
        }
    }
    
    public func surfaceColor(for theme: Theme) -> UIColor {
        switch theme {
        case .light:
            return Colors.surface
        case .dark:
            return UIColor(hex: "#1E1E1E")
        }
    }
    
    public func textColor(for theme: Theme, style: TextStyle = .primary) -> UIColor {
        switch theme {
        case .light:
            return lightTextColor(style: style)
        case .dark:
            return darkTextColor(style: style)
        }
    }
    
    private func lightTextColor(style: TextStyle) -> UIColor {
        switch style {
        case .primary:
            return UIColor.label
        case .secondary:
            return UIColor.secondaryLabel
        case .tertiary:
            return UIColor.tertiaryLabel
        case .disabled:
            return UIColor.quaternaryLabel
        }
    }
    
    private func darkTextColor(style: TextStyle) -> UIColor {
        switch style {
        case .primary:
            return UIColor.white
        case .secondary:
            return UIColor(hex: "#E8EAED")
        case .tertiary:
            return UIColor(hex: "#9AA0A6")
        case .disabled:
            return UIColor(hex: "#5F6368")
        }
    }
}

public enum TextStyle {
    case primary
    case secondary
    case tertiary
    case disabled
}