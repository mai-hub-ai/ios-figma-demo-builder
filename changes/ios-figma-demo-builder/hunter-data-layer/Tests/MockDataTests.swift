//
//  MockDataTests.swift
//  HotelBookingDataTests
//
//  Created by Hunter on 2024.
//  Copyright © 2024 Hunter. All rights reserved.
//

import XCTest
@testable import HotelBookingData

final class MockDataTests: XCTestCase {
    
    func testMockHotelPackagesCount() {
        // When
        let hotels = MockHotelPackages.getAllHotels()
        
        // Then
        XCTAssertGreaterThan(hotels.count, 0, "应该有酒店数据")
        print("基础酒店数量: \(hotels.count)")
    }
    
    func testExtendedHotelCollection() {
        // When
        let extendedHotels = MockHotelPackages.getExtendedHotelCollection()
        
        // Then
        XCTAssertGreaterThanOrEqual(extendedHotels.count, 100, "扩展酒店集合应该至少包含100个样本")
        print("扩展酒店总数: \(extendedHotels.count)")
    }
    
    func testHotelByID() {
        // Given
        let hotelID = "hotel_001"
        
        // When
        let hotel = MockHotelPackages.getHotel(by: hotelID)
        
        // Then
        XCTAssertNotNil(hotel, "应该能找到指定ID的酒店")
        XCTAssertEqual(hotel?.id, hotelID)
    }
    
    func testHotelsByLocation() {
        // Given
        let location = "北京"
        
        // When
        let hotels = MockHotelPackages.getHotels(in: location)
        
        // Then
        XCTAssertGreaterThan(hotels.count, 0, "应该找到北京的酒店")
        XCTAssertTrue(hotels.allSatisfy { $0.location.contains("北京") }, "所有酒店都应该在北京")
    }
    
    func testHotelsByPriceRange() {
        // Given
        let minPrice = 800.0
        let maxPrice = 1500.0
        
        // When
        let hotels = MockHotelPackages.getHotels(inPriceRange: minPrice, maxPrice)
        
        // Then
        XCTAssertTrue(hotels.allSatisfy { $0.price >= minPrice && $0.price <= maxPrice })
    }
    
    func testHotelsByRating() {
        // Given
        let minRating = 4.5
        
        // When
        let hotels = MockHotelPackages.getHotels(withMinRating: minRating)
        
        // Then
        XCTAssertTrue(hotels.allSatisfy { $0.rating >= minRating })
    }
    
    func testHotelsByAmenities() {
        // Given
        let requiredAmenities: [Amenity] = [.wifi, .restaurant]
        
        // When
        let hotels = MockHotelPackages.getHotels(withAmenities: requiredAmenities)
        
        // Then
        XCTAssertTrue(hotels.allSatisfy { hotel in
            requiredAmenities.allSatisfy { hotel.hasAmenity($0) }
        })
    }
    
    func testUserRequirementsGeneration() {
        // When
        let requirements = MockUserRequirements.getTypicalRequirements()
        
        // Then
        XCTAssertEqual(requirements.count, 5, "应该生成5种典型用户需求")
        
        // 验证每种需求的有效性
        for requirement in requirements {
            XCTAssertTrue(requirement.isValid, "用户需求应该是有效的")
            XCTAssertGreaterThanOrEqual(requirement.stayDuration, 0, "住宿天数应该非负")
        }
    }
    
    func testSpecificUserRequirement() {
        // When
        let businessTraveler = MockUserRequirements.createRequirements(for: .business)
        let familyVacation = MockUserRequirements.createRequirements(for: .family)
        
        // Then
        XCTAssertEqual(businessTraveler.guests, 1, "商务旅客应该是单人")
        XCTAssertEqual(familyVacation.guests, 4, "家庭度假应该适合多人")
        XCTAssertTrue(familyVacation.preferences.contains(.familyFriendly), "家庭度假应该包含家庭友好的偏好")
    }
    
    func testSearchFilters() {
        // When
        let filters = MockSearchFilters.getCommonFilters()
        
        // Then
        XCTAssertEqual(filters.count, 4, "应该有4种常见过滤器")
        
        // 验证过滤器配置
        let businessFilter = filters[0]
        XCTAssertGreaterThanOrEqual(businessFilter.minRating, 4.0, "商务过滤器应该要求较高评分")
        
        let budgetFilter = filters[2]
        XCTAssertLessThanOrEqual(budgetFilter.maxPrice ?? 10000, 800.0, "预算过滤器应该限制最高价格")
    }
    
    func testDataConsistency() {
        // Given
        let allHotels = MockHotelPackages.getExtendedHotelCollection()
        
        // When & Then
        for hotel in allHotels {
            // 验证价格合理性
            XCTAssertGreaterThan(hotel.price, 0, "酒店价格应该大于0")
            XCTAssertLessThan(hotel.price, 100000, "酒店价格应该合理")
            
            // 验证评分范围
            XCTAssertGreaterThanOrEqual(hotel.rating, 0.0, "评分不应该小于0")
            XCTAssertLessThanOrEqual(hotel.rating, 5.0, "评分不应该大于5")
            
            // 验证必填字段
            XCTAssertFalse(hotel.name.isEmpty, "酒店名称不能为空")
            XCTAssertFalse(hotel.location.isEmpty, "酒店位置不能为空")
            XCTAssertFalse(hotel.description.isEmpty, "酒店描述不能为空")
            
            // 验证联系方式
            XCTAssertFalse(hotel.contactInfo.phone.isEmpty, "联系电话不能为空")
            XCTAssertFalse(hotel.contactInfo.address.isEmpty, "地址不能为空")
            
            // 验证可用性信息
            XCTAssertGreaterThanOrEqual(hotel.availabilityInfo.availableRooms, 0, "可用房间数不能为负")
            XCTAssertGreaterThan(hotel.availabilityInfo.maxGuests, 0, "最大入住人数应该大于0")
        }
    }
    
    func testPerformanceExample() {
        // 性能测试示例
        measure {
            _ = MockHotelPackages.getExtendedHotelCollection()
        }
    }
}