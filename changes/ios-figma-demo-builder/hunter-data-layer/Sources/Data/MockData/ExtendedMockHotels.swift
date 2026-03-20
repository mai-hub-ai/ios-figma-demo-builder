//
//  ExtendedMockHotels.swift
//  HotelBookingData
//
//  Created by Hunter on 2024.
//  Copyright © 2024 Hunter. All rights reserved.
//

import Foundation

extension MockHotelPackages {
    
    /// 获取扩展的酒店数据（总共100+个样本）
    public static func getExtendedHotelCollection() -> [HotelPackage] {
        var allHotels: [HotelPackage] = []
        
        // 添加原有的酒店数据
        allHotels.append(contentsOf: getExtendedHotels())
        
        // 添加更多酒店数据以达到100+样本
        for i in 23...100 {
            allHotels.append(createSampleHotel(index: i))
        }
        
        return allHotels
    }
    
    /// 创建示例酒店
    private static func createSampleHotel(index: Int) -> HotelPackage {
        let cities = ["北京", "上海", "广州", "深圳", "成都", "杭州", "西安", "厦门", "青岛", "大连"]
        let city = cities[Int.random(in: 0..<cities.count)]
        
        let price = Double(Int.random(in: 500...3000))
        let rating = Double.random(in: 3.0...5.0)
        
        let priceInfo = PriceInfo(
            basePrice: price,
            currency: .cny,
            taxesAndFees: price * 0.1,
            totalPrice: price * 1.1,
            pricePerNight: price
        )
        
        let ratingInfo = RatingInfo(
            overallRating: rating,
            reviewCount: Int.random(in: 50...1500),
            cleanliness: min(5.0, max(1.0, rating + Double.random(in: -0.5...0.5))),
            service: min(5.0, max(1.0, rating + Double.random(in: -0.5...0.5))),
            location: min(5.0, max(1.0, rating + Double.random(in: -0.5...0.5))),
            facilities: min(5.0, max(1.0, rating + Double.random(in: -0.5...0.5)))
        )
        
        let amenitiesCount = Int.random(in: 3...7)
        let amenities = Array(Amenity.allCases.shuffled().prefix(amenitiesCount))
        
        let images = [
            ImageInfo(url: "https://example.com/hotel_\(index)_1.jpg", imageType: .exterior, isPrimary: true),
            ImageInfo(url: "https://example.com/hotel_\(index)_2.jpg", imageType: .lobby),
            ImageInfo(url: "https://example.com/hotel_\(index)_3.jpg", imageType: .room)
        ]
        
        let roomTypes = [
            RoomType(id: "hotel_\(index)_standard", name: "标准房", capacity: 2, price: price, description: "舒适的双人房"),
            RoomType(id: "hotel_\(index)_deluxe", name: "豪华房", capacity: 2, price: price * 1.3, description: "升级版豪华客房")
        ]
        
        let contactInfo = ContactInfo(
            phone: "+86-\(Int.random(in: 10000000000...19999999999))",
            email: "hotel\(index)@\(city.lowercased()).com",
            address: "\(city)市某区某路\(index)号"
        )
        
        let availabilityInfo = AvailabilityInfo(
            checkInDate: Date(),
            checkOutDate: Date().addingTimeInterval(86400 * 2),
            availableRooms: Int.random(in: 1...20),
            maxGuests: 4,
            cancellationPolicy: CancellationPolicy.allCases.randomElement() ?? .moderate,
            instantBooking: Bool.random()
        )
        
        return HotelPackage(
            id: "hotel_\(index)",
            name: "\(city)\(index)号酒店",
            location: "\(city)市某商业区",
            priceInfo: priceInfo,
            ratingInfo: ratingInfo,
            amenities: amenities,
            images: images,
            description: "位于\(city)市中心的一家优质酒店，提供舒适的住宿体验和完善的设施服务。",
            latitude: Double.random(in: 20.0...50.0),
            longitude: Double.random(in: 70.0...135.0),
            roomTypes: roomTypes,
            contactInfo: contactInfo,
            availabilityInfo: availabilityInfo
        )
    }
    
    /// 获取Figma样式映射数据
    public static func getFigmaStyleMappings() -> [String: ComponentInfo] {
        return [
            "hotel-card": ComponentInfo(
                id: "comp_001",
                name: "酒店卡片",
                type: "card",
                cssClasses: ["hotel-card", "card"],
                properties: [
                    "background-color": "#ffffff",
                    "border-radius": "12px",
                    "box-shadow": "0 4px 12px rgba(0,0,0,0.1)",
                    "padding": "16px"
                ],
                layoutInfo: LayoutInfo(
                    width: "100%",
                    padding: "16px",
                    flexDirection: "column"
                )
            ),
            
            "price-tag": ComponentInfo(
                id: "comp_002",
                name: "价格标签",
                type: "tag",
                cssClasses: ["price-tag", "tag"],
                properties: [
                    "background-color": "#1A73E8",
                    "color": "#ffffff",
                    "border-radius": "8px",
                    "padding": "8px 12px",
                    "font-weight": "600"
                ]
            ),
            
            "rating-stars": ComponentInfo(
                id: "comp_003",
                name: "评分星星",
                type: "rating",
                cssClasses: ["rating-stars"],
                properties: [
                    "color": "#FFD700",
                    "font-size": "16px"
                ]
            ),
            
            "amenity-icon": ComponentInfo(
                id: "comp_004",
                name: "设施图标",
                type: "icon",
                cssClasses: ["amenity-icon", "icon"],
                properties: [
                    "width": "24px",
                    "height": "24px",
                    "color": "#666666"
                ]
            )
        ]
    }
    
