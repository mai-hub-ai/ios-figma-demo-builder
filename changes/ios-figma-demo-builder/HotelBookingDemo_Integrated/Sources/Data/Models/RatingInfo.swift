//
//  RatingInfo.swift
//  HotelBookingData
//
//  Created by Hunter on 2024.
//  Copyright © 2024 Hunter. All rights reserved.
//

import Foundation

/// 评分信息模型
public struct RatingInfo: Codable, Equatable {
    public let overallRating: Double           // 总体评分 (1-5)
    public let reviewCount: Int                // 评论总数
    public let cleanliness: Double?            // 清洁度评分
    public let service: Double?                // 服务评分
    public let location: Double?               // 位置评分
    public let facilities: Double?             // 设施评分
    public let valueForMoney: Double?          // 性价比评分
    public let recentRating: Double?           // 近期评分
    public let ratingBreakdown: [StarRating]   // 星级分布
    
    public init(
        overallRating: Double,
        reviewCount: Int,
        cleanliness: Double? = nil,
        service: Double? = nil,
        location: Double? = nil,
        facilities: Double? = nil,
        valueForMoney: Double? = nil,
        recentRating: Double? = nil,
        ratingBreakdown: [StarRating] = []
    ) {
        self.overallRating = overallRating
        self.reviewCount = reviewCount
        self.cleanliness = cleanliness
        self.service = service
        self.location = location
        self.facilities = facilities
        self.valueForMoney = valueForMoney
        self.recentRating = recentRating
        self.ratingBreakdown = ratingBreakdown
    }
    
    /// 获取评分显示字符串
    public var displayRating: String {
        return String(format: "%.1f", overallRating)
    }
    
    /// 评分等级
    public var ratingLevel: RatingLevel {
        if overallRating >= 4.5 { return .excellent }
        if overallRating >= 4.0 { return .veryGood }
        if overallRating >= 3.0 { return .good }
        if overallRating >= 2.0 { return .fair }
        return .poor
    }
    
    /// 是否为高评分
    public var isHighRated: Bool {
        return overallRating >= 4.0
    }
    
    /// 平均单项评分
    public var averageSubRating: Double? {
        let subRatings = [cleanliness, service, location, facilities, valueForMoney].compactMap { $0 }
        guard !subRatings.isEmpty else { return nil }
        return subRatings.reduce(0, +) / Double(subRatings.count)
    }
}

/// 评分等级枚举
public enum RatingLevel: String, CaseIterable {
    case excellent = "优秀"
    case veryGood = "很好"
    case good = "好"
    case fair = "一般"
    case poor = "差"
    
    public var description: String {
        return self.rawValue
    }
    
    public var minRating: Double {
        switch self {
        case .excellent: return 4.5
        case .veryGood: return 4.0
        case .good: return 3.0
        case .fair: return 2.0
        case .poor: return 0.0
        }
    }
}

/// 星级分布
public struct StarRating: Codable, Equatable {
    public let stars: Int      // 星级 (1-5)
    public let count: Int      // 该星级的评论数
    public let percentage: Double // 占比百分比
    
    public init(stars: Int, count: Int, percentage: Double) {
        self.stars = stars
        self.count = count
        self.percentage = percentage
    }
}