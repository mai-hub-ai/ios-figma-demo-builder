//
//  RepositoryFactory.swift
//  HotelBookingData
//
//  Created by Hunter on 2024.
//  Copyright © 2024 Hunter. All rights reserved.
//

import Foundation

/// Repository工厂类
public class RepositoryFactory {
    
    public enum RepositoryType {
        case mock(delay: TimeInterval)
        case network(baseURL: String)
        case database
        
        public static let `default`: RepositoryType = .mock(delay: 0.5)
    }
    
    private static var shared: RepositoryFactory?
    private var repositories: [String: HotelRepository] = [:]
    
    /// 获取单例实例
    public static func shared() -> RepositoryFactory {
        if shared == nil {
            shared = RepositoryFactory()
        }
        return shared!
    }
    
    /// 私有初始化方法
    private init() {}
    
    /// 创建Repository实例
    public func createRepository(type: RepositoryType = .default) -> HotelRepository {
        let key = typeKey(for: type)
        
        if let existingRepo = repositories[key] {
            return existingRepo
        }
        
        let newRepo: HotelRepository
        switch type {
        case .mock(let delay):
            newRepo = MockHotelRepository(delay: delay)
            
        case .network(let baseURL):
            // 这里将来会实现网络版Repository
            newRepo = MockHotelRepository(delay: 1.0)
            
        case .database:
            // 这里将来会实现数据库版Repository
            newRepo = MockHotelRepository(delay: 0.3)
        }
        
        repositories[key] = newRepo
        return newRepo
    }
    
    /// 获取默认Repository
    public func getDefaultRepository() -> HotelRepository {
        return createRepository()
    }
    
    /// 清除缓存的Repository
    public func clearCache() {
        repositories.removeAll()
    }
    
    /// 移除特定类型的Repository
    public func removeRepository(type: RepositoryType) {
        let key = typeKey(for: type)
        repositories.removeValue(forKey: key)
    }
    
    // MARK: - 私有方法
    
    private func typeKey(for type: RepositoryType) -> String {
        switch type {
        case .mock(let delay):
            return "mock_\(delay)"
        case .network(let baseURL):
            return "network_\(baseURL)"
        case .database:
            return "database"
        }
    }
}

// MARK: - 便捷访问扩展

extension HotelRepository {
    
    /// 便捷的搜索方法
    public func search(
        location: String? = nil,
        minPrice: Double? = nil,
        maxPrice: Double? = nil,
        minRating: Double = 0.0,
        amenities: [Amenity] = [],
        sort: SortOption = .relevance
    ) async throws -> [HotelPackage] {
        
        var filters = SearchFilters(
            minRating: minRating,
            maxPrice: maxPrice,
            requiredAmenities: amenities,
            sortBy: sort
        )
        
        // 如果提供了位置，则优先使用位置搜索
        if let location = location {
            return try await searchHotels(in: location)
        }
        
        // 如果提供了价格范围，则使用价格搜索
        if let minPrice = minPrice, let maxPrice = maxPrice {
            return try await searchHotels(minPrice: minPrice, maxPrice: maxPrice)
        }
        
        // 使用通用搜索
        return try await searchHotels(with: filters)
    }
}