    /// 获取设计令牌示例
    public static func getSampleDesignTokens() -> DesignTokens {
        return DesignTokens(
            colors: ColorTokens(
                primary: TokenValue(value: "#1A73E8", description: "主色调"),
                primaryHover: TokenValue(value: "#0D62C5", description: "主色调悬停"),
                primaryActive: TokenValue(value: "#0A4A99", description: "主色调激活"),
                secondary: TokenValue(value: "#FFD700", description: "次要色调"),
                secondaryHover: TokenValue(value: "#E6C200", description: "次要色调悬停"),
                background: TokenValue(value: "#F8F9FA", description: "背景色"),
                surface: TokenValue(value: "#FFFFFF", description: "表面色"),
                surfaceVariant: TokenValue(value: "#F1F3F4", description: "变体表面色"),
                onBackground: TokenValue(value: "#202124", description: "背景上的文字"),
                onSurface: TokenValue(value: "#3C4043", description: "表面上的文字"),
                onSurfaceVariant: TokenValue(value: "#5F6368", description: "变体表面上的文字"),
                success: TokenValue(value: "#34A853", description: "成功色"),
                warning: TokenValue(value: "#FBBC04", description: "警告色"),
                error: TokenValue(value: "#EA4335", description: "错误色"),
                info: TokenValue(value: "#4285F4", description: "信息色"),
                outline: TokenValue(value: "#DADCE0", description: "轮廓色"),
                shadow: TokenValue(value: "rgba(0,0,0,0.12)", description: "阴影色")
            ),
            
            typography: TypographyTokens(
                displayLarge: FontToken(fontName: "PingFang SC", fontSize: TokenValue(value: "32px"), fontWeight: "600"),
                displayMedium: FontToken(fontName: "PingFang SC", fontSize: TokenValue(value: "28px"), fontWeight: "600"),
                displaySmall: FontToken(fontName: "PingFang SC", fontSize: TokenValue(value: "24px"), fontWeight: "600"),
                headlineLarge: FontToken(fontName: "PingFang SC", fontSize: TokenValue(value: "22px"), fontWeight: "600"),
                headlineMedium: FontToken(fontName: "PingFang SC", fontSize: TokenValue(value: "20px"), fontWeight: "600"),
                headlineSmall: FontToken(fontName: "PingFang SC", fontSize: TokenValue(value: "18px"), fontWeight: "600"),
                titleLarge: FontToken(fontName: "PingFang SC", fontSize: TokenValue(value: "16px"), fontWeight: "600"),
                titleMedium: FontToken(fontName: "PingFang SC", fontSize: TokenValue(value: "15px"), fontWeight: "600"),
                titleSmall: FontToken(fontName: "PingFang SC", fontSize: TokenValue(value: "14px"), fontWeight: "600"),
                bodyLarge: FontToken(fontName: "PingFang SC", fontSize: TokenValue(value: "16px"), fontWeight: "400"),
                bodyMedium: FontToken(fontName: "PingFang SC", fontSize: TokenValue(value: "14px"), fontWeight: "400"),
                bodySmall: FontToken(fontName: "PingFang SC", fontSize: TokenValue(value: "12px"), fontWeight: "400"),
                labelLarge: FontToken(fontName: "PingFang SC", fontSize: TokenValue(value: "14px"), fontWeight: "500"),
                labelMedium: FontToken(fontName: "PingFang SC", fontSize: TokenValue(value: "12px"), fontWeight: "500"),
                labelSmall: FontToken(fontName: "PingFang SC", fontSize: TokenValue(value: "11px"), fontWeight: "500")
            ),
            
            spacing: SpacingTokens(
                xxxs: TokenValue(value: "2px"),
                xxs: TokenValue(value: "4px"),
                xs: TokenValue(value: "8px"),
                s: TokenValue(value: "12px"),
                m: TokenValue(value: "16px"),
                l: TokenValue(value: "24px"),
                xl: TokenValue(value: "32px"),
                xxl: TokenValue(value: "48px"),
                xxxl: TokenValue(value: "64px")
            ),
            
            borderRadius: BorderRadiusTokens(
                none: TokenValue(value: "0px"),
                xs: TokenValue(value: "2px"),
                s: TokenValue(value: "4px"),
                m: TokenValue(value: "8px"),
                l: TokenValue(value: "12px"),
                xl: TokenValue(value: "16px"),
                pill: TokenValue(value: "9999px"),
                circle: TokenValue(value: "50%")
            ),
            
            shadows: ShadowTokens(
                none: TokenValue(value: "none"),
                xs: TokenValue(value: "0 1px 2px 0 rgba(0,0,0,0.05)"),
                s: TokenValue(value: "0 1px 3px 0 rgba(0,0,0,0.1), 0 1px 2px 0 rgba(0,0,0,0.06)"),
                m: TokenValue(value: "0 4px 6px -1px rgba(0,0,0,0.1), 0 2px 4px -1px rgba(0,0,0,0.06)"),
                l: TokenValue(value: "0 10px 15px -3px rgba(0,0,0,0.1), 0 4px 6px -2px rgba(0,0,0,0.05)"),
                xl: TokenValue(value: "0 20px 25px -5px rgba(0,0,0,0.1), 0 10px 10px -5px rgba(0,0,0,0.04)")
            ),
            
            breakpoints: BreakpointTokens(
                mobile: TokenValue(value: "0px"),
                tablet: TokenValue(value: "768px"),
                laptop: TokenValue(value: "1024px"),
                desktop: TokenValue(value: "1200px"),
                wide: TokenValue(value: "1440px")
            )
        )
    }
}