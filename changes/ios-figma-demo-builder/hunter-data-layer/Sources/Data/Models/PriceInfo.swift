//
//  PriceInfo.swift
//  HotelBookingData
//
//  Created by Hunter on 2024.
//  Copyright © 2024 Hunter. All rights reserved.
//

import Foundation

/// 价格信息模型
public struct PriceInfo: Codable, Equatable {
    public let basePrice: Double          // 基础价格
    public let currency: Currency         // 货币类型
    public let taxesAndFees: Double       // 税费
    public let discount: Double?          // 折扣金额
    public let totalPrice: Double         // 总价
    public let pricePerNight: Double      // 每晚价格
    public let priceBreakdown: [PriceItem] // 价格明细
    
    public init(
        basePrice: Double,
        currency: Currency = .cny,
        taxesAndFees: Double = 0.0,
        discount: Double? = nil,
        totalPrice: Double,
        pricePerNight: Double,
        priceBreakdown: [PriceItem] = []
    ) {
        self.basePrice = basePrice
        self.currency = currency
        self.taxesAndFees = taxesAndFees
        self.discount = discount
        self.totalPrice = totalPrice
        self.pricePerNight = pricePerNight
        self.priceBreakdown = priceBreakdown
    }
    
    /// 获取显示价格字符串
    public var displayPrice: String {
        return "\(currency.symbol)\(Int(totalPrice))"
    }
    
    /// 获取每晚价格显示
    public var nightlyPriceDisplay: String {
        return "\(currency.symbol)\(Int(pricePerNight))/晚"
    }
    
    /// 是否有折扣
    public var hasDiscount: Bool {
        return discount != nil && discount! > 0
    }
    
    /// 折扣百分比
    public var discountPercentage: Double? {
        guard let discountAmount = discount, basePrice > 0 else { return nil }
        return (discountAmount / basePrice) * 100
    }
}

/// 货币枚举
public enum Currency: String, CaseIterable, Codable {
    case cny = "CNY"  // 人民币
    case usd = "USD"  // 美元
    case eur = "EUR"  // 欧元
    case jpy = "JPY"  // 日元
    case gbp = "GBP"  // 英镑
    
    public var symbol: String {
        switch self {
        case .cny: return "¥"
        case .usd: return "$"
        case .eur: return "€"
        case .jpy: return "¥"
        case .gbp: return "£"
        }
    }
    
    public var displayName: String {
        switch self {
        case .cny: return "人民币"
        case .usd: return "美元"
        case .eur: return "欧元"
        case .jpy: return "日元"
        case .gbp: return "英镑"
        }
    }
}

/// 价格明细项
public struct PriceItem: Codable, Equatable {
    public let name: String
    public let amount: Double
    public let isDiscount: Bool
    
    public init(name: String, amount: Double, isDiscount: Bool = false) {
        self.name = name
        self.amount = amount
        self.isDiscount = isDiscount
    }
}