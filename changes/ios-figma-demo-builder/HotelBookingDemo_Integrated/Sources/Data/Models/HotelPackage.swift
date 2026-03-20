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
    public let price: Double
    public let rating: Double
    public let amenities: [Amenity]
    public let images: [String]
    public let description: String
    public let latitude: Double
    public let longitude: Double
    public let roomTypes: [RoomType]
    public let contactInfo: ContactInfo
    
    public init(
        id: String,
        name: String,
        location: String,
        price: Double,
        rating: Double,
        amenities: [Amenity],
        images: [String],
        description: String,
        latitude: Double,
        longitude: Double,
        roomTypes: [RoomType],
        contactInfo: ContactInfo
    ) {
        self.id = id
        self.name = name
        self.location = location
        self.price = price
        self.rating = rating
        self.amenities = amenities
        self.images = images
        self.description = description
        self.latitude = latitude
        self.longitude = longitude
        self.roomTypes = roomTypes
        self.contactInfo = contactInfo
    }
    
    /// 计算是否有特定设施
    public func hasAmenity(_ amenity: Amenity) -> Bool {
        return amenities.contains(amenity)
    }
    
    /// 获取价格显示字符串
    public var priceDisplay: String {
        return "¥\(Int(price))/晚"
    }
    
    /// 获取评分显示字符串
    public var ratingDisplay: String {
        return String(format: "%.1f", rating)
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