//
//  DesignTokenExtractor.swift
//  HotelBookingDemo
//
//  Created by Builder on 2024.
//

import UIKit

/// Extracts design tokens from parsed CSS rules
class DesignTokenExtractor {
    
    struct DesignTokens {
        let colors: ColorTokens
        let typography: TypographyTokens
        let spacing: SpacingTokens
    }
    
    struct ColorTokens {
        let primary: UIColor
        let secondary: UIColor
        let accent: UIColor
        let background: UIColor
        let surface: UIColor
        let status: StatusColors
        let semantic: [String: UIColor]
    }
    
    struct StatusColors {
        let success: UIColor
        let warning: UIColor
        let error: UIColor
        let info: UIColor
    }
    
    struct TypographyTokens {
        let headings: [UIFont]
        let body: UIFont
        let caption: UIFont
        let button: UIFont
        let fontFamily: String
    }
    
    struct SpacingTokens {
        let xs: CGFloat
        let sm: CGFloat
        let md: CGFloat
        let lg: CGFloat
        let xl: CGFloat
        let xxl: CGFloat
    }
    
    /// Extracts all design tokens from CSS rules
    func extractTokens(from rules: [CSSRule]) -> DesignTokens {
        let colorTokens = extractColors(from: rules)
        let typographyTokens = extractTypography(from: rules)
        let spacingTokens = extractSpacing(from: rules)
        
        return DesignTokens(
            colors: colorTokens,
            typography: typographyTokens,
            spacing: spacingTokens
        )
    }
    
    private func extractColors(from rules: [CSSRule]) -> ColorTokens {
        var semanticColors: [String: UIColor] = [:]
        
        for rule in rules {
            for (property, value) in rule.properties {
                if property.contains("color") {
                    if let color = parseColor(from: value) {
                        semanticColors[rule.selector] = color
                    }
                }
            }
        }
        
        // Default color assignments
        return ColorTokens(
            primary: semanticColors["primary"] ?? UIColor.systemBlue,
            secondary: semanticColors["secondary"] ?? UIColor.systemGray,
            accent: semanticColors["accent"] ?? UIColor.systemOrange,
            background: semanticColors["background"] ?? UIColor.systemBackground,
            surface: semanticColors["surface"] ?? UIColor.secondarySystemBackground,
            status: StatusColors(
                success: semanticColors["success"] ?? UIColor.systemGreen,
                warning: semanticColors["warning"] ?? UIColor.systemOrange,
                error: semanticColors["error"] ?? UIColor.systemRed,
                info: semanticColors["info"] ?? UIColor.systemBlue
            ),
            semantic: semanticColors
        )
    }
    
    private func extractTypography(from rules: [CSSRule]) -> TypographyTokens {
        var fontFamily = "System"
        var fontSize: CGFloat = 17
        
        for rule in rules {
            for (property, value) in rule.properties {
                if property == "font-family" {
                    fontFamily = value.replacingOccurrences(of: "\"", with: "")
                } else if property == "font-size" {
                    fontSize = parseFontSize(from: value) ?? fontSize
                }
            }
        }
        
        return TypographyTokens(
            headings: [
                UIFont.systemFont(ofSize: fontSize * 1.5, weight: .bold),
                UIFont.systemFont(ofSize: fontSize * 1.3, weight: .semibold),
                UIFont.systemFont(ofSize: fontSize * 1.1, weight: .medium)
            ],
            body: UIFont.systemFont(ofSize: fontSize, weight: .regular),
            caption: UIFont.systemFont(ofSize: fontSize * 0.8, weight: .regular),
            button: UIFont.systemFont(ofSize: fontSize, weight: .medium),
            fontFamily: fontFamily
        )
    }
    
    private func extractSpacing(from rules: [CSSRule]) -> SpacingTokens {
        let baseUnit: CGFloat = 4
        
        return SpacingTokens(
            xs: baseUnit,
            sm: baseUnit * 2,
            md: baseUnit * 3,
            lg: baseUnit * 4,
            xl: baseUnit * 6,
            xxl: baseUnit * 8
        )
    }
    
    private func parseColor(from value: String) -> UIColor? {
        let cleanValue = value.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Hex colors
        if cleanValue.hasPrefix("#") {
            return UIColor(hex: cleanValue)
        }
        
        // RGB colors
        if cleanValue.hasPrefix("rgb") {
            return parseRGBColor(from: cleanValue)
        }
        
        return nil
    }
    
    private func parseRGBColor(from value: String) -> UIColor? {
        // Simple RGB parsing implementation
        return UIColor.systemBlue // Placeholder
    }
    
    private func parseFontSize(from value: String) -> CGFloat? {
        let cleanValue = value.replacingOccurrences(of: "px", with: "")
        return CGFloat(Double(cleanValue) ?? 17)
    }
}

// MARK: - UIColor Extension
extension UIColor {
    convenience init?(hex: String) {
        let hexString = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hexString).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hexString.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}