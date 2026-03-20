//
//  UserRequirements.swift
//  HotelBookingData
//
//  Created by Hunter on 2024.
//  Copyright © 2024 Hunter. All rights reserved.
//

import Foundation

/// 用户需求数据模型
public struct UserRequirements: Codable, Equatable {
    public let destination: String
    public let checkInDate: Date
    public let checkOutDate: Date
    public let guests: Int
    public let rooms: Int
    public let preferences: [Preference]
    public let budgetRange: BudgetRange?
    public let specialNeeds: [SpecialNeed]
    
    public init(
        destination: String,
        checkInDate: Date,
        checkOutDate: Date,
        guests: Int,
        rooms: Int,
        preferences: [Preference],
        budgetRange: BudgetRange? = nil,
        specialNeeds: [SpecialNeed] = []
    ) {
        self.destination = destination
        self.checkInDate = checkInDate
        self.checkOutDate = checkOutDate
        self.guests = guests
        self.rooms = rooms
        self.preferences = preferences
        self.budgetRange = budgetRange
        self.specialNeeds = specialNeeds
    }
    
    /// 计算住宿天数
    public var stayDuration: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: checkInDate, to: checkOutDate)
        return components.day ?? 0
    }
    
    /// 检查是否有特定偏好
    public func hasPreference(_ preference: Preference) -> Bool {
        return preferences.contains(preference)
    }
    
    /// 验证需求的有效性
    public var isValid: Bool {
        return !destination.isEmpty &&
               checkOutDate > checkInDate &&
               guests > 0 &&
               rooms > 0 &&
               guests >= rooms
    }
    
    /// 获取总价预算范围（如果指定了预算）
    public func totalPriceRange(for hotelPrice: Double) -> (min: Double, max: Double)? {
        guard let budgetRange = budgetRange else { return nil }
        let minTotal = hotelPrice * Double(stayDuration) * Double(rooms)
        let maxTotal = minTotal * budgetRange.multiplier
        return (min: minTotal, max: maxTotal)
    }
}

/// 预算范围枚举
public enum BudgetRange: String, CaseIterable, Codable {
    case low = "经济型"      // 0.7-1.0倍
    case medium = "舒适型"   // 1.0-1.5倍
    case high = "豪华型"     // 1.5-2.5倍
    case premium = "顶级奢华" // 2.5-5.0倍
    
    /// 价格乘数范围
    public var multiplier: Double {
        switch self {
        case .low: return 1.0
        case .medium: return 1.5
        case .high: return 2.5
        case .premium: return 5.0
        }
    }
    
    /// 获取显示名称
    public var displayName: String {
        return self.rawValue
    }
}

/// 特殊需求枚举
public enum SpecialNeed: String, CaseIterable, Codable {
    case wheelchairAccessible = "轮椅通道"
    case childCare = "儿童看护"
    case lateCheckout = "延迟退房"
    case earlyCheckin = "提前入住"
    case smokingRoom = "吸烟房"
    case nonSmokingRoom = "无烟房"
    case groundFloor = "一楼房间"
    case quietRoom = "安静房间"
    case connectingRooms = "连通房"
    
    public var displayName: String {
        return self.rawValue
    }
}

/// 搜索结果过滤条件
public struct SearchFilters: Codable, Equatable {
    public let minRating: Double
    public let maxPrice: Double?
    public let requiredAmenities: [Amenity]
    public let roomCapacity: Int?
    public let sortBy: SortOption
    
    public init(
        minRating: Double = 0.0,
        maxPrice: Double? = nil,
        requiredAmenities: [Amenity] = [],
        roomCapacity: Int? = nil,
        sortBy: SortOption = .relevance
    ) {
        self.minRating = minRating
        self.maxPrice = maxPrice
        self.requiredAmenities = requiredAmenities
        self.roomCapacity = roomCapacity
        self.sortBy = sortBy
    }
}

/// 排序选项
public enum SortOption: String, CaseIterable, Codable {
    case relevance = "相关度"
    case priceLowToHigh = "价格从低到高"
    case priceHighToLow = "价格从高到低"
    case rating = "评分"
    case distance = "距离"
    
    public var displayName: String {
        return self.rawValue
    }
}