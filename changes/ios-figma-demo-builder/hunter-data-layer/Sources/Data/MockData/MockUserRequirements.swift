//
//  MockUserRequirements.swift
//  HotelBookingData
//
//  Created by Hunter on 2024.
//  Copyright © 2024 Hunter. All rights reserved.
//

import Foundation

/// Mock用户需求数据提供者
public class MockUserRequirements {
    
    /// 获取典型的用户需求示例
    public static func getTypicalRequirements() -> [UserRequirements] {
        return [
            createBusinessTraveler(),
            createFamilyVacation(),
            createCoupleRomanticTrip(),
            createBudgetConsciousTraveler(),
            createLuxurySeeker()
        ]
    }
    
    /// 根据场景创建用户需求
    public static func createRequirements(for scenario: TravelScenario) -> UserRequirements {
        switch scenario {
        case .business:
            return createBusinessTraveler()
        case .family:
            return createFamilyVacation()
        case .couple:
            return createCoupleRomanticTrip()
        case .budget:
            return createBudgetConsciousTraveler()
        case .luxury:
            return createLuxurySeeker()
        }
    }
    
    // MARK: - 私有工厂方法
    
    private static func createBusinessTraveler() -> UserRequirements {
        let calendar = Calendar.current
        let today = Date()
        let checkInDate = calendar.date(byAdding: .day, value: 3, to: today)!
        let checkOutDate = calendar.date(byAdding: .day, value: 5, to: checkInDate)!
        
        return UserRequirements(
            destination: "北京市",
            checkInDate: checkInDate,
            checkOutDate: checkOutDate,
            guests: 1,
            rooms: 1,
            preferences: [.businessCenter, .cityCenter],
            budgetRange: .medium,
            specialNeeds: [.earlyCheckin, .lateCheckout]
        )
    }
    
    private static func createFamilyVacation() -> UserRequirements {
        let calendar = Calendar.current
        let today = Date()
        let checkInDate = calendar.date(byAdding: .day, value: 14, to: today)!
        let checkOutDate = calendar.date(byAdding: .day, value: 7, to: checkInDate)!
        
        return UserRequirements(
            destination: "三亚市",
            checkInDate: checkInDate,
            checkOutDate: checkOutDate,
            guests: 4,
            rooms: 2,
            preferences: [.beach, .familyFriendly, .pool],
            budgetRange: .medium,
            specialNeeds: [.childCare, .connectingRooms]
        )
    }
    
    private static func createCoupleRomanticTrip() -> UserRequirements {
        let calendar = Calendar.current
        let today = Date()
        let checkInDate = calendar.date(byAdding: .day, value: 21, to: today)!
        let checkOutDate = calendar.date(byAdding: .day, value: 3, to: checkInDate)!
        
        return UserRequirements(
            destination: "杭州市",
            checkInDate: checkInDate,
            checkOutDate: checkOutDate,
            guests: 2,
            rooms: 1,
            preferences: [.luxury, .spa, .restaurant],
            budgetRange: .high,
            specialNeeds: [.quietRoom, .nonSmokingRoom]
        )
    }
    
    private static func createBudgetConsciousTraveler() -> UserRequirements {
        let calendar = Calendar.current
        let today = Date()
        let checkInDate = calendar.date(byAdding: .day, value: 7, to: today)!
        let checkOutDate = calendar.date(byAdding: .day, value: 2, to: checkInDate)!
        
        return UserRequirements(
            destination: "成都市",
            checkInDate: checkInDate,
            checkOutDate: checkOutDate,
            guests: 1,
            rooms: 1,
            preferences: [.budget, .cityCenter],
            budgetRange: .low,
            specialNeeds: []
        )
    }
    
    private static func createLuxurySeeker() -> UserRequirements {
        let calendar = Calendar.current
        let today = Date()
        let checkInDate = calendar.date(byAdding: .day, value: 30, to: today)!
        let checkOutDate = calendar.date(byAdding: .day, value: 5, to: checkInDate)!
        
        return UserRequirements(
            destination: "上海市",
            checkInDate: checkInDate,
            checkOutDate: checkOutDate,
            guests: 2,
            rooms: 1,
            preferences: [.luxury, .spa, .fineDining, .cityCenter],
            budgetRange: .premium,
            specialNeeds: [.lateCheckout, .groundFloor]
        )
    }
}

/// 旅行场景枚举
public enum TravelScenario {
    case business     // 商务出行
    case family       // 家庭度假
    case couple       // 情侣浪漫之旅
    case budget       // 预算敏感型旅客
    case luxury       // 奢华追求者
}

/// Mock搜索过滤器示例
public class MockSearchFilters {
    
    public static func getCommonFilters() -> [SearchFilters] {
        return [
            createBusinessFilter(),
            createFamilyFilter(),
            createBudgetFilter(),
            createLuxuryFilter()
        ]
    }
    
    private static func createBusinessFilter() -> SearchFilters {
        return SearchFilters(
            minRating: 4.0,
            maxPrice: 1500.0,
            requiredAmenities: [.wifi, .businessCenter],
            roomCapacity: 2,
            sortBy: .priceLowToHigh
        )
    }
    
    private static func createFamilyFilter() -> SearchFilters {
        return SearchFilters(
            minRating: 4.2,
            maxPrice: 2000.0,
            requiredAmenities: [.pool, .restaurant, .childCare],
            roomCapacity: 4,
            sortBy: .rating
        )
    }
    
    private static func createBudgetFilter() -> SearchFilters {
        return SearchFilters(
            minRating: 3.5,
            maxPrice: 800.0,
            requiredAmenities: [.wifi, .breakfast],
            roomCapacity: 2,
            sortBy: .priceLowToHigh
        )
    }
    
    private static func createLuxuryFilter() -> SearchFilters {
        return SearchFilters(
            minRating: 4.5,
            requiredAmenities: [.spa, .gym, .fineDining, .pool],
            sortBy: .relevance
        )
    }
}