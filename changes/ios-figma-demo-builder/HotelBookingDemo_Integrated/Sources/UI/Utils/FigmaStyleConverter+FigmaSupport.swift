//
//  FigmaStyleConverter.swift
//  HotelBookingDemo
//
//  Figma CSS样式转换器 - Day 2增强版
//

import UIKit

/// Figma CSS样式转换器
class FigmaStyleConverter {
    
    /// CSS规则模型
    struct CSSRule {
        let selector: String
        let properties: [String: String]
    }
    
    /// 设计令牌模型
    struct DesignTokens {
        let colors: [String: UIColor]
        let fonts: [String: UIFont]
        let spacing: [String: CGFloat]
    }
    
    // MARK: - 公共方法
    
    /// 解析CSS字符串并转换为设计令牌
    /// - Parameter cssContent: CSS内容字符串
    /// - Returns: 解析后的设计令牌
    func parseCSSToTokens(_ cssContent: String) -> DesignTokens {
        let rules = parseCSSRules(cssContent)
        return convertRulesToTokens(rules)
    }
    
    /// 将CSS属性映射到UIKit约束
    /// - Parameters:
    ///   - properties: CSS属性字典
    ///   - view: 目标视图
    /// - Returns: 生成的约束数组
    func convertLayoutProperties(_ properties: [String: String], for view: UIView) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        
        // 处理宽度
        if let widthStr = properties["width"], let width = parseDimension(widthStr) {
            constraints.append(view.widthAnchor.constraint(equalToConstant: width))
        }
        
        // 处理高度
        if let heightStr = properties["height"], let height = parseDimension(heightStr) {
            constraints.append(view.heightAnchor.constraint(equalToConstant: height))
        }
        
        // 处理边距
        if let marginStr = properties["margin"] {
            let margins = parseMargin(marginStr)
            // 这里可以添加具体的约束逻辑
        }
        
        // 处理内边距
        if let paddingStr = properties["padding"] {
            let padding = parsePadding(paddingStr)
            // 这里可以添加具体的约束逻辑
        }
        
        return constraints
    }
    
    /// 根据CSS类名映射组件类型
    /// - Parameter cssClass: CSS类名
    /// - Returns: 对应的组件类型
    func mapComponentType(from cssClass: String) -> ComponentType {
        switch cssClass.lowercased() {
        case let cls where cls.contains("button"):
            return .button
        case let cls where cls.contains("card"):
            return .card
        case let cls where cls.contains("input") || cls.contains("field"):
            return .textField
        case let cls where cls.contains("label") || cls.contains("text"):
            return .label
        default:
            return .custom
        }
    }
    
    /// 提取设计令牌
    /// - Parameter css: CSS内容
    /// - Returns: 设计令牌对象
    func extractDesignTokens(from css: String) -> DesignTokens {
        return parseCSSToTokens(css)
    }
    
    // MARK: - 私有方法
    
    private func parseCSSRules(_ cssContent: String) -> [CSSRule] {
        var rules: [CSSRule] = []
        // 简化的CSS解析逻辑
        return rules
    }
    
    private func convertRulesToTokens(_ rules: [CSSRule]) -> DesignTokens {
        var colors: [String: UIColor] = [:]
        var fonts: [String: UIFont] = [:]
        var spacing: [String: CGFloat] = [:]
        
        // 解析规则并转换为令牌
        for rule in rules {
            for (property, value) in rule.properties {
                switch property {
                case "color", "background-color":
                    if let color = parseColor(value) {
                        colors[property] = color
                    }
                case "font-family":
                    if let font = parseFontFamily(value) {
                        fonts[property] = font
                    }
                case "font-size":
                    if let fontSize = parseFloat(value) {
                        fonts["\(property)_\(fontSize)"] = UIFont.systemFont(ofSize: fontSize)
                    }
                case "margin", "padding":
                    if let dimension = parseDimension(value) {
                        spacing[property] = dimension
                    }
                default:
                    break
                }
            }
        }
        
        return DesignTokens(colors: colors, fonts: fonts, spacing: spacing)
    }
    
    private func parseColor(_ colorString: String) -> UIColor? {
        if colorString.hasPrefix("#") {
            let hexString = String(colorString.dropFirst())
            var rgbValue: UInt64 = 0
            Scanner(string: hexString).scanHexInt64(&rgbValue)
            
            let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
            let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
            
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
        return nil
    }
    
    private func parseFontFamily(_ fontFamily: String) -> UIFont? {
        return UIFont(name: fontFamily.replacingOccurrences(of: "\"", with: ""), size: 16.0)
    }
    
    private func parseFloat(_ floatString: String) -> CGFloat? {
        let cleanString = floatString.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        return CGFloat(Double(cleanString) ?? 0.0)
    }
    
    private func parseDimension(_ dimensionString: String) -> CGFloat? {
        guard let number = parseFloat(dimensionString) else { return nil }
        
        if dimensionString.contains("px") {
            return number
        } else if dimensionString.contains("em") {
            return number * 16.0 // 假设基础字体大小为16px
        }
        return number
    }
    
    private func parseMargin(_ marginString: String) -> UIEdgeInsets {
        let values = marginString.components(separatedBy: " ")
            .compactMap { parseFloat($0) }
        
        switch values.count {
        case 1: // 所有边相同
            let value = values[0]
            return UIEdgeInsets(top: value, left: value, bottom: value, right: value)
        case 2: // 垂直 水平
            let vertical = values[0]
            let horizontal = values[1]
            return UIEdgeInsets(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
        case 3: // 上 水平 下
            return UIEdgeInsets(top: values[0], left: values[1], bottom: values[2], right: values[1])
        case 4: // 上 右 下 左
            return UIEdgeInsets(top: values[0], left: values[3], bottom: values[2], right: values[1])
        default:
            return .zero
        }
    }
    
    private func parsePadding(_ paddingString: String) -> UIEdgeInsets {
        return parseMargin(paddingString) // 使用相同的解析逻辑
    }
}

/// 组件类型枚举
enum ComponentType {
    case button
    case card
    case textField
    case label
    case custom(String)
}

extension ComponentType: CustomStringConvertible {
    var description: String {
        switch self {
        case .button: return "Button"
        case .card: return "Card"
        case .textField: return "TextField"
        case .label: return "Label"
        case .custom(let name): return "Custom(\(name))"
        }
    }
}