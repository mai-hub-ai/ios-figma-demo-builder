//
//  RecommendationEngine.swift
//  HotelBookingData
//
//  Created by Hunter on 2024.
//  Copyright © 2024 Hunter. All rights reserved.
//

import Foundation

/// 推荐引擎协议
public protocol RecommendationEngine {
    
    /// 基于用户需求推荐酒店
    func recommendHotels(for requirements: UserRequirements) async throws -> [HotelPackage]
    
    /// 基于用户历史行为推荐
    func recommendHotels(for userId: String) async throws -> [HotelPackage]
    
    /// 获取个性化推荐
    func getPersonalizedRecommendations(
        for requirements: UserRequirements,
        userId: String?
    ) async throws -> RecommendationResult
    
    /// 更新用户偏好
    func updateUserPreferences(userId: String, preferences: [Preference]) async throws
}

/// 推荐结果
public struct RecommendationResult {
    public let hotels: [RecommendedHotel]
    public let recommendationReasons: [String]
    public let confidenceScore: Double
    
    public init(
        hotels: [RecommendedHotel],
        recommendationReasons: [String],
        confidenceScore: Double
    ) {
        self.hotels = hotels
        self.recommendationReasons = recommendationReasons
        self.confidenceScore = confidenceScore
    }
}

/// 推荐酒店包装类
public struct RecommendedHotel {
    public let hotel: HotelPackage
    public let score: Double
    public let reasons: [RecommendationReason]
    
    public init(hotel: HotelPackage, score: Double, reasons: [RecommendationReason]) {
        self.hotel = hotel
        self.score = score
        self.reasons = reasons
    }
}

/// 推荐理由枚举
public enum RecommendationReason: String, CaseIterable {
    case highRating = "高评分"
    case goodValue = "性价比高"
    case matchesPreferences = "符合您的偏好"
    case popularChoice = "热门选择"
    case locationAdvantage = "地理位置优越"
    case facilityComplete = "设施齐全"
    case priceMatch = "价格合适"
    case seasonalPromotion = "季节性优惠"
    
    public var description: String {
        return self.rawValue
    }
}

/// 推荐引擎实现
public class DefaultRecommendationEngine: RecommendationEngine {
    
    private let repository: HotelRepository
    private var userProfiles: [String: UserProfile] = [:]
    
    public init(repository: HotelRepository) {
        self.repository = repository
    }
    
    // MARK: - RecommendationEngine 协议实现
    
    public func recommendHotels(for requirements: UserRequirements) async throws -> [HotelPackage] {
        let allHotels = try await repository.getAllHotels()
        let scoredHotels = scoreHotels(allHotels, for: requirements)
        
        // 按分数排序并返回前10个
        let sortedHotels = scoredHotels.sorted { $0.score > $1.score }
        return Array(sortedHotels.prefix(10)).map { $0.hotel }
    }
    
    public func recommendHotels(for userId: String) async throws -> [HotelPackage] {
        let userProfile = getUserProfile(for: userId)
        let requirements = convertUserProfileToRequirements(userProfile)
        return try await recommendHotels(for: requirements)
    }
    
    public func getPersonalizedRecommendations(
        for requirements: UserRequirements,
        userId: String?
    ) async throws -> RecommendationResult {
        
        let recommendedHotels = try await recommendHotels(for: requirements)
        let scoredHotels = scoreHotels(recommendedHotels, for: requirements)
        
        let recommendationReasons = generateRecommendationReasons(
            for: requirements,
            hotels: recommendedHotels
        )
        
        let confidenceScore = calculateConfidenceScore(
            for: requirements,
            hotels: scoredHotels
        )
        
        let recommendedHotelWrappers = scoredHotels.map { scoredHotel in
            RecommendedHotel(
                hotel: scoredHotel.hotel,
                score: scoredHotel.score,
                reasons: scoredHotel.reasons
            )
        }
        
        return RecommendationResult(
            hotels: recommendedHotelWrappers,
            recommendationReasons: recommendationReasons,
            confidenceScore: confidenceScore
        )
    }
    
    public func updateUserPreferences(userId: String, preferences: [Preference]) async throws {
        var profile = getUserProfile(for: userId)
        profile.preferredAmenities = Set(preferences.compactMap { preference in
            switch preference {
            case .familyFriendly: return [.pool, .restaurant]
            case .luxury: return [.spa, .gym]
            case .budget: return []
            default: return []
            }
        }.joined())
        
        userProfiles[userId] = profile
    }
    
    // MARK: - 私有辅助方法
    
    private func scoreHotels(
        _ hotels: [HotelPackage],
        for requirements: UserRequirements
    ) -> [(hotel: HotelPackage, score: Double, reasons: [RecommendationReason])] {
        
        return hotels.map { hotel in
            var score = 0.0
            var reasons: [RecommendationReason] = []
            
            // 基础评分 (0-50分)
            score += hotel.rating * 10.0
            if hotel.rating >= 4.5 {
                reasons.append(.highRating)
            }
            
            // 价格价值比 (0-30分)
            let valueScore = calculateValueScore(hotel: hotel, requirements: requirements)
            score += valueScore
            if valueScore > 20 {
                reasons.append(.goodValue)
            }
            
            // 偏好匹配度 (0-20分)
            let preferenceScore = calculatePreferenceScore(hotel: hotel, requirements: requirements)
            score += preferenceScore
            if preferenceScore > 10 {
                reasons.append(.matchesPreferences)
            }
            
            return (hotel: hotel, score: score, reasons: reasons)
        }
    }
    
    private func calculateValueScore(
        hotel: HotelPackage,
        requirements: UserRequirements
    ) -> Double {
        // 基于评分和价格的性价比计算
        let priceScore = max(0, 100 - (hotel.price / 100)) // 价格越低得分越高
        let ratingScore = hotel.rating * 20 // 评分转换为分数
        let valueRatio = (ratingScore + priceScore) / 2.0
        
        // 根据预算调整
        if let budgetRange = requirements.budgetRange {
            let budgetMultiplier = getBudgetMultiplier(for: budgetRange)
            let maxAcceptablePrice = hotel.price * budgetMultiplier
            
            if hotel.price <= maxAcceptablePrice {
                return valueRatio * 1.2 // 符合预算给予奖励
            } else {
                return valueRatio * 0.7 // 超出预算给予惩罚
            }
        }
        
        return valueRatio
    }
    
    private func calculatePreferenceScore(
        hotel: HotelPackage,
        requirements: UserRequirements
    ) -> Double {
        var score = 0.0
        var matchedCount = 0
        
        for preference in requirements.preferences {
            switch preference {
            case .luxury:
                if hotel.rating >= 4.5 && hotel.hasAmenity(.spa) {
                    score += 8.0
                    matchedCount += 1
                }
                
            case .familyFriendly:
                if hotel.hasAmenity(.pool) && hotel.hasAmenity(.restaurant) {
                    score += 6.0
                    matchedCount += 1
                }
                
            case .budget:
                if hotel.price <= 800.0 {
                    score += 5.0
                    matchedCount += 1
                }
                
            case .beach:
                // 需要地理位置信息判断
                if hotel.location.contains("海") || hotel.location.contains(" beach") {
                    score += 7.0
                    matchedCount += 1
                }
                
            case .cityCenter:
                // 需要地理位置信息判断
                if hotel.location.contains("中心") || hotel.location.contains("central") {
                    score += 6.0
                    matchedCount += 1
                }
                
            default:
                break
            }
        }
        
        // 计算平均分
        return matchedCount > 0 ? score / Double(matchedCount) : 0.0
    }
    
    private func generateRecommendationReasons(
        for requirements: UserRequirements,
        hotels: [HotelPackage]
    ) -> [String] {
        var reasons: [String] = []
        
        // 基于用户需求生成推荐理由
        if requirements.preferences.contains(.luxury) {
            reasons.append("为您推荐高品质奢华酒店")
        }
        
        if requirements.preferences.contains(.familyFriendly) {
            reasons.append("为您精选适合家庭入住的酒店")
        }
        
        if requirements.budgetRange != nil {
            reasons.append("根据您的预算范围精心筛选")
        }
        
        // 基于推荐结果生成理由
        let avgRating = hotels.reduce(0.0) { $0 + $1.rating } / Double(hotels.count)
        if avgRating >= 4.0 {
            reasons.append("推荐酒店平均评分高达 \(String(format: "%.1f", avgRating)) 分")
        }
        
        return reasons
    }
    
    private func calculateConfidenceScore(
        for requirements: UserRequirements,
        hotels: [(hotel: HotelPackage, score: Double, reasons: [RecommendationReason])]
    ) -> Double {
        guard !hotels.isEmpty else { return 0.0 }
        
        // 基于匹配度计算置信度
        let avgScore = hotels.reduce(0.0) { $0 + $1.score } / Double(hotels.count)
        let maxPossibleScore = 100.0
        let normalizedScore = avgScore / maxPossibleScore
        
        // 考虑需求的完整性
        var completenessFactor = 1.0
        if requirements.destination.isEmpty {
            completenessFactor *= 0.8
        }
        if requirements.budgetRange == nil {
            completenessFactor *= 0.9
        }
        
        return normalizedScore * completenessFactor
    }
    
    private func getUserProfile(for userId: String) -> UserProfile {
        if let existingProfile = userProfiles[userId] {
            return existingProfile
        }
        
        // 创建新的用户档案
        let newProfile = UserProfile(userId: userId)
        userProfiles[userId] = newProfile
        return newProfile
    }
    
    private func convertUserProfileToRequirements(_ profile: UserProfile) -> UserRequirements {
        // 将用户档案转换为用户需求（简化实现）
        return UserRequirements(
            destination: "",
            checkInDate: Date(),
            checkOutDate: Date().addingTimeInterval(86400 * 2), // 默认2天
            guests: 2,
            rooms: 1,
            preferences: Array(profile.preferredAmenities).compactMap { amenity in
                switch amenity {
                case .pool: return .familyFriendly
                case .spa: return .luxury
                default: return nil
                }
            }
        )
    }
    
    private func getBudgetMultiplier(for budgetRange: BudgetRange) -> Double {
        switch budgetRange {
        case .low: return 1.0
        case .medium: return 1.5
        case .high: return 2.5
        case .premium: return 5.0
        }
    }
}

/// 用户档案
private struct UserProfile {
    let userId: String
    var preferredAmenities: Set<Amenity> = []
    var bookingHistory: [HotelPackage] = []
    var searchHistory: [String] = []
    
    init(userId: String) {
        self.userId = userId
    }
}