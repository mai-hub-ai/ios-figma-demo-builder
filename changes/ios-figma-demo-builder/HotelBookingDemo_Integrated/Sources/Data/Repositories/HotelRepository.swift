//
//  HotelRepository.swift
//  HotelBookingData
//
//  Created by Hunter on 2024.
//  Copyright © 2024 Hunter. All rights reserved.
//

import Foundation

/// 酒店数据访问协议
public protocol HotelRepository {
    
    /// 获取所有酒店
    func getAllHotels() async throws -> [HotelPackage]
    
    /// 根据ID获取酒店
    func getHotel(by id: String) async throws -> HotelPackage?
    
    /// 搜索酒店
    func searchHotels(with filters: SearchFilters) async throws -> [HotelPackage]
    
    /// 根据位置搜索酒店
    func searchHotels(in location: String) async throws -> [HotelPackage]
    
    /// 根据价格范围搜索
    func searchHotels(minPrice: Double, maxPrice: Double) async throws -> [HotelPackage]
    
    /// 根据评分筛选
    func searchHotels(minRating: Double) async throws -> [HotelPackage]
    
    /// 根据设施筛选
    func searchHotels(withAmenities amenities: [Amenity]) async throws -> [HotelPackage]
}

/// 搜索结果包装类
public struct HotelSearchResult {
    public let hotels: [HotelPackage]
    public let totalCount: Int
    public let currentPage: Int
    public let totalPages: Int
    
    public init(hotels: [HotelPackage], totalCount: Int, currentPage: Int, totalPages: Int) {
        self.hotels = hotels
        self.totalCount = totalCount
        self.currentPage = currentPage
        self.totalPages = totalPages
    }
}

/// Repository错误类型
public enum HotelRepositoryError: Error, LocalizedError {
    case notFound
    case networkError(String)
    case invalidData
    case databaseError(String)
    
    public var errorDescription: String? {
        switch self {
        case .notFound:
            return "未找到指定的酒店数据"
        case .networkError(let message):
            return "网络错误: \(message)"
        case .invalidData:
            return "数据格式无效"
        case .databaseError(let message):
            return "数据库错误: \(message)"
        }
    }
}