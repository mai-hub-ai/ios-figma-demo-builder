//
//  FigmaStyleConverter.swift
//  HotelBookingDemo
//
//  Created by Designer on 2024.
//

import UIKit

public class FigmaStyleConverter {
    
    // MARK: - Color Conversion
    public static func convertColor(from cssValue: String) -> UIColor? {
        let trimmedValue = cssValue.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Handle hex colors
        if trimmedValue.hasPrefix("#") {
            return UIColor(hex: trimmedValue)
        }
        
        // Handle rgb/rgba values
        if trimmedValue.hasPrefix("rgb") {
            return parseRGBString(trimmedValue)
        }
        
        // Handle hsl/hsla values
        if trimmedValue.hasPrefix("hsl") {
            return parseHSLString(trimmedValue)
        }
        
        // Handle named colors
        return parseNamedColor(trimmedValue)
    }
    
    private static func parseRGBString(_ rgbString: String) -> UIColor? {
        // Remove rgb()/rgba() wrapper
        let cleanString = rgbString.replacingOccurrences(of: "rgb(", with: "")
            .replacingOccurrences(of: "rgba(", with: "")
            .replacingOccurrences(of: ")", with: "")
        
        let components = cleanString.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        
        guard components.count >= 3 else { return nil }
        
        guard let red = Float(components[0]),
              let green = Float(components[1]),
              let blue = Float(components[2]) else { return nil }
        
        let alpha: Float = components.count > 3, let a = Float(components[3]) ? a : 1.0
        
        return UIColor(
            red: CGFloat(red / 255.0),
            green: CGFloat(green / 255.0),
            blue: CGFloat(blue / 255.0),
            alpha: CGFloat(alpha)
        )
    }
    
    private static func parseHSLString(_ hslString: String) -> UIColor? {
        // Remove hsl()/hsla() wrapper
        let cleanString = hslString.replacingOccurrences(of: "hsl(", with: "")
            .replacingOccurrences(of: "hsla(", with: "")
            .replacingOccurrences(of: ")", with: "")
        
        let components = cleanString.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        
        guard components.count >= 3 else { return nil }
        
        // Parse hue (degrees)
        let hueString = components[0].replacingOccurrences(of: "deg", with: "")
        guard let hue = Float(hueString) else { return nil }
        
        // Parse saturation (%)
        let saturationString = components[1].replacingOccurrences(of: "%", with: "")
        guard let saturation = Float(saturationString) else { return nil }
        
        // Parse lightness (%)
        let lightnessString = components[2].replacingOccurrences(of: "%", with: "")
        guard let lightness = Float(lightnessString) else { return nil }
        
        let alpha: Float = components.count > 3, let a = Float(components[3]) ? a : 1.0
        
        return UIColor(
            hue: CGFloat(hue / 360.0),
            saturation: CGFloat(saturation / 100.0),
            brightness: CGFloat(lightness / 100.0),
            alpha: CGFloat(alpha)
        )
    }
    
    private static func parseNamedColor(_ colorName: String) -> UIColor? {
        switch colorName.lowercased() {
        case "black": return .black
        case "white": return .white
        case "red": return .red
        case "green": return .green
        case "blue": return .blue
        case "yellow": return .yellow
        case "orange": return .orange
        case "purple": return .purple
        case "gray", "grey": return .gray
        case "lightgray", "lightgrey": return .lightGray
        case "darkgray", "darkgrey": return .darkGray
        case "clear": return .clear
        default: return nil
        }
    }
    
    // MARK: - Font Conversion
    public static func convertFont(from cssFont: String) -> UIFont? {
        let components = cssFont.components(separatedBy: " ")
        guard components.count >= 2 else { return nil }
        
        // Extract font size
        let fontSizeString = components.first { $0.contains("px") || $0.contains("pt") }
        guard let sizeStr = fontSizeString else { return nil }
        
        let fontSize = Float(sizeStr.replacingOccurrences(of: "px", with: "").replacingOccurrences(of: "pt", with: ""))
        guard let size = fontSize else { return nil }
        
        // Determine font weight
        let fontWeight = components.first { isFontWeightKeyword($0) }
        let weight = fontWeight.flatMap { convertFontWeight(from: $0) } ?? .regular
        
        // Determine font family
        let fontFamily = components.last { !$0.contains("px") && !$0.contains("pt") && !isFontWeightKeyword($0) }
        
        if let family = fontFamily, family != "\(size)px" {
            return UIFont(name: family, size: CGFloat(size)) ?? UIFont.systemFont(ofSize: CGFloat(size), weight: weight)
        }
        
        return UIFont.systemFont(ofSize: CGFloat(size), weight: weight)
    }
    
    private static func isFontWeightKeyword(_ keyword: String) -> Bool {
        let fontWeightKeywords = ["thin", "extralight", "light", "regular", "medium", "semibold", "bold", "extrabold", "black",
                                 "100", "200", "300", "400", "500", "600", "700", "800", "900"]
        return fontWeightKeywords.contains(keyword.lowercased())
    }
    
