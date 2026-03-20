//
//  FigmaDesignExport.swift
//  HotelBookingData
//
//  Created by Hunter on 2024.
//  Copyright © 2024 Hunter. All rights reserved.
//

import Foundation

/// Figma设计导出数据模型
public struct FigmaDesignExport: Codable, Equatable {
    public let cssContent: String                    // CSS内容
    public let componentMappings: [String: ComponentInfo] // 组件映射
    public let designTokens: DesignTokens            // 设计令牌
    public let exportMetadata: ExportMetadata        // 导出元数据
    public let styleRules: [StyleRule]               // 样式规则
    
    public init(
        cssContent: String,
        componentMappings: [String: ComponentInfo],
        designTokens: DesignTokens,
        exportMetadata: ExportMetadata,
        styleRules: [StyleRule] = []
    ) {
        self.cssContent = cssContent
        self.componentMappings = componentMappings
        self.designTokens = designTokens
        self.exportMetadata = exportMetadata
        self.styleRules = styleRules
    }
    
    /// 获取所有组件类型
    public var componentTypes: [String] {
        return Array(Set(componentMappings.values.map { $0.type }))
    }
    
    /// 根据CSS类名查找组件信息
    public func getComponentInfo(for cssClass: String) -> ComponentInfo? {
        return componentMappings[cssClass]
    }
    
    /// 获取特定类型的组件
    public func getComponents(ofType type: String) -> [ComponentInfo] {
        return componentMappings.values.filter { $0.type == type }
    }
}

/// 组件信息
public struct ComponentInfo: Codable, Equatable {
    public let id: String              // 组件ID
    public let name: String            // 组件名称
    public let type: String            // 组件类型
    public let cssClasses: [String]    // CSS类名
    public let properties: [String: String] // 属性映射
    public let children: [ComponentInfo]   // 子组件
    public let layoutInfo: LayoutInfo?     // 布局信息
    
    public init(
        id: String,
        name: String,
        type: String,
        cssClasses: [String],
        properties: [String: String] = [:],
        children: [ComponentInfo] = [],
        layoutInfo: LayoutInfo? = nil
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.cssClasses = cssClasses
        self.properties = properties
        self.children = children
        self.layoutInfo = layoutInfo
    }
}

/// 布局信息
public struct LayoutInfo: Codable, Equatable {
    public let width: String?
    public let height: String?
    public let margin: String?
    public let padding: String?
    public let position: String?
    public let flexDirection: String?
    
    public init(
        width: String? = nil,
        height: String? = nil,
        margin: String? = nil,
        padding: String? = nil,
        position: String? = nil,
        flexDirection: String? = nil
    ) {
        self.width = width
        self.height = height
        self.margin = margin
        self.padding = padding
        self.position = position
        self.flexDirection = flexDirection
    }
}

/// 导出元数据
public struct ExportMetadata: Codable, Equatable {
    public let exportTime: Date
    public let figmaFileVersion: String
    public let exportFormat: String
    public let sourceFileId: String
    public let exportSettings: [String: String]
    
    public init(
        exportTime: Date = Date(),
        figmaFileVersion: String,
        exportFormat: String = "css",
        sourceFileId: String,
        exportSettings: [String: String] = [:]
    ) {
        self.exportTime = exportTime
        self.figmaFileVersion = figmaFileVersion
        self.exportFormat = exportFormat
        self.sourceFileId = sourceFileId
        self.exportSettings = exportSettings
    }
}

/// 样式规则
public struct StyleRule: Codable, Equatable {
    public let selector: String           // CSS选择器
    public let properties: [String: String] // CSS属性
    public let mediaQuery: String?        // 媒体查询
    public let specificity: Int           // 特异性
    
    public init(
        selector: String,
        properties: [String: String],
        mediaQuery: String? = nil,
        specificity: Int = 0
    ) {
        self.selector = selector
        self.properties = properties
        self.mediaQuery = mediaQuery
        self.specificity = specificity
    }
}