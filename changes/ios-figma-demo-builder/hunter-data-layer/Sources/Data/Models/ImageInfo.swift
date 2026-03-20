//
//  ImageInfo.swift
//  HotelBookingData
//
//  Created by Hunter on 2024.
//  Copyright © 2024 Hunter. All rights reserved.
//

import Foundation

/// 图片信息模型
public struct ImageInfo: Codable, Equatable {
    public let url: String              // 图片URL
    public let altText: String?         // 替代文本
    public let width: Int?              // 宽度
    public let height: Int?             // 高度
    public let imageType: ImageType     // 图片类型
    public let isPrimary: Bool          // 是否为主图
    public let tags: [String]           // 标签
    
    public init(
        url: String,
        altText: String? = nil,
        width: Int? = nil,
        height: Int? = nil,
        imageType: ImageType = .general,
        isPrimary: Bool = false,
        tags: [String] = []
    ) {
        self.url = url
        self.altText = altText
        self.width = width
        self.height = height
        self.imageType = imageType
        self.isPrimary = isPrimary
        self.tags = tags
    }
    
    /// 是否为有效图片URL
    public var isValidURL: Bool {
        return !url.isEmpty && (url.hasPrefix("http://") || url.hasPrefix("https://"))
    }
    
    /// 图片尺寸描述
    public var sizeDescription: String? {
        guard let w = width, let h = height else { return nil }
        return "\(w)×\(h)"
    }
}

/// 图片类型枚举
public enum ImageType: String, CaseIterable, Codable {
    case exterior = "外观"
    case lobby = "大堂"
    case room = "客房"
    case bathroom = "浴室"
    case restaurant = "餐厅"
    case pool = "泳池"
    case gym = "健身房"
    case spa = "水疗"
    case businessCenter = "商务中心"
    case general = "通用"
    
    public var description: String {
        return self.rawValue
    }
}