    private static func convertFontWeight(from cssWeight: String) -> UIFont.Weight? {
        switch cssWeight.lowercased() {
        case "thin", "100": return .thin
        case "extralight", "200": return .ultraLight
        case "light", "300": return .light
        case "regular", "400": return .regular
        case "medium", "500": return .medium
        case "semibold", "600": return .semibold
        case "bold", "700": return .bold
        case "extrabold", "800": return .heavy
        case "black", "900": return .black
        default: return nil
        }
    }
    
    // MARK: - Layout Conversion
    public static func convertSpacing(from cssValue: String) -> CGFloat? {
        let trimmedValue = cssValue.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Handle pixel values
        if trimmedValue.hasSuffix("px") {
            let numericString = trimmedValue.replacingOccurrences(of: "px", with: "")
            return CGFloat(Float(numericString) ?? 0)
        }
        
        // Handle point values
        if trimmedValue.hasSuffix("pt") {
            let numericString = trimmedValue.replacingOccurrences(of: "pt", with: "")
            return CGFloat(Float(numericString) ?? 0)
        }
        
        // Handle rem/em values (assuming 1rem = 16px)
        if trimmedValue.hasSuffix("rem") || trimmedValue.hasSuffix("em") {
            let numericString = trimmedValue.replacingOccurrences(of: "rem", with: "").replacingOccurrences(of: "em", with: "")
            guard let value = Float(numericString) else { return nil }
            return CGFloat(value * 16) // 1rem = 16px
        }
        
        // Handle percentage (relative to container)
        if trimmedValue.hasSuffix("%") {
            // This would need context of container size
            return nil
        }
        
        // Handle numeric values directly
        if let numericValue = Float(trimmedValue) {
            return CGFloat(numericValue)
        }
        
        return nil
    }
    
    // MARK: - Border Radius Conversion
    public static func convertBorderRadius(from cssValue: String) -> CGFloat? {
        return convertSpacing(from: cssValue)
    }
    
    // MARK: - Text Alignment Conversion
    public static func convertTextAlign(from cssValue: String) -> NSTextAlignment {
        switch cssValue.lowercased().trimmingCharacters(in: .whitespaces) {
        case "left": return .left
        case "center": return .center
        case "right": return .right
        case "justify": return .justified
        default: return .natural
        }
    }
    
    // MARK: - Flexbox-like Layout Conversion
    public static func convertFlexDirection(from cssValue: String) -> NSLayoutConstraint.Axis {
        switch cssValue.lowercased().trimmingCharacters(in: .whitespaces) {
        case "row", "row-reverse": return .horizontal
        case "column", "column-reverse": return .vertical
        default: return .vertical
        }
    }
    
    public static func convertJustifyContent(from cssValue: String) -> UIStackView.Alignment {
        switch cssValue.lowercased().trimmingCharacters(in: .whitespaces) {
        case "flex-start", "start": return .leading
        case "center": return .center
        case "flex-end", "end": return .trailing
        case "space-between": return .fill
        case "space-around", "space-evenly": return .fill
        default: return .fill
        }
    }
    
    public static func convertAlignItems(from cssValue: String) -> UIStackView.Alignment {
        switch cssValue.lowercased().trimmingCharacters(in: .whitespaces) {
        case "flex-start", "start": return .leading
        case "center": return .center
        case "flex-end", "end": return .trailing
        case "stretch": return .fill
        case "baseline": return .firstBaseline
        default: return .fill
        }
    }
    
    // MARK: - Day 2 Enhancements: Layout Properties Conversion
    public static func convertLayoutProperties(_ properties: [String: String]) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        
        for (property, value) in properties {
            if let constraint = convertLayoutProperty(property, value: value) {
                constraints.append(constraint)
            }
        }
        
