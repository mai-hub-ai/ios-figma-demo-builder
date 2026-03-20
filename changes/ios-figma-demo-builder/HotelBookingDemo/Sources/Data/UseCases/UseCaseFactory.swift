//
//  UseCaseFactory.swift
//  HotelBookingData
//
//  Created by Hunter on 2024.
//  Copyright © 2024 Hunter. All rights reserved.
//

import Foundation

/// UseCase工厂类
public class UseCaseFactory {
    
    private static var shared: UseCaseFactory?
    private let repositoryFactory: RepositoryFactory
    private var useCases: [String: AnyObject] = [:]
    
    /// 获取单例实例
    public static func shared() -> UseCaseFactory {
        if shared == nil {
            shared = UseCaseFactory(repositoryFactory: RepositoryFactory.shared())
        }
        return shared!
    }
    
    /// 初始化方法
    public init(repositoryFactory: RepositoryFactory) {
        self.repositoryFactory = repositoryFactory
    }
    
    /// 获取酒店搜索用例
    public func getHotelSearchUseCase() -> HotelSearchUseCase {
        let key = "hotel_search"
        
        if let existingUseCase = useCases[key] as? HotelSearchUseCase {
            return existingUseCase
        }
        
        let repository = repositoryFactory.getDefaultRepository()
        let searchUseCase = DefaultHotelSearchUseCase(repository: repository)
        useCases[key] = searchUseCase
        
        return searchUseCase
    }
    
    /// 获取推荐引擎
    public func getRecommendationEngine() -> RecommendationEngine {
        let key = "recommendation_engine"
        
        if let existingEngine = useCases[key] as? RecommendationEngine {
            return existingEngine
        }
        
        let repository = repositoryFactory.getDefaultRepository()
        let engine = DefaultRecommendationEngine(repository: repository)
        useCases[key] = engine
        
        return engine
    }
    
    /// 获取统计分析用例
    public func getAnalyticsUseCase() -> AnalyticsUseCase {
        let key = "analytics_use_case"
        
        if let existingUseCase = useCases[key] as? AnalyticsUseCase {
            return existingUseCase
        }
        
        let repository = repositoryFactory.getDefaultRepository()
        let analyticsUseCase = DefaultAnalyticsUseCase(repository: repository)
        useCases[key] = analyticsUseCase
        
        return analyticsUseCase
    }
    
    /// 清除缓存的UseCase
    public func clearCache() {
        useCases.removeAll()
    }
    
    /// 移除特定UseCase
    public func removeUseCase<T>(type: T.Type) {
        let key = String(describing: type)
        useCases.removeValue(forKey: key)
    }
}

// MARK: - 统计分析用例

/// 统计分析用例协议
public protocol AnalyticsUseCase {
    
    /// 获取搜索统计数据
    func getSearchStatistics(for requirements: UserRequirements) async throws -> SearchResultStatistics
    
    /// 获取热门搜索关键词
    func getPopularSearchKeywords(limit: Int) async throws -> [String]
    
    /// 获取用户行为分析
    func getUserBehaviorAnalysis(userId: String) async throws -> UserBehaviorReport
}

/// 用户行为报告
public struct UserBehaviorReport {
    public let userId: String
    public let totalSearches: Int
    public let favoriteDestinations: [String]
    public let preferredPriceRange: (min: Double, max: Double)
    public let mostUsedAmenities: [Amenity]
    public let bookingConversionRate: Double
    
    public init(
        userId: String,
        totalSearches: Int,
        favoriteDestinations: [String],
        preferredPriceRange: (min: Double, max: Double),
        mostUsedAmenities: [Amenity],
        bookingConversionRate: Double
    ) {
        self.userId = userId
        self.totalSearches = totalSearches
        self.favoriteDestinations = favoriteDestinations
        self.preferredPriceRange = preferredPriceRange
        self.mostUsedAmenities = mostUsedAmenities
        self.bookingConversionRate = bookingConversionRate
    }
}

/// 默认统计分析用例实现
public class DefaultAnalyticsUseCase: AnalyticsUseCase {
    
    private let repository: HotelRepository
    
    public init(repository: HotelRepository) {
        self.repository = repository
    }
    
    public func getSearchStatistics(for requirements: UserRequirements) async throws -> SearchResultStatistics {
        let searchUseCase = UseCaseFactory.shared().getHotelSearchUseCase()
        let hotels = try await searchUseCase.searchHotels(for: requirements)
        
        guard !hotels.isEmpty else {
            throw AnalyticsError.noDataAvailable
        }
        
        // 计算统计数据
        let totalResults = hotels.count
        let averagePrice = hotels.reduce(0.0) { $0 + $1.price } / Double(totalResults)
        let averageRating = hotels.reduce(0.0) { $0 + $1.rating } / Double(totalResults)
        
        let prices = hotels.map { $0.price }
        let priceRange = (min: prices.min() ?? 0, max: prices.max() ?? 0)
        
        // 计算评分分布
        var ratingDistribution: [Double: Int] = [:]
        for hotel in hotels {
            let roundedRating = round(hotel.rating * 2) / 2 // 精确到0.5
            ratingDistribution[roundedRating, default: 0] += 1
        }
        
        return SearchResultStatistics(
            totalResults: totalResults,
            averagePrice: averagePrice,
            averageRating: averageRating,
            priceRange: priceRange,
            ratingDistribution: ratingDistribution
        )
    }
    
    public func getPopularSearchKeywords(limit: Int) async throws -> [String] {
        // 基于Mock数据生成热门关键词
        let commonDestinations = [
            "北京", "上海", "广州", "深圳", "成都",
            "杭州", "西安", "厦门", "重庆", "苏州"
        ]
        
        let commonAmenities = [
            "wifi", "游泳池", "健身房", "餐厅", "水疗",
            "早餐", "空调", "商务中心"
        ]
        
        var keywords: [String] = []
        keywords.append(contentsOf: commonDestinations)
        keywords.append(contentsOf: commonAmenities)
        
        return Array(keywords.prefix(limit))
    }
    
    public func getUserBehaviorAnalysis(userId: String) async throws -> UserBehaviorReport {
        // 基于用户ID生成行为分析报告
        let favoriteDestinations = ["北京", "上海", "杭州"]
        let priceRange = (min: 800.0, max: 2000.0)
        let amenities: [Amenity] = [.wifi, .restaurant, .breakfast]
        let conversionRate = 0.15 // 15%转化率
        
        return UserBehaviorReport(
            userId: userId,
            totalSearches: 25,
            favoriteDestinations: favoriteDestinations,
            preferredPriceRange: priceRange,
            mostUsedAmenities: amenities,
            bookingConversionRate: conversionRate
        )
    }
}

/// 统计分析错误类型
public enum AnalyticsError: Error, LocalizedError {
    case noDataAvailable
    case insufficientData
    
    public var errorDescription: String? {
        switch self {
        case .noDataAvailable:
            return "暂无可用数据"
        case .insufficientData:
            return "数据不足，无法生成分析报告"
        }
    }
}