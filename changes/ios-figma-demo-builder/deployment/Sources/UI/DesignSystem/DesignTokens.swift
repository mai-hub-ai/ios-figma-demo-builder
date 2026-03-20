//
//  DesignTokens.swift
//  HotelBookingDemo
//
//  Created by Designer on 2024.
//

import UIKit

// MARK: - Color Tokens
public enum Colors {
    // Primary Colors
    public static let primary = UIColor(hex: "#1A73E8")
    public static let primaryLight = UIColor(hex: "#4A90E2")
    public static let primaryDark = UIColor(hex: "#0D47A1")
    
    // Accent Colors
    public static let primaryGold = UIColor(hex: "#FFD700")
    public static let accentRed = UIColor(hex: "#FF4500")
    public static let accentGreen = UIColor(hex: "#34C759")
    
    // Neutral Colors
    public static let background = UIColor(hex: "#F8F9FA")
    public static let surface = UIColor.white
    public static let surfaceSecondary = UIColor(hex: "#F1F3F4")
    
    // Text Colors
    public static let textPrimary = UIColor.label
    public static let textSecondary = UIColor.secondaryLabel
    public static let textTertiary = UIColor.tertiaryLabel
    public static let textDisabled = UIColor.quaternaryLabel
    
    // Border Colors
    public static let border = UIColor(hex: "#DADCE0")
    public static let borderStrong = UIColor(hex: "#BDC1C6")
    
    // Status Colors
    public static let success = UIColor(hex: "#34A853")
    public static let warning = UIColor(hex: "#FBBC04")
    public static let error = UIColor(hex: "#EA4335")
    public static let info = UIColor(hex: "#4285F4")
}

// MARK: - Typography Tokens
public enum Typography {
    // Display Fonts
    public static let displayLarge = UIFont.systemFont(ofSize: 32, weight: .black)
    public static let displayMedium = UIFont.systemFont(ofSize: 28, weight: .heavy)
    public static let displaySmall = UIFont.systemFont(ofSize: 24, weight: .bold)
    
    // Headline Fonts
    public static let headlineLarge = UIFont.systemFont(ofSize: 22, weight: .bold)
    public static let headlineMedium = UIFont.systemFont(ofSize: 20, weight: .semibold)
    public static let headlineSmall = UIFont.systemFont(ofSize: 18, weight: .semibold)
    
    // Title Fonts
    public static let titleLarge = UIFont.systemFont(ofSize: 16, weight: .semibold)
    public static let titleMedium = UIFont.systemFont(ofSize: 14, weight: .semibold)
    public static let titleSmall = UIFont.systemFont(ofSize: 12, weight: .semibold)
    
    // Body Fonts
    public static let bodyLarge = UIFont.systemFont(ofSize: 16, weight: .regular)
    public static let bodyMedium = UIFont.systemFont(ofSize: 14, weight: .regular)
    public static let bodySmall = UIFont.systemFont(ofSize: 12, weight: .regular)
    
    // Label Fonts
    public static let labelLarge = UIFont.systemFont(ofSize: 14, weight: .medium)
    public static let labelMedium = UIFont.systemFont(ofSize: 12, weight: .medium)
    public static let labelSmall = UIFont.systemFont(ofSize: 11, weight: .medium)
    
    // Price Fonts
    public static let priceLarge = UIFont.systemFont(ofSize: 24, weight: .heavy)
    public static let priceMedium = UIFont.systemFont(ofSize: 20, weight: .bold)
    public static let priceSmall = UIFont.systemFont(ofSize: 16, weight: .bold)
}

// MARK: - Spacing Tokens
public enum Spacing {
    public static let xxxs: CGFloat = 2
    public static let xxs: CGFloat = 4
    public static let xs: CGFloat = 8
    public static let s: CGFloat = 12
    public static let m: CGFloat = 16
    public static let l: CGFloat = 20
    public static let xl: CGFloat = 24
    public static let xxl: CGFloat = 32
    public static let xxxl: CGFloat = 40
}

// MARK: - Radius Tokens
public enum BorderRadius {
    public static let none: CGFloat = 0
    public static let small: CGFloat = 4
    public static let medium: CGFloat = 8
    public static let large: CGFloat = 12
    public static let xlarge: CGFloat = 16
    public static let circular: CGFloat = 999
}

// MARK: - Shadow Tokens
public enum Shadows {
    public static let light = NSShadow(
        offset: CGSize(width: 0, height: 1),
        blurRadius: 2,
        color: UIColor.black.withAlphaComponent(0.1)
    )
    
    public static let medium = NSShadow(
        offset: CGSize(width: 0, height: 2),
        blurRadius: 4,
        color: UIColor.black.withAlphaComponent(0.15)
    )
    
    public static let heavy = NSShadow(
        offset: CGSize(width: 0, height: 4),
        blurRadius: 8,
        color: UIColor.black.withAlphaComponent(0.2)
    )
}

// MARK: - Border Width Tokens
public enum BorderWidth {
    public static let hairline: CGFloat = 0.5
    public static let thin: CGFloat = 1
    public static let thick: CGFloat = 2
    public static let heavy: CGFloat = 3
}

// MARK: - Opacity Tokens
public enum Opacity {
    public static let disabled: CGFloat = 0.38
    public static let hover: CGFloat = 0.08
    public static let selected: CGFloat = 0.12
    public static let dragged: CGFloat = 0.16
    public static let overlay: CGFloat = 0.32
    public static let scrim: CGFloat = 0.40
}

// MARK: - Elevation Tokens
public enum Elevation {
    public static let level0: CGFloat = 0
    public static let level1: CGFloat = 1
    public static let level2: CGFloat = 3
    public static let level3: CGFloat = 6
    public static let level4: CGFloat = 8
    public static let level5: CGFloat = 12
}

// MARK: - UIColor Extension for Hex Support
extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255
        )
    }
}

// MARK: - NSShadow Helper
extension NSShadow {
    convenience init(offset: CGSize, blurRadius: CGFloat, color: UIColor) {
        self.init()
        self.shadowOffset = offset
        self.shadowBlurRadius = blurRadius
        self.shadowColor = color
    }
}