        return constraints
    }
    
    private static func convertLayoutProperty(_ property: String, value: String) -> NSLayoutConstraint? {
        let trimmedValue = value.trimmingCharacters(in: .whitespacesAndNewlines)
        
        switch property.lowercased() {
        case "width":
            if let width = convertSpacing(from: trimmedValue) {
                // This would need a view reference to create actual constraint
                return nil // Placeholder - needs view context
            }
        case "height":
            if let height = convertSpacing(from: trimmedValue) {
                return nil // Placeholder - needs view context
            }
        case "margin", "margin-top", "margin-bottom", "margin-left", "margin-right":
            // Margin conversion would need superview context
            return nil
        case "padding", "padding-top", "padding-bottom", "padding-left", "padding-right":
            // Padding conversion for container views
            return nil
        default:
            return nil
        }
        
        return nil
    }
    
    // MARK: - Component Type Mapping
    public static func mapComponentType(from cssClass: String) -> ComponentType {
        let lowercasedClass = cssClass.lowercased()
        
        // Button mappings
        if lowercasedClass.contains("button") || lowercasedClass.contains("btn") {
            return .button
        }
        
        // Label/text mappings
        if lowercasedClass.contains("label") || lowercasedClass.contains("text") || lowercasedClass.contains("title") {
            return .label
        }
        
        // Card/container mappings
        if lowercasedClass.contains("card") || lowercasedClass.contains("container") || lowercasedClass.contains("box") {
            return .card
        }
        
        // Image mappings
        if lowercasedClass.contains("image") || lowercasedClass.contains("img") || lowercasedClass.contains("icon") {
            return .imageView
        }
        
        // Input mappings
        if lowercasedClass.contains("input") || lowercasedClass.contains("field") || lowercasedClass.contains("textfield") {
            return .textField
        }
        
        // Default to generic view
        return .view
    }
    
    // MARK: - Design Tokens Extraction
    public static func extractDesignTokens(from css: String) -> DesignTokens {
        var tokens = DesignTokens()
        
        // Extract color tokens
        let colorPattern = #"color:\s*([^;]+);"#
        let colorRegex = try? NSRegularExpression(pattern: colorPattern, options: [])
        let colorMatches = colorRegex?.matches(in: css, options: [], range: NSRange(css.startIndex..., in: css)) ?? []
        
        for match in colorMatches {
            if let range = Range(match.range(at: 1), in: css) {
                let colorValue = String(css[range]).trimmingCharacters(in: .whitespaces)
                // Process color tokens
            }
        }
        
        // Extract font tokens
        let fontPattern = #"font(?:-family)?:\s*([^;]+);"#
        let fontRegex = try? NSRegularExpression(pattern: fontPattern, options: [])
        let fontMatches = fontRegex?.matches(in: css, options: [], range: NSRange(css.startIndex..., in: css)) ?? []
        
        for match in fontMatches {
            if let range = Range(match.range(at: 1), in: css) {
                let fontValue = String(css[range]).trimmingCharacters(in: .whitespaces)
                // Process font tokens
            }
        }
        
        // Extract spacing tokens
        let spacingPattern = #"(?:margin|padding):\s*([^;]+);"#
        let spacingRegex = try? NSRegularExpression(pattern: spacingPattern, options: [])
        let spacingMatches = spacingRegex?.matches(in: css, options: [], range: NSRange(css.startIndex..., in: css)) ?? []
        
        for match in spacingMatches {
            if let range = Range(match.range(at: 1), in: css) {
                let spacingValue = String(css[range]).trimmingCharacters(in: .whitespaces)
                // Process spacing tokens
            }
        }
        
        return tokens
    }
    
    // MARK: - Advanced CSS Property Support
    public static func convertBoxShadow(from cssValue: String) -> NSShadow? {
        // Parse box-shadow: offset-x offset-y blur-radius spread-radius color
        let components = cssValue.components(separatedBy: " ").filter { !$0.isEmpty }
        
        guard components.count >= 3 else { return nil }
        
        guard let offsetX = convertSpacing(from: components[0]),
              let offsetY = convertSpacing(from: components[1]),
              let blurRadius = convertSpacing(from: components[2]) else { return nil }
        
        let color: UIColor
        if components.count > 3, let parsedColor = convertColor(from: components.last ?? "") {
            color = parsedColor
        } else {
            color = .black
        }
        
        return NSShadow(
            offset: CGSize(width: offsetX, height: offsetY),
            blurRadius: blurRadius,
            color: color.withAlphaComponent(0.3)
        )
    }
    
    public static func convertTransform(from cssValue: String) -> CGAffineTransform? {
        // Parse transform functions like translate(), scale(), rotate()
        if cssValue.contains("translate") {
            let translatePattern = #"translate\(\s*([^,]+)\s*,\s*([^)]+)\s*\)"#
            let regex = try? NSRegularExpression(pattern: translatePattern, options: [])
            
            if let match = regex?.firstMatch(in: cssValue, options: [], range: NSRange(cssValue.startIndex..., in: cssValue)),
               let xRange = Range(match.range(at: 1), in: cssValue),
               let yRange = Range(match.range(at: 2), in: cssValue) {
                
                let xValue = String(cssValue[xRange])
                let yValue = String(cssValue[yRange])
                
                if let x = convertSpacing(from: xValue), let y = convertSpacing(from: yValue) {
                    return CGAffineTransform(translationX: x, y: y)
                }
            }
        }
        
        return nil
    }
    
    public static func convertZIndex(from cssValue: String) -> Int? {
        return Int(cssValue.trimmingCharacters(in: .whitespaces))
    }
}

// MARK: - Supporting Types
public enum ComponentType {
    case view
    case label
    case button
    case imageView
    case stackView
    case scrollView
    case collectionView
    case tableView
    case textField
    case textView
    case card
}

public struct DesignTokens {
    public var colors: [String: UIColor] = [:]
    public var fonts: [String: UIFont] = [:]
    public var spacing: [String: CGFloat] = [:]
    public var borderRadius: [String: CGFloat] = [:]
    
    public init() {}
}