//
//  MockHotelRepository.swift
//  HotelBookingData
//
//  Created by Hunter on 2024.
//  Copyright © 2024 Hunter. All rights reserved.
//

import Foundation

/// Mock酒店数据仓库实现
public class MockHotelRepository: HotelRepository {
    
    private let mockHotels: [HotelPackage]
    private let delay: TimeInterval
    
    public init(delay: TimeInterval = 0.5) {
        self.mockHotels = MockHotelPackages.getExtendedHotels()
        self.delay = delay
    }
    
    // MARK: - HotelRepository 协议实现
    
    public func getAllHotels() async throws -> [HotelPackage] {
        try await simulateNetworkDelay()
        return mockHotels
    }
    
    public func getHotel(by id: String) async throws -> HotelPackage? {
        try await simulateNetworkDelay()
        return mockHotels.first { $0.id == id }
    }
    
    public func searchHotels(with filters: SearchFilters) async throws -> [HotelPackage] {
        try await simulateNetworkDelay()
        
        var filteredHotels = mockHotels
        
        // 应用最小评分筛选
        if filters.minRating > 0 {
            filteredHotels = filteredHotels.filter { $0.rating >= filters.minRating }
        }
        
        // 应用最大价格筛选
        if let maxPrice = filters.maxPrice {
            filteredHotels = filteredHotels.filter { $0.price <= maxPrice }
        }
        
        // 应用必需设施筛选
        if !filters.requiredAmenities.isEmpty {
            filteredHotels = filteredHotels.filter { hotel in
                filters.requiredAmenities.allSatisfy { hotel.hasAmenity($0) }
            }
        }
        
        // 应用房间容量筛选
        if let roomCapacity = filters.roomCapacity {
            filteredHotels = filteredHotels.filter { hotel in
                hotel.roomTypes.contains { $0.capacity >= roomCapacity }
            }
        }
        
        // 应用排序
        filteredHotels = sortHotels(filteredHotels, by: filters.sortBy)
        
        return filteredHotels
    }
    
    public func searchHotels(in location: String) async throws -> [HotelPackage] {
        try await simulateNetworkDelay()
        return mockHotels.filter { 
            $0.location.localizedCaseInsensitiveContains(location) ||
            $0.name.localizedCaseInsensitiveContains(location)
        }
    }
    
    public func searchHotels(minPrice: Double, maxPrice: Double) async throws -> [HotelPackage] {
        try await simulateNetworkDelay()
        return mockHotels.filter { hotel in
            hotel.price >= minPrice && hotel.price <= maxPrice
        }
    }
    
    public func searchHotels(minRating: Double) async throws -> [HotelPackage] {
        try await simulateNetworkDelay()
        return mockHotels.filter { $0.rating >= minRating }
    }
    
    public func searchHotels(withAmenities amenities: [Amenity]) async throws -> [HotelPackage] {
        try await simulateNetworkDelay()
        return mockHotels.filter { hotel in
            amenities.allSatisfy { hotel.hasAmenity($0) }
        }
    }
    
    // MARK: - 私有辅助方法
    
    private func simulateNetworkDelay() async throws {
        try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        
        // 模拟偶尔的网络错误（5%概率）
        if Bool.random() && arc4random_uniform(100) < 5 {
            throw HotelRepositoryError.networkError("网络连接不稳定，请稍后重试")
        }
    }
    
    private func sortHotels(_ hotels: [HotelPackage], by sortOption: SortOption) -> [HotelPackage] {
        switch sortOption {
        case .relevance:
            // 默认按评分和价格综合排序
            return hotels.sorted { hotel1, hotel2 in
                let score1 = hotel1.rating * (10000 / (hotel1.price + 1))
                let score2 = hotel2.rating * (10000 / (hotel2.price + 1))
                return score1 > score2
            }
            
        case .priceLowToHigh:
            return hotels.sorted { $0.price < $1.price }
            
        case .priceHighToLow:
            return hotels.sorted { $0.price > $1.price }
            
        case .rating:
            return hotels.sorted { $0.rating > $1.rating }
            
        case .distance:
            // 这里需要地理位置信息，暂时按评分排序
            return hotels.sorted { $0.rating > $1.rating }
        }
    }
}

// MARK: - 扩展：批量操作支持

extension MockHotelRepository {
    
    /// 批量获取多个酒店
    public func getHotels(by ids: [String]) async throws -> [HotelPackage] {
        try await simulateNetworkDelay()
        return mockHotels.filter { ids.contains($0.id) }
    }
    
    /// 分页搜索
    public func searchHotels(
        with filters: SearchFilters,
        page: Int,
        pageSize: Int
    ) async throws -> HotelSearchResult {
        let allResults = try await searchHotels(with: filters)
        let totalCount = allResults.count
        let totalPages = (totalCount + pageSize - 1) / pageSize
        let startIndex = (page - 1) * pageSize
        let endIndex = min(startIndex + pageSize, totalCount)
        
        let paginatedHotels = startIndex < totalCount ? 
            Array(allResults[startIndex..<endIndex]) : []
        
        return HotelSearchResult(
            hotels: paginatedHotels,
            totalCount: totalCount,
            currentPage: page,
            totalPages: totalPages
        )
    }
}