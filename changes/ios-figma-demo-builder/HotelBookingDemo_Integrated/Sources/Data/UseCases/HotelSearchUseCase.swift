//
//  HotelSearchUseCase.swift
//  HotelBookingData
//
//  Created by Hunter on 2024.
//  Copyright © 2024 Hunter. All rights reserved.
//

import Foundation

/// 酒店搜索用例协议
public protocol HotelSearchUseCase {
    
    /// 根据用户需求搜索酒店
    func searchHotels(for requirements: UserRequirements) async throws -> [HotelPackage]
    
    /// 根据搜索过滤器搜索酒店
    func searchHotels(with filters: SearchFilters) async throws -> [HotelPackage]
    
    /// 根据关键词搜索酒店
    func searchHotels(keyword: String) async throws -> [HotelPackage]
    
    /// 获取热门目的地
    func getPopularDestinations() async throws -> [String]
    
    /// 获取推荐酒店
    func getRecommendedHotels(for requirements: UserRequirements) async throws -> [HotelPackage]
}

/// 搜索结果统计信息
public struct SearchResultStatistics {
    public let totalResults: Int
    public let averagePrice: Double
    public let averageRating: Double
    public let priceRange: (min: Double, max: Double)
    public let ratingDistribution: [Double: Int] // 评分分布
    
    public init(
        totalResults: Int,
        averagePrice: Double,
        averageRating: Double,
        priceRange: (min: Double, max: Double),
        ratingDistribution: [Double: Int]
    ) {
        self.totalResults = totalResults
        self.averagePrice = averagePrice
        self.averageRating = averageRating
        self.priceRange = priceRange
        self.ratingDistribution = ratingDistribution
    }
}

/// 酒店搜索用例实现
public class DefaultHotelSearchUseCase: HotelSearchUseCase {
    
    private let repository: HotelRepository
    
    public init(repository: HotelRepository) {
        self.repository = repository
    }
    
    // MARK: - HotelSearchUseCase 协议实现
    
    public func searchHotels(for requirements: UserRequirements) async throws -> [HotelPackage] {
        // 验证用户需求
        guard requirements.isValid else {
            throw SearchError.invalidRequirements
        }
        
        // 构建搜索过滤器
        let filters = buildFilters(from: requirements)
        
        // 执行搜索
        var results = try await repository.searchHotels(with: filters)
        
        // 应用额外的业务逻辑过滤
        results = applyBusinessLogicFilters(results, for: requirements)
        
        // 根据用户偏好进行排序
        results = sortResults(results, for: requirements)
        
        return results
    }
    
    public func searchHotels(with filters: SearchFilters) async throws -> [HotelPackage] {
        return try await repository.searchHotels(with: filters)
    }
    
    public func searchHotels(keyword: String) async throws -> [HotelPackage] {
        // 支持模糊搜索：酒店名称、位置、描述
        let allHotels = try await repository.getAllHotels()
        
        return allHotels.filter { hotel in
            hotel.name.localizedCaseInsensitiveContains(keyword) ||
            hotel.location.localizedCaseInsensitiveContains(keyword) ||
            hotel.description.localizedCaseInsensitiveContains(keyword)
        }
    }
    
    public func getPopularDestinations() async throws -> [String] {
        let allHotels = try await repository.getAllHotels()
        
        // 统计各城市的酒店数量
        let cityCounts = Dictionary(grouping: allHotels) { hotel -> String in
            // 从地址中提取城市名
            return extractCity(from: hotel.location)
        }
        
        // 按酒店数量排序，返回前10个城市
        return cityCounts
            .sorted { $0.value.count > $1.value.count }
            .prefix(10)
            .map { $0.key }
    }
    
    public func getRecommendedHotels(for requirements: UserRequirements) async throws -> [HotelPackage] {
        let allHotels = try await searchHotels(for: requirements)
        
        // 基于用户偏好和历史行为进行推荐
        let recommended = allHotels.prefix(10) // 暂时返回前10个
        return Array(recommended)
    }
    
    // MARK: - 私有辅助方法
    
