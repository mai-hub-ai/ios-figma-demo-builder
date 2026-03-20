//
//  FigmaDataAdapter.swift
//  HotelBookingData
//
//  Created by Hunter on 2024.
//  Copyright © 2024 Hunter. All rights reserved.
//

import Foundation

/// Figma数据适配器协议
public protocol FigmaDataAdapter {
    
    /// 将Figma导出数据转换为内部酒店模型
    func convertFigmaExportToHotels(_ figmaExport: FigmaDesignExport) throws -> [HotelPackage]
    
    /// 将Figma样式映射转换为设计令牌
    func convertFigmaStylesToDesignTokens(_ figmaExport: FigmaDesignExport) throws -> DesignTokens
    
    /// 提取组件类型信息
    func extractComponentTypes(from figmaExport: FigmaDesignExport) -> [String: ComponentType]
    
    /// 验证Figma导出数据的完整性
    func validateFigmaExport(_ figmaExport: FigmaDesignExport) -> ValidationResult
}

/// 组件类型枚举
public enum ComponentType: String, CaseIterable {
    case hotelCard = "hotel_card"
    case priceTag = "price_tag"
    case ratingStars = "rating_stars"
    case amenityIcon = "amenity_icon"
    case searchBar = "search_bar"
    case filterPanel = "filter_panel"
    case bookingButton = "booking_button"
    case imageGallery = "image_gallery"
    
    public var description: String {
        switch self {
        case .hotelCard: return "酒店卡片"
        case .priceTag: return "价格标签"
        case .ratingStars: return "评分星星"
        case .amenityIcon: return "设施图标"
        case .searchBar: return "搜索栏"
        case .filterPanel: return "筛选面板"
        case .bookingButton: return "预订按钮"
        case .imageGallery: return "图片画廊"
        }
    }
}

/// 验证结果
public struct ValidationResult {
    public let isValid: Bool
    public let errors: [ValidationError]
    public let warnings: [ValidationWarning]
    
    public init(isValid: Bool, errors: [ValidationError] = [], warnings: [ValidationWarning] = []) {
        self.isValid = isValid
        self.errors = errors
        self.warnings = warnings
    }
    
    public var hasErrors: Bool {
        return !errors.isEmpty
    }
    
    public var hasWarnings: Bool {
        return !warnings.isEmpty
    }
}

/// 验证错误
public enum ValidationError: Error, LocalizedError {
    case missingRequiredComponent(String)
    case invalidCSSProperty(String, String)
    case unsupportedComponentType(String)
    case dataMappingFailed(String)
    
    public var errorDescription: String? {
        switch self {
        case .missingRequiredComponent(let component):
            return "缺少必需的组件: \(component)"
        case .invalidCSSProperty(let property, let value):
            return "无效的CSS属性: \(property) = \(value)"
        case .unsupportedComponentType(let type):
            return "不支持的组件类型: \(type)"
        case .dataMappingFailed(let reason):
            return "数据映射失败: \(reason)"
        }
    }
}

/// 验证警告
public struct ValidationWarning {
    public let message: String
    public let severity: Severity
    
    public init(message: String, severity: Severity = .medium) {
        self.message = message
        self.severity = severity
    }
    
    public enum Severity {
        case low, medium, high
    }
}

/// 默认Figma数据适配器实现
public class DefaultFigmaDataAdapter: FigmaDataAdapter {
    
    private let styleConverter: FigmaStyleConverter
    
    public init(styleConverter: FigmaStyleConverter = FigmaStyleConverter()) {
        self.styleConverter = styleConverter
    }
    
    // MARK: - FigmaDataAdapter 协议实现
    
