//
//  SortingAlgorithm.swift
//  HotelBookingData
//
//  Created by Hunter on 2024.
//  Copyright © 2024 Hunter. All rights reserved.
//

import Foundation

/// 排序算法协议
public protocol SortingAlgorithm {
    
    /// 对酒店列表进行排序
    func sort(_ hotels: [HotelPackage], with context: SortingContext) -> [HotelPackage]
    
    /// 获取支持的排序选项
    func supportedSortOptions() -> [SortOption]
}

/// 排序上下文
public struct SortingContext {
    public let sortOption: SortOption
    public let ascending: Bool
    public let userRequirements: UserRequirements?
    public let scoringAlgorithm: ScoringAlgorithm?
    
    public init(
        sortOption: SortOption,
        ascending: Bool = false,
        userRequirements: UserRequirements? = nil,
        scoringAlgorithm: ScoringAlgorithm? = nil
    ) {
        self.sortOption = sortOption
        self.ascending = ascending
        self.userRequirements = userRequirements
        self.scoringAlgorithm = scoringAlgorithm
    }
}

/// 默认排序算法实现
public class DefaultSortingAlgorithm: SortingAlgorithm {
    
    public init() {}
    
    // MARK: - SortingAlgorithm 协议实现
    
    public func sort(_ hotels: [HotelPackage], with context: SortingContext) -> [HotelPackage] {
        switch context.sortOption {
        case .relevance:
            return sortByRelevance(hotels, context: context)
        case .priceLowToHigh:
            return sortByPrice(hotels, ascending: true)
        case .priceHighToLow:
            return sortByPrice(hotels, ascending: false)
        case .rating:
            return sortByRating(hotels, ascending: context.ascending)
        case .distance:
            return sortByDistance(hotels, context: context)
        }
    }
    
    public func supportedSortOptions() -> [SortOption] {
        return [.relevance, .priceLowToHigh, .priceHighToLow, .rating, .distance]
    }
    
    // MARK: - 私有排序方法
    
    private func sortByRelevance(_ hotels: [HotelPackage], context: SortingContext) -> [HotelPackage] {
        guard let requirements = context.userRequirements,
              let algorithm = context.scoringAlgorithm else {
            // 没有上下文时，默认按评分排序
            return sortByRating(hotels, ascending: false)
        }
        
        let scoringContext = ScoringContext(
            userRequirements: requirements,
            searchFilters: SearchFilters()
        )
        
        let scores = algorithm.calculateScores(for: hotels, with: scoringContext)
        
        return hotels.sorted { hotel1, hotel2 in
            let score1 = scores[hotel1] ?? 0.0
            let score2 = scores[hotel2] ?? 0.0
            return score1 > score2
        }
    }
    
    private func sortByPrice(_ hotels: [HotelPackage], ascending: Bool) -> [HotelPackage] {
        return hotels.sorted { hotel1, hotel2 in
            if ascending {
                return hotel1.price < hotel2.price
            } else {
                return hotel1.price > hotel2.price
            }
        }
    }
    
    private func sortByRating(_ hotels: [HotelPackage], ascending: Bool) -> [HotelPackage] {
        return hotels.sorted { hotel1, hotel2 in
            if ascending {
                return hotel1.rating < hotel2.rating
            } else {
                return hotel1.rating > hotel2.rating
            }
        }
    }
    
    private func sortByDistance(_ hotels: [HotelPackage], context: SortingContext) -> [HotelPackage] {
        guard let requirements = context.userRequirements else {
            // 没有用户需求时，按评分排序
            return sortByRating(hotels, ascending: false)
        }
        
        // 基于目的地关键词的距离估算排序
        return hotels.sorted { hotel1, hotel2 in
            let distance1 = estimateDistance(hotel: hotel1, to: requirements.destination)
            let distance2 = estimateDistance(hotel: hotel2, to: requirements.destination)
            return distance1 < distance2
        }
    }
    
    // MARK: - 辅助方法
    
