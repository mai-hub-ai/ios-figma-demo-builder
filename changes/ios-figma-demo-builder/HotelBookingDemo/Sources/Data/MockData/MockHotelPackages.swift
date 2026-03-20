//
//  MockHotelPackages.swift
//  HotelBookingData
//
//  Created by Hunter on 2024.
//  Copyright © 2024 Hunter. All rights reserved.
//

import Foundation

/// Mock酒店数据提供者
public class MockHotelPackages {
    
    /// 获取所有酒店数据
    public static func getAllHotels() -> [HotelPackage] {
        return [
            createGrandHyatt(),
            createMarriott(),
            createHilton(),
            createSheraton(),
            createInterContinental(),
            createWestin(),
            createCrownePlaza(),
            createHolidayInn(),
            createRadisson(),
            createNovotel()
        ]
    }
    
    /// 根据ID获取酒店
    public static func getHotel(by id: String) -> HotelPackage? {
        return getAllHotels().first { $0.id == id }
    }
    
    /// 根据位置筛选酒店
    public static func getHotels(in location: String) -> [HotelPackage] {
        return getAllHotels().filter { 
            $0.location.localizedCaseInsensitiveContains(location) 
        }
    }
    
    /// 根据价格范围筛选
    public static func getHotels(inPriceRange min: Double, _ max: Double) -> [HotelPackage] {
        return getAllHotels().filter { hotel in
            hotel.price >= min && hotel.price <= max
        }
    }
    
    /// 根据评分筛选
    public static func getHotels(withMinRating rating: Double) -> [HotelPackage] {
        return getAllHotels().filter { $0.rating >= rating }
    }
    
    /// 根据设施筛选
    public static func getHotels(withAmenities amenities: [Amenity]) -> [HotelPackage] {
        return getAllHotels().filter { hotel in
            amenities.allSatisfy { hotel.hasAmenity($0) }
        }
    }
    
    // MARK: - 私有工厂方法
    
    private static func createGrandHyatt() -> HotelPackage {
        return HotelPackage(
            id: "hotel_001",
            name: "北京东方君悦大酒店",
            location: "北京市朝阳区建国门外大街1号",
            price: 1288.0,
            rating: 4.8,
            amenities: [.wifi, .pool, .gym, .restaurant, .spa, .breakfast, .airConditioning, .businessCenter],
            images: [
                "https://example.com/grandhyatt1.jpg",
                "https://example.com/grandhyatt2.jpg",
                "https://example.com/grandhyatt3.jpg"
            ],
            description: "位于北京市中心的五星级豪华酒店，拥有绝佳的城市景观和一流的服务设施。",
            latitude: 39.9092,
            longitude: 116.4171,
            roomTypes: [
                RoomType(id: "rt_001_1", name: "豪华大床房", capacity: 2, price: 1288.0, description: "宽敞舒适的客房，配备豪华大床"),
                RoomType(id: "rt_001_2", name: "行政套房", capacity: 4, price: 2188.0, description: "独立客厅和卧室，适合商务出行")
            ],
            contactInfo: ContactInfo(
                phone: "+86-10-8518-1234",
                email: "reservations.bj@hyatt.com",
                address: "北京市朝阳区建国门外大街1号"
            )
        )
    }
    
    private static func createMarriott() -> HotelPackage {
        return HotelPackage(
            id: "hotel_002",
            name: "上海国际饭店",
            location: "上海市黄浦区南京西路170号",
            price: 988.0,
            rating: 4.6,
            amenities: [.wifi, .gym, .restaurant, .breakfast, .airConditioning, .elevator],
            images: [
                "https://example.com/marriott1.jpg",
                "https://example.com/marriott2.jpg"
            ],
            description: "历史悠久的国际知名酒店，地理位置优越，交通便利。",
            latitude: 31.2363,
            longitude: 121.4805,
            roomTypes: [
                RoomType(id: "rt_002_1", name: "标准双床房", capacity: 2, price: 988.0, description: "经典设计，舒适宜居"),
                RoomType(id: "rt_002_2", name: "豪华江景房", capacity: 2, price: 1588.0, description: "俯瞰黄浦江美景")
            ],
            contactInfo: ContactInfo(
                phone: "+86-21-6321-9888",
                email: "shanghai.reservations@marriott.com",
                address: "上海市黄浦区南京西路170号"
            )
        )
    }
    
    private static func createHilton() -> HotelPackage {
        return HotelPackage(
            id: "hotel_003",
            name: "广州希尔顿酒店",
            location: "广州市天河区林和西路167号",
            price: 888.0,
            rating: 4.5,
            amenities: [.wifi, .pool, .gym, .restaurant, .breakfast, .airConditioning, .businessCenter],
            images: [
                "https://example.com/hilton1.jpg",
                "https://example.com/hilton2.jpg",
                "https://example.com/hilton3.jpg"
            ],
            description: "现代化的商务酒店，位于广州CBD核心区域，配套设施完善。",
            latitude: 23.1252,
            longitude: 113.3165,
            roomTypes: [
                RoomType(id: "rt_003_1", name: "商务大床房", capacity: 2, price: 888.0, description: "专为商务旅客设计"),
                RoomType(id: "rt_003_2", name: "家庭套房", capacity: 4, price: 1388.0, description: "两室一厅，适合家庭入住")
            ],
            contactInfo: ContactInfo(
                phone: "+86-20-3883-8888",
                email: "guangzhou.info@hilton.com",
                address: "广州市天河区林和西路167号"
            )
        )
    }
    
    private static func createSheraton() -> HotelPackage {
        return HotelPackage(
            id: "hotel_004",
            name: "深圳喜来登酒店",
            location: "深圳市福田区益田路4088号",
            price: 788.0,
            rating: 4.4,
            amenities: [.wifi, .pool, .restaurant, .breakfast, .airConditioning],
            images: [
                "https://example.com/sheraton1.jpg",
                "https://example.com/sheraton2.jpg"
            ],
            description: "位于深圳会展中心附近，是商务和休闲旅客的理想选择。",
            latitude: 22.5356,
            longitude: 114.0503,
            roomTypes: [
                RoomType(id: "rt_004_1", name: "精选大床房", capacity: 2, price: 788.0, description: "现代简约风格"),
                RoomType(id: "rt_004_2", name: "豪华双床房", capacity: 2, price: 988.0, description: "空间宽敞，视野开阔")
            ],
            contactInfo: ContactInfo(
                phone: "+86-755-8828-8888",
                email: "shenzhen@sheraton.com",
                address: "深圳市福田区益田路4088号"
            )
        )
    }
    
    private static func createInterContinental() -> HotelPackage {
        return HotelPackage(
            id: "hotel_005",
            name: "成都世纪城洲际天堂酒店",
            location: "成都市高新区世纪城路208号",
            price: 1088.0,
            rating: 4.7,
            amenities: [.wifi, .pool, .gym, .restaurant, .spa, .breakfast, .airConditioning],
            images: [
                "https://example.com/intercontinental1.jpg",
                "https://example.com/intercontinental2.jpg"
            ],
            description: "坐落在成都世纪公园内，环境优美，是度假和商务的理想之选。",
            latitude: 30.5489,
            longitude: 104.0661,
            roomTypes: [
                RoomType(id: "rt_005_1", name: "园景大床房", capacity: 2, price: 1088.0, description: "直面世纪公园美景"),
                RoomType(id: "rt_005_2", name: "行政湖景房", capacity: 2, price: 1688.0, description: "俯瞰人工湖景")
            ],
            contactInfo: ContactInfo(
                phone: "+86-28-8534-9999",
                email: "chengdu.info@ihg.com",
                address: "成都市高新区世纪城路208号"
            )
        )
    }
    
    private static func createWestin() -> HotelPackage {
        return HotelPackage(
            id: "hotel_006",
            name: "杭州西湖万达嘉华酒店",
            location: "杭州市西湖区湖滨路15号",
            price: 928.0,
            rating: 4.3,
            amenities: [.wifi, .restaurant, .breakfast, .airConditioning],
            images: [
                "https://example.com/westin1.jpg",
                "https://example.com/westin2.jpg"
            ],
            description: "紧邻西湖景区，地理位置绝佳，可欣赏美丽的湖光山色。",
            latitude: 30.2463,
            longitude: 120.1592,
            roomTypes: [
                RoomType(id: "rt_006_1", name: "湖景大床房", capacity: 2, price: 928.0, description: "面向西湖，景色宜人"),
                RoomType(id: "rt_006_2", name: "豪华套房", capacity: 3, price: 1428.0, description: "独立起居空间")
            ],
            contactInfo: ContactInfo(
                phone: "+86-571-8708-8888",
                email: "hangzhou@westin.com",
                address: "杭州市西湖区湖滨路15号"
            )
        )
    }
    
    private static func createCrownePlaza() -> HotelPackage {
        return HotelPackage(
            id: "hotel_007",
            name: "西安皇冠假日酒店",
            location: "西安市雁塔区长安南路288号",
            price: 688.0,
            rating: 4.2,
            amenities: [.wifi, .restaurant, .breakfast, .airConditioning, .businessCenter],
            images: [
                "https://example.com/crowneplaza1.jpg"
            ],
            description: "位于古都西安，融合传统与现代元素，交通便利。",
            latitude: 34.2231,
            longitude: 108.9480,
            roomTypes: [
                RoomType(id: "rt_007_1", name: "标准房", capacity: 2, price: 688.0, description: "舒适实用的标准配置"),
                RoomType(id: "rt_007_2", name: "商务房", capacity: 2, price: 888.0, description: "配备办公设施")
            ],
            contactInfo: ContactInfo(
                phone: "+86-29-8525-6666",
                email: "xian@crownplaza.com",
                address: "西安市雁塔区长安南路288号"
            )
        )
    }
    
    private static func createHolidayInn() -> HotelPackage {
        return HotelPackage(
            id: "hotel_008",
            name: "厦门海沧假日酒店",
            location: "厦门市海沧区海沧大道1888号",
            price: 588.0,
            rating: 4.1,
            amenities: [.wifi, .pool, .restaurant, .breakfast, .airConditioning],
            images: [
                "https://example.com/holidayinn1.jpg",
                "https://example.com/holidayinn2.jpg"
            ],
            description: "海滨度假酒店，拥有私人沙滩和丰富的娱乐设施。",
            latitude: 24.4451,
            longitude: 118.0394,
            roomTypes: [
                RoomType(id: "rt_008_1", name: "海景房", capacity: 2, price: 588.0, description: "直面大海，风景如画"),
                RoomType(id: "rt_008_2", name: "家庭房", capacity: 4, price: 888.0, description: "宽敞舒适，适合家庭")
            ],
            contactInfo: ContactInfo(
                phone: "+86-592-608-8888",
                email: "xiamen@holidayinn.com",
                address: "厦门市海沧区海沧大道1888号"
            )
        )
    }
    
    private static func createRadisson() -> HotelPackage {
        return HotelPackage(
            id: "hotel_009",
            name: "重庆解放碑华美达广场酒店",
            location: "重庆市渝中区民族路168号",
            price: 728.0,
            rating: 4.0,
            amenities: [.wifi, .restaurant, .breakfast, .airConditioning],
            images: [
                "https://example.com/radisson1.jpg"
            ],
            description: "位于重庆核心商圈，购物餐饮便利，是商务出行的好选择。",
            latitude: 29.5596,
            longitude: 106.5713,
            roomTypes: [
                RoomType(id: "rt_009_1", name: "城市景观房", capacity: 2, price: 728.0, description: "俯瞰城市繁华景象"),
                RoomType(id: "rt_009_2", name: "豪华套房", capacity: 3, price: 1128.0, description: "精致装修，品质享受")
            ],
            contactInfo: ContactInfo(
                phone: "+86-23-6370-9999",
                email: "chongqing@radisson.com",
                address: "重庆市渝中区民族路168号"
            )
        )
    }
    
    private static func createNovotel() -> HotelPackage {
        return HotelPackage(
            id: "hotel_010",
            name: "苏州金鸡湖诺富特酒店",
            location: "苏州市工业园区星港街168号",
            price: 658.0,
            rating: 4.3,
            amenities: [.wifi, .pool, .restaurant, .breakfast, .airConditioning],
            images: [
                "https://example.com/novotel1.jpg",
                "https://example.com/novotel2.jpg"
            ],
            description: "坐落于金鸡湖畔，环境优雅，是休闲度假的理想去处。",
            latitude: 31.3152,
            longitude: 120.6305,
            roomTypes: [
                RoomType(id: "rt_010_1", name: "湖景房", capacity: 2, price: 658.0, description: "金鸡湖美景尽收眼底"),
                RoomType(id: "rt_010_2", name: "亲子套房", capacity: 4, price: 958.0, description: "专为家庭设计")
            ],
            contactInfo: ContactInfo(
                phone: "+86-512-6288-8888",
                email: "suzhou@novotel.com",
                address: "苏州市工业园区星港街168号"
            )
        )
    }
}