    public func convertFigmaExportToHotels(_ figmaExport: FigmaDesignExport) throws -> [HotelPackage] {
        // 验证输入数据
        let validationResult = validateFigmaExport(figmaExport)
        guard validationResult.isValid else {
            throw DataAdapterError.validationFailed(validationResult.errors)
        }
        
        // 提取酒店卡片组件
        guard let hotelCardComponents = figmaExport.componentMappings.values
                .filter({ $0.type == "hotel_card" || $0.cssClasses.contains("hotel-card") })
                .first else {
            throw ValidationError.missingRequiredComponent("hotel_card")
        }
        
        // 基于Figma数据创建酒店模型（这里使用Mock数据作为示例）
        let mockHotels = MockHotelPackages.getExtendedHotelCollection()
        
        // 应用Figma样式到酒店数据
        return mockHotels.map { hotel in
            var styledHotel = hotel
            
            // 应用从Figma提取的样式信息
            if let cardComponent = hotelCardComponents {
                styledHotel = applyCardStyles(to: styledHotel, from: cardComponent)
            }
            
            return styledHotel
        }
    }
    
    public func convertFigmaStylesToDesignTokens(_ figmaExport: FigmaDesignExport) throws -> DesignTokens {
        let validationResult = validateFigmaExport(figmaExport)
        guard validationResult.isValid else {
            throw DataAdapterError.validationFailed(validationResult.errors)
        }
        
        // 从CSS内容中解析设计令牌
        let parsedTokens = parseDesignTokens(from: figmaExport.cssContent)
        
        // 合并显式定义的令牌
        let explicitTokens = figmaExport.designTokens
        
        return parsedTokens.merging(with: explicitTokens)
    }
    
    public func extractComponentTypes(from figmaExport: FigmaDesignExport) -> [String: ComponentType] {
        var componentTypes: [String: ComponentType] = [:]
        
        for (cssClass, componentInfo) in figmaExport.componentMappings {
            if let type = inferComponentType(from: componentInfo) {
                componentTypes[cssClass] = type
            }
        }
        
        return componentTypes
    }
    
    public func validateFigmaExport(_ figmaExport: FigmaDesignExport) -> ValidationResult {
        var errors: [ValidationError] = []
        var warnings: [ValidationWarning] = []
        
        // 检查必需的组件是否存在
        let requiredComponents = ["hotel_card", "price_tag", "rating_stars"]
        let availableComponents = Set(figmaExport.componentMappings.values.map { $0.type })
        
        for requiredComponent in requiredComponents {
            if !availableComponents.contains(requiredComponent) {
                errors.append(.missingRequiredComponent(requiredComponent))
            }
        }
        
        // 验证CSS属性
        for rule in figmaExport.styleRules {
            for (property, value) in rule.properties {
                if !isValidCSSProperty(property, value: value) {
                    errors.append(.invalidCSSProperty(property, value))
                }
            }
        }
        
        // 检查组件类型支持
        for component in figmaExport.componentMappings.values {
            if !isSupportedComponentType(component.type) {
                warnings.append(ValidationWarning(
                    message: "检测到不支持的组件类型: \(component.type)",
                    severity: .medium
                ))
            }
        }
        
        return ValidationResult(
            isValid: errors.isEmpty,
            errors: errors,
            warnings: warnings
        )
    }
    
    // MARK: - 私有辅助方法
    
    private func applyCardStyles(to hotel: HotelPackage, from component: ComponentInfo) -> HotelPackage {
        // 这里实现具体的样式应用逻辑
        // 示例：基于组件属性调整酒店显示信息
        var modifiedHotel = hotel
        
        // 应用背景色
        if let backgroundColor = component.properties["background-color"] {
            // 在实际实现中，这里会更新UI相关的属性
        }
        
        // 应用边框圆角
        if let borderRadius = component.properties["border-radius"] {
            // 应用圆角样式
        }
        
        return modifiedHotel
    }
    