    private func estimateDistance(hotel: HotelPackage, to destination: String) -> Double {
        let hotelLocation = hotel.location.lowercased()
        let dest = destination.lowercased()
        
        // 简化的距离估算逻辑
        if hotelLocation.contains(dest) {
            return 0.0 // 同一城市
        } else if isSameProvince(hotelLocation, destination: dest) {
            return 100.0 // 同省不同市
        } else {
            return 1000.0 // 不同省份
        }
    }
    
    private func isSameProvince(_ hotelLocation: String, destination: String) -> Bool {
        let provinces = [
            ("北京", ["北京"]),
            ("上海", ["上海"]),
            ("广东", ["广州", "深圳", "东莞", "佛山"]),
            ("浙江", ["杭州", "宁波", "温州"]),
            ("江苏", ["南京", "苏州", "无锡"]),
            ("四川", ["成都", "绵阳", "德阳"])
        ]
        
        for (province, cities) in provinces {
            let hotelInProvince = cities.contains { hotelLocation.contains($0) }
            let destInProvince = cities.contains { destination.contains($0) }
            
            if hotelInProvince && destInProvince {
                return true
            }
        }
        
        return false
    }
}

// MARK: - 多维度混合排序

/// 高级排序算法，支持多维度加权排序
public class AdvancedSortingAlgorithm: SortingAlgorithm {
    
    private let defaultAlgorithm = DefaultSortingAlgorithm()
    
    public init() {}
    
    public func sort(_ hotels: [HotelPackage], with context: SortingContext) -> [HotelPackage] {
        // 使用默认算法处理基本排序
        var sortedHotels = defaultAlgorithm.sort(hotels, with: context)
        
        // 如果需要更复杂的排序逻辑，可以在这里添加
        if context.sortOption == .relevance {
            sortedHotels = applyAdvancedRelevanceSorting(sortedHotels, context: context)
        }
        
        return sortedHotels
    }
    
    public func supportedSortOptions() -> [SortOption] {
        return defaultAlgorithm.supportedSortOptions()
    }
    
    private func applyAdvancedRelevanceSorting(
        _ hotels: [HotelPackage],
        context: SortingContext
    ) -> [HotelPackage] {
        guard let requirements = context.userRequirements else {
            return hotels
        }
        
        // 应用额外的相关性调整
        return hotels.sorted { hotel1, hotel2 in
            let relevance1 = calculateAdvancedRelevance(hotel: hotel1, requirements: requirements)
            let relevance2 = calculateAdvancedRelevance(hotel: hotel2, requirements: requirements)
            return relevance1 > relevance2
        }
    }
    
    private func calculateAdvancedRelevance(
        hotel: HotelPackage,
        requirements: UserRequirements
    ) -> Double {
        var relevance = 0.0
        
        // 偏好匹配度
        let preferenceMatches = requirements.preferences.filter { preference in
            switch preference {
            case .luxury:
                return hotel.rating >= 4.5
            case .familyFriendly:
                return hotel.hasAmenity(.pool) && hotel.hasAmenity(.restaurant)
            case .budget:
                return hotel.price <= 1000.0
            case .beach:
                return hotel.location.contains("海") || hotel.location.contains(" beach")
            case .cityCenter:
                return hotel.location.contains("中心") || hotel.location.contains(" central")
            default:
                return false
            }
        }
        
        relevance += Double(preferenceMatches.count) * 10.0
        
        // 价格适应度
        if let budgetRange = requirements.budgetRange {
            let maxPrice = getMaxPrice(for: budgetRange)
            if hotel.price <= maxPrice {
                relevance += 15.0
            } else if hotel.price <= maxPrice * 1.2 {
                relevance += 8.0
            }
        }
        
        // 基础评分
        relevance += hotel.rating * 5.0
        
        return relevance
    }
    
    private func getMaxPrice(for budgetRange: BudgetRange) -> Double {
        switch budgetRange {
        case .low: return 800.0
        case .medium: return 1500.0
        case .high: return 2500.0
        case .premium: return 5000.0
        }
    }
}