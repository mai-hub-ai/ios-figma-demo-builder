//
//  ScoringAlgorithm.swift
//  HotelBookingData
//
//  Created by Hunter on 2024.
//  Copyright © 2024 Hunter. All rights reserved.
//

import Foundation

/// 评分算法协议
public protocol ScoringAlgorithm {
    
    /// 计算酒店综合评分
    func calculateScore(for hotel: HotelPackage, with context: ScoringContext) -> Double
    
    /// 计算多个酒店的评分
    func calculateScores(
        for hotels: [HotelPackage],
        with context: ScoringContext
    ) -> [HotelPackage: Double]
}

/// 评分上下文
public struct ScoringContext {
    public let userRequirements: UserRequirements
    public let searchFilters: SearchFilters
    public let weights: ScoringWeights
    public let currentDate: Date
    
    public init(
        userRequirements: UserRequirements,
        searchFilters: SearchFilters,
        weights: ScoringWeights = ScoringWeights.default,
        currentDate: Date = Date()
    ) {
        self.userRequirements = userRequirements
        self.searchFilters = searchFilters
        self.weights = weights
        self.currentDate = currentDate
    }
}

/// 评分权重配置
public struct ScoringWeights {
    public let rating: Double          // 评分权重
    public let price: Double           // 价格权重
    public let amenities: Double       // 设施权重
    public let location: Double        // 位置权重
    public let popularity: Double      // 热门度权重
    public let recency: Double         // 时效性权重
    
    public static let `default` = ScoringWeights(
        rating: 0.3,
        price: 0.25,
        amenities: 0.2,
        location: 0.15,
        popularity: 0.05,
        recency: 0.05
    )
    
    public static let priceSensitive = ScoringWeights(
        rating: 0.2,
        price: 0.4,
        amenities: 0.15,
        location: 0.15,
        popularity: 0.05,
        recency: 0.05
    )
    
    public static let qualityFocused = ScoringWeights(
        rating: 0.5,
        price: 0.15,
        amenities: 0.2,
        location: 0.1,
        popularity: 0.03,
        recency: 0.02
    )
}

/// 默认评分算法实现
public class DefaultScoringAlgorithm: ScoringAlgorithm {
    
    public init() {}
    
    // MARK: - ScoringAlgorithm 协议实现
    
    public func calculateScore(for hotel: HotelPackage, with context: ScoringContext) -> Double {
        var totalScore = 0.0
        
        // 1. 评分因子 (0-30分)
        let ratingScore = calculateRatingScore(hotel: hotel, weight: context.weights.rating)
        totalScore += ratingScore
        
        // 2. 价格因子 (0-25分)
        let priceScore = calculatePriceScore(hotel: hotel, context: context, weight: context.weights.price)
        totalScore += priceScore
        
        // 3. 设施因子 (0-20分)
        let amenitiesScore = calculateAmenitiesScore(hotel: hotel, context: context, weight: context.weights.amenities)
        totalScore += amenitiesScore
        
        // 4. 位置因子 (0-15分)
        let locationScore = calculateLocationScore(hotel: hotel, context: context, weight: context.weights.location)
        totalScore += locationScore
        
        // 5. 热门度因子 (0-5分)
        let popularityScore = calculatePopularityScore(hotel: hotel, weight: context.weights.popularity)
        totalScore += popularityScore
        
        // 6. 时效性因子 (0-5分)
        let recencyScore = calculateRecencyScore(hotel: hotel, context: context, weight: context.weights.recency)
        totalScore += recencyScore
        
        return totalScore
    }
    
    public func calculateScores(
        for hotels: [HotelPackage],
        with context: ScoringContext
    ) -> [HotelPackage: Double] {
        return hotels.reduce(into: [:]) { result, hotel in
            result[hotel] = calculateScore(for: hotel, with: context)
        }
    }
    
    // MARK: - 私有评分计算方法
    
    private func calculateRatingScore(hotel: HotelPackage, weight: Double) -> Double {
        // 评分映射：将1-5分映射到0-30分
        return (hotel.rating / 5.0) * 30.0 * weight
    }
    
    private func calculatePriceScore(hotel: HotelPackage, context: ScoringContext, weight: Double) -> Double {
        let userBudget = getUserBudget(context: context)
        let priceRatio = hotel.price / userBudget
        
        // 价格评分逻辑：
        // - 价格 ≤ 预算 × 0.8：满分
        // - 预算 × 0.8 < 价格 ≤ 预算：递减评分
        // - 价格 > 预算：0分
        
        if priceRatio <= 0.8 {
            return 25.0 * weight // 完全符合预算
        } else if priceRatio <= 1.0 {
            // 在预算范围内，按比例递减
            let ratio = (1.0 - priceRatio) / 0.2 // 0.8-1.0映射到1-0
            return 25.0 * ratio * weight
        } else {
            return 0.0 // 超出预算
        }
    }
    
    private func calculateAmenitiesScore(hotel: HotelPackage, context: ScoringContext, weight: Double) -> Double {
        let requiredAmenities = context.searchFilters.requiredAmenities
        let hotelAmenities = Set(hotel.amenities)
        
        if requiredAmenities.isEmpty {
            // 没有特定要求时，按设施数量评分
            let amenityCount = Double(hotelAmenities.count)
            let maxAmenities = 10.0 // 假设最多10个设施
            return (amenityCount / maxAmenities) * 20.0 * weight
        } else {
            // 有特定要求时，按匹配度评分
            let matchedCount = Double(requiredAmenities.filter { hotelAmenities.contains($0) }.count)
            let requiredCount = Double(requiredAmenities.count)
            return (matchedCount / requiredCount) * 20.0 * weight
        }
    }
    
    private func calculateLocationScore(hotel: HotelPackage, context: ScoringContext, weight: Double) -> Double {
        let destination = context.userRequirements.destination.lowercased()
        
        // 基于关键词匹配的位置评分
        var score = 0.0
        
        if hotel.location.lowercased().contains(destination) {
            score += 10.0 // 完全匹配
        } else if hotel.name.lowercased().contains(destination) {
            score += 8.0 // 名称匹配
        } else if isNearbyLocation(hotel.location, destination: destination) {
            score += 6.0 // 附近位置
        }
        
        return score * weight
    }
    
    private func calculatePopularityScore(hotel: HotelPackage, weight: Double) -> Double {
        // 基于评分和评论数量的受欢迎程度
        let ratingScore = (hotel.rating / 5.0) * 3.0 // 0-3分
        let reviewScore = min(Double(hotel.images.count) * 0.5, 2.0) // 0-2分
        
        return (ratingScore + reviewScore) * weight
    }
    
    private func calculateRecencyScore(hotel: HotelPackage, context: ScoringContext, weight: Double) -> Double {
        // 基于酒店信息更新时间的时效性评分
        // 这里简化处理，假设所有酒店都是最新的
        return 5.0 * weight
    }
    
    // MARK: - 辅助方法
    
    private func getUserBudget(context: ScoringContext) -> Double {
        // 根据用户预算范围确定预算值
        if let budgetRange = context.userRequirements.budgetRange {
            switch budgetRange {
            case .low: return 800.0
            case .medium: return 1500.0
            case .high: return 2500.0
            case .premium: return 5000.0
            }
        }
        
        // 如果没有指定预算，使用中等预算
        return 1500.0
    }
    
    private func isNearbyLocation(_ hotelLocation: String, destination: String) -> Bool {
        let nearbyKeywords = ["附近", "周边", "临近", "靠近"]
        return nearbyKeywords.contains { hotelLocation.contains($0) }
    }
}