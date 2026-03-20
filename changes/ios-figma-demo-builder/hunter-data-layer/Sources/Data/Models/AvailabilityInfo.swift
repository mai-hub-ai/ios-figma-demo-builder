//
//  AvailabilityInfo.swift
//  HotelBookingData
//
//  Created by Hunter on 2024.
//  Copyright © 2024 Hunter. All rights reserved.
//

import Foundation

/// 可用性信息模型
public struct AvailabilityInfo: Codable, Equatable {
    public let checkInDate: Date           // 入住日期
    public let checkOutDate: Date          // 退房日期
    public let availableRooms: Int         // 可用房间数
    public let maxGuests: Int              // 最大入住人数
    public let cancellationPolicy: CancellationPolicy // 取消政策
    public let instantBooking: Bool        // 是否支持即时预订
    public let lastUpdated: Date           // 最后更新时间
    
    public init(
        checkInDate: Date,
        checkOutDate: Date,
        availableRooms: Int,
        maxGuests: Int,
        cancellationPolicy: CancellationPolicy = .moderate,
        instantBooking: Bool = false,
        lastUpdated: Date = Date()
    ) {
        self.checkInDate = checkInDate
        self.checkOutDate = checkOutDate
        self.availableRooms = availableRooms
        self.maxGuests = maxGuests
        self.cancellationPolicy = cancellationPolicy
        self.instantBooking = instantBooking
        self.lastUpdated = lastUpdated
    }
    
    /// 是否有空房
    public var hasAvailability: Bool {
        return availableRooms > 0
    }
    
    /// 是否支持取消
    public var isCancelable: Bool {
        return cancellationPolicy != .nonRefundable
    }
    
    /// 获取入住天数
    public var stayDuration: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: checkInDate, to: checkOutDate)
        return components.day ?? 0
    }
    
    /// 是否为近期更新
    public var isRecent: Bool {
        let calendar = Calendar.current
        let oneHourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
        return lastUpdated > oneHourAgo
    }
}

/// 取消政策枚举
public enum CancellationPolicy: String, CaseIterable, Codable {
    case freeCancellation = "免费取消"
    case moderate = "适度取消政策"
    case strict = "严格取消政策"
    case nonRefundable = "不可退款"
    
    public var description: String {
        return self.rawValue
    }
    
    /// 取消截止时间（小时）
    public var cutoffHours: Int {
        switch self {
        case .freeCancellation: return 48  // 48小时前免费取消
        case .moderate: return 24         // 24小时前免费取消
        case .strict: return 48           // 48小时前收取费用
        case .nonRefundable: return 0     // 不可取消
        }
    }
    
    /// 是否允许免费取消
    public var allowsFreeCancellation: Bool {
        return self != .nonRefundable
    }
}