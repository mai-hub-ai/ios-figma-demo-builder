//
//  HotelPackage.swift
//  HotelBookingData
//
//  Created by Hunter on 2024.
//  Copyright © 2024 Hunter. All rights reserved.
//

import Foundation

/// 酒店设施枚举
public enum Amenity: String, CaseIterable, Codable {
    case wifi = "WiFi"
    case parking = "停车场"
    case pool = "游泳池"
    case gym = "健身房"
    case restaurant = "餐厅"
    case spa = "水疗"
    case breakfast = "早餐"
    case airConditioning = "空调"
    case elevator = "电梯"
    case businessCenter = "商务中心"
}

/// 用户偏好枚举
public enum Preference: String, CaseIterable, Codable {
    case beach = "海滩"
    case cityCenter = "市中心"
    case mountain = "山区"
    case familyFriendly = "家庭友好"
    case luxury = "豪华"
    case budget = "经济型"
    case petFriendly = "宠物友好"
    case smoking = "吸烟区"
}

/// 酒店套餐数据模型
public struct HotelPackage: Codable, Equatable {
    public let id: String
    public let name: String
    public let location: String
    public let priceInfo: PriceInfo          // 详细价格信息
    public let ratingInfo: RatingInfo        // 详细评分信息
    public let amenities: [Amenity]
    public let images: [ImageInfo]           // 详细图片信息
    public let description: String
    public let latitude: Double
    public let longitude: Double
    public let roomTypes: [RoomType]
    public let contactInfo: ContactInfo
    public let availabilityInfo: AvailabilityInfo // 可用性信息
    
    public init(
        id: String,
        name: String,
        location: String,
        priceInfo: PriceInfo,
        ratingInfo: RatingInfo,
        amenities: [Amenity],
        images: [ImageInfo],
        description: String,
        latitude: Double,
        longitude: Double,
        roomTypes: [RoomType],
        contactInfo: ContactInfo,
        availabilityInfo: AvailabilityInfo
    ) {
        self.id = id
        self.name = name
        self.location = location
        self.priceInfo = priceInfo
        self.ratingInfo = ratingInfo
        self.amenities = amenities
        self.images = images
        self.description = description
        self.latitude = latitude
        self.longitude = longitude
        self.roomTypes = roomTypes
        self.contactInfo = contactInfo
        self.availabilityInfo = availabilityInfo
    }
    
    // 兼容性属性（保持向后兼容）
    public var price: Double { priceInfo.totalPrice }
    public var rating: Double { ratingInfo.overallRating }
    
    /// 计算是否有特定设施
    public func hasAmenity(_ amenity: Amenity) -> Bool {
        return amenities.contains(amenity)
    }
    
    /// 获取主图片
    public var primaryImage: ImageInfo? {
        return images.first { $0.isPrimary } ?? images.first
    }
    
    /// 获取价格显示字符串
    public var priceDisplay: String {
        return priceInfo.displayPrice
    }
    
    /// 获取每晚价格显示
    public var nightlyPriceDisplay: String {
        return priceInfo.nightlyPriceDisplay
    }
    
    /// 获取评分显示字符串
    public var ratingDisplay: String {
        return ratingInfo.displayRating
    }
    
    /// 是否有空房
    public var hasAvailability: Bool {
        return availabilityInfo.hasAvailability
    }
    
    /// 是否支持即时预订
    public var supportsInstantBooking: Bool {
        return availabilityInfo.instantBooking
    }
}

/// 房型信息
public struct RoomType: Codable, Equatable {
    public let id: String
    public let name: String
    public let capacity: Int
    public let price: Double
    public let description: String
    
    public init(id: String, name: String, capacity: Int, price: Double, description: String) {
        self.id = id
        self.name = name
        self.capacity = capacity
        self.price = price
        self.description = description
    }
}

/// 联系信息
public struct ContactInfo: Codable, Equatable {
    public let phone: String
    public let email: String
    public let address: String
    
    public init(phone: String, email: String, address: String) {
        self.phone = phone
        self.email = email
        self.address = address
    }
}