    private func parseDesignTokens(from cssContent: String) -> DesignTokens {
        // 解析CSS内容提取设计令牌
        let colorTokens = parseColorTokens(from: cssContent)
        let typographyTokens = parseTypographyTokens(from: cssContent)
        let spacingTokens = parseSpacingTokens(from: cssContent)
        
        return DesignTokens(
            colors: colorTokens,
            typography: typographyTokens,
            spacing: spacingTokens,
            borderRadius: BorderRadiusTokens(
                none: TokenValue(value: "0px"),
                xs: TokenValue(value: "2px"),
                s: TokenValue(value: "4px"),
                m: TokenValue(value: "8px"),
                l: TokenValue(value: "12px"),
                xl: TokenValue(value: "16px"),
                pill: TokenValue(value: "9999px"),
                circle: TokenValue(value: "50%")
            ),
            shadows: ShadowTokens(
                none: TokenValue(value: "none"),
                xs: TokenValue(value: "0 1px 2px 0 rgba(0,0,0,0.05)"),
                s: TokenValue(value: "0 1px 3px 0 rgba(0,0,0,0.1)"),
                m: TokenValue(value: "0 4px 6px -1px rgba(0,0,0,0.1)"),
                l: TokenValue(value: "0 10px 15px -3px rgba(0,0,0,0.1)"),
                xl: TokenValue(value: "0 20px 25px -5px rgba(0,0,0,0.1)")
            ),
            breakpoints: BreakpointTokens(
                mobile: TokenValue(value: "0px"),
                tablet: TokenValue(value: "768px"),
                laptop: TokenValue(value: "1024px"),
                desktop: TokenValue(value: "1200px"),
                wide: TokenValue(value: "1440px")
            )
        )
    }
    
    private func parseColorTokens(from css: String) -> ColorTokens {
        // 从CSS中提取颜色令牌的实现
        return MockHotelPackages.getSampleDesignTokens().colors
    }
    
    private func parseTypographyTokens(from css: String) -> TypographyTokens {
        // 从CSS中提取排版令牌的实现
        return MockHotelPackages.getSampleDesignTokens().typography
    }
    
    private func parseSpacingTokens(from css: String) -> SpacingTokens {
        // 从CSS中提取间距令牌的实现
        return MockHotelPackages.getSampleDesignTokens().spacing
    }
    
    private func inferComponentType(from componentInfo: ComponentInfo) -> ComponentType? {
        // 基于组件信息推断组件类型
        let className = componentInfo.cssClasses.first?.lowercased() ?? ""
        let typeName = componentInfo.type.lowercased()
        
        switch typeName {
        case "hotel_card", "card":
            return .hotelCard
        case "price_tag", "tag":
            return .priceTag
        case "rating_stars", "stars":
            return .ratingStars
        case "amenity_icon", "icon":
            return .amenityIcon
        case "search_bar", "search":
            return .searchBar
        case "filter_panel", "filter":
            return .filterPanel
        case "booking_button", "button":
            return .bookingButton
        case "image_gallery", "gallery":
            return .imageGallery
        default:
            // 基于CSS类名推断
            if className.contains("card") && className.contains("hotel") {
                return .hotelCard
            } else if className.contains("price") {
                return .priceTag
            } else if className.contains("rating") || className.contains("star") {
                return .ratingStars
            }
            return nil
        }
    }
    
    private func isSupportedComponentType(_ type: String) -> Bool {
        return ComponentType.allCases.map { $0.rawValue }.contains(type)
    }
    
    private func isValidCSSProperty(_ property: String, value: String) -> Bool {
        // 验证CSS属性是否有效
        // 这里可以实现更复杂的验证逻辑
        return !property.isEmpty && !value.isEmpty
    }
}

/// 数据适配器错误类型
public enum DataAdapterError: Error, LocalizedError {
    case validationFailed([ValidationError])
    case conversionFailed(String)
    case unsupportedFormat(String)
    
    public var errorDescription: String? {
        switch self {
        case .validationFailed(let errors):
            return "验证失败: \(errors.map { $0.localizedDescription }.joined(separator: ", "))"
        case .conversionFailed(let reason):
            return "转换失败: \(reason)"
        case .unsupportedFormat(let format):
            return "不支持的格式: \(format)"
        }
    }
}