    private func buildFilters(from requirements: UserRequirements) -> SearchFilters {
        var requiredAmenities: [Amenity] = []
        
        // 根据用户偏好转换为设施需求
        for preference in requirements.preferences {
            switch preference {
            case .beach:
                break // 海滩偏好需要地理位置信息
            case .cityCenter:
                break // 市中心偏好需要地理位置信息
            case .mountain:
                break // 山区偏好需要地理位置信息
            case .familyFriendly:
                requiredAmenities.append(.restaurant)
                requiredAmenities.append(.pool)
            case .luxury:
                requiredAmenities.append(.spa)
                requiredAmenities.append(.gym)
            case .budget:
                break // 预算型不需要特殊设施
            case .petFriendly:
                break // 宠物友好需要特殊处理
            case .smoking:
                requiredAmenities.append(.smoking) // 这个设施可能不存在
            }
        }
        
        // 根据预算确定价格上限
        var maxPrice: Double?
        if let budgetRange = requirements.budgetRange {
            // 这里可以根据预算范围设定价格上限
            switch budgetRange {
            case .low:
                maxPrice = 800.0
            case .medium:
                maxPrice = 1500.0
            case .high:
                maxPrice = 2500.0
            case .premium:
                maxPrice = 5000.0
            }
        }
        
        return SearchFilters(
            minRating: 3.0, // 最低接受评分
            maxPrice: maxPrice,
            requiredAmenities: requiredAmenities,
            roomCapacity: requirements.guests,
            sortBy: .relevance
        )
    }
    
    private func applyBusinessLogicFilters(
        _ hotels: [HotelPackage],
        for requirements: UserRequirements
    ) -> [HotelPackage] {
        var filteredHotels = hotels
        
        // 根据入住天数调整筛选
        if requirements.stayDuration > 7 {
            // 长住可能需要额外考虑月租优惠等
        }
        
        // 根据特殊需求过滤
        for specialNeed in requirements.specialNeeds {
            switch specialNeed {
            case .wheelchairAccessible:
                // 需要无障碍设施信息
                break
            case .childCare:
                // 需要儿童看护服务信息
                break
            default:
                break
            }
        }
        
        return filteredHotels
    }
    
    private func sortResults(
        _ hotels: [HotelPackage],
        for requirements: UserRequirements
    ) -> [HotelPackage] {
        // 基于用户偏好的个性化排序
        return hotels.sorted { hotel1, hotel2 in
            let score1 = calculateHotelScore(hotel1, for: requirements)
            let score2 = calculateHotelScore(hotel2, for: requirements)
            return score1 > score2
        }
    }
    
    private func calculateHotelScore(
        _ hotel: HotelPackage,
        for requirements: UserRequirements
    ) -> Double {
        var score = 0.0
        
        // 评分权重
        score += hotel.rating * 10.0
        
        // 价格因素（符合预算的给予加分）
        if let budgetRange = requirements.budgetRange {
            let budgetMultiplier = getBudgetMultiplier(for: budgetRange)
            if hotel.price <= hotel.price * budgetMultiplier {
                score += 5.0
            }
        }
        
        // 偏好匹配度
        let matchedPreferences = requirements.preferences.filter { preference in
            switch preference {
            case .luxury:
                return hotel.rating >= 4.5
            case .familyFriendly:
                return hotel.hasAmenity(.pool) && hotel.hasAmenity(.restaurant)
            case .budget:
                return hotel.price <= 800.0
            default:
                return true
            }
        }
        score += Double(matchedPreferences.count) * 3.0
        
        // 设施匹配度
        let matchedAmenities = Set(requirements.preferences.compactMap { preference in
            switch preference {
            case .familyFriendly: return [.pool, .restaurant]
            case .luxury: return [.spa, .gym]
            default: return []
            }
        }.joined())
        
        let hotelAmenities = Set(hotel.amenities)
        let intersection = matchedAmenities.intersection(hotelAmenities)
        score += Double(intersection.count) * 2.0
        
        return score
    }
    
    private func getBudgetMultiplier(for budgetRange: BudgetRange) -> Double {
        switch budgetRange {
        case .low: return 1.0
        case .medium: return 1.5
        case .high: return 2.5
        case .premium: return 5.0
        }
    }
    
    private func extractCity(from location: String) -> String {
        // 简单的城市提取逻辑
        if location.contains("北京市") { return "北京" }
        if location.contains("上海市") { return "上海" }
        if location.contains("广州市") { return "广州" }
        if location.contains("深圳市") { return "深圳" }
        if location.contains("成都市") { return "成都" }
        if location.contains("杭州市") { return "杭州" }
        if location.contains("西安市") { return "西安" }
        if location.contains("厦门市") { return "厦门" }
        if location.contains("重庆市") { return "重庆" }
        if location.contains("苏州市") { return "苏州" }
        return "其他"
    }
}

/// 搜索错误类型
public enum SearchError: Error, LocalizedError {
    case invalidRequirements
    case noResultsFound
    case searchTimeout
    
    public var errorDescription: String? {
        switch self {
        case .invalidRequirements:
            return "用户需求参数无效"
        case .noResultsFound:
            return "未找到符合条件的酒店"
        case .searchTimeout:
            return "搜索超时，请稍后重试"
        }
    }
}