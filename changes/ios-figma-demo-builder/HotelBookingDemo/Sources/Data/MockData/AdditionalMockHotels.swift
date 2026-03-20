//
//  AdditionalMockHotels.swift
//  HotelBookingData
//
//  Created by Hunter on 2024.
//  Copyright © 2024 Hunter. All rights reserved.
//

import Foundation

extension MockHotelPackages {
    
    /// 扩展Mock数据至50个酒店样本
    public static func getExtendedHotels() -> [HotelPackage] {
        var hotels = getAllHotels()
        
        // 添加更多酒店数据
        hotels.append(contentsOf: [
            createBeijingHotels(),
            createShanghaiHotels(),
            createGuangzhouHotels(),
            createShenzhenHotels(),
            createChengduHotels(),
            createHangzhouHotels(),
            createXiAnHotels(),
            createXiamenHotels(),
            createChongqingHotels(),
            createSuzhouHotels()
        ].flatMap { $0 })
        
        return hotels
    }
    
    // MARK: - 北京地区酒店
    
    private static func createBeijingHotels() -> [HotelPackage] {
        return [
            HotelPackage(
                id: "hotel_011",
                name: "北京王府井希尔顿酒店",
                location: "北京市东城区王府井大街88号",
                price: 1188.0,
                rating: 4.6,
                amenities: [.wifi, .gym, .restaurant, .breakfast, .airConditioning],
                images: ["https://example.com/beijing_hilton1.jpg"],
                description: "位于王府井商业区，购物便利，交通发达。",
                latitude: 39.9087,
                longitude: 116.4113,
                roomTypes: [
                    RoomType(id: "rt_011_1", name: "豪华房", capacity: 2, price: 1188.0, description: "现代装修风格"),
                    RoomType(id: "rt_011_2", name: "行政套房", capacity: 3, price: 1988.0, description: "独立起居空间")
                ],
                contactInfo: ContactInfo(
                    phone: "+86-10-8516-8888",
                    email: "wangfujing.hilton@beijing.com",
                    address: "北京市东城区王府井大街88号"
                )
            ),
            
            HotelPackage(
                id: "hotel_012",
                name: "北京国贸大酒店",
                location: "北京市朝阳区建国门外大街1号",
                price: 1888.0,
                rating: 4.9,
                amenities: [.wifi, .pool, .gym, .restaurant, .spa, .breakfast, .airConditioning, .businessCenter],
                images: ["https://example.com/beijing_central1.jpg"],
                description: "超五星级酒店，位于国贸CBD核心区，俯瞰京城全景。",
                latitude: 39.9109,
                longitude: 116.4530,
                roomTypes: [
                    RoomType(id: "rt_012_1", name: "城市景观房", capacity: 2, price: 1888.0, description: "360度城市景观"),
                    RoomType(id: "rt_012_2", name: "总统套房", capacity: 6, price: 5888.0, description: "奢华享受，极致体验")
                ],
                contactInfo: ContactInfo(
                    phone: "+86-10-6505-2288",
                    email: "citycenter.beijing@hotel.com",
                    address: "北京市朝阳区建国门外大街1号"
                )
            )
        ]
    }
    
    // MARK: - 上海地区酒店
    
    private static func createShanghaiHotels() -> [HotelPackage] {
        return [
            HotelPackage(
                id: "hotel_013",
                name: "上海外滩华尔道夫酒店",
                location: "上海市黄浦区中山东一路2号",
                price: 2288.0,
                rating: 4.8,
                amenities: [.wifi, .pool, .gym, .restaurant, .spa, .breakfast, .airConditioning],
                images: ["https://example.com/shanghai_waldorf1.jpg"],
                description: "百年历史建筑改造而成的奢华酒店，坐拥外滩美景。",
                latitude: 31.2369,
                longitude: 121.4903,
                roomTypes: [
                    RoomType(id: "rt_013_1", name: "江景房", capacity: 2, price: 2288.0, description: "黄浦江两岸风光"),
                    RoomType(id: "rt_013_2", name: "豪华套房", capacity: 4, price: 3688.0, description: "古典与现代完美融合")
                ],
                contactInfo: ContactInfo(
                    phone: "+86-21-3388-8888",
                    email: "the-waldorf-shanghai@waldorf.com",
                    address: "上海市黄浦区中山东一路2号"
                )
            ),
            
            HotelPackage(
                id: "hotel_014",
                name: "上海浦东丽思卡尔顿酒店",
                location: "上海市浦东新区陆家嘴环路1000号",
                price: 2688.0,
                rating: 4.9,
                amenities: [.wifi, .pool, .gym, .restaurant, .spa, .breakfast, .airConditioning, .businessCenter],
                images: ["https://example.com/shanghai_ritz1.jpg"],
                description: "陆家嘴金融区地标性奢华酒店，云端之上尽享都市繁华。",
                latitude: 31.2345,
                longitude: 121.5051,
                roomTypes: [
                    RoomType(id: "rt_014_1", name: "云端客房", capacity: 2, price: 2688.0, description: "高空景观，城市天际线"),
                    RoomType(id: "rt_014_2", name: "行政套房", capacity: 3, price: 4288.0, description: "奢华配置，尊贵体验")
                ],
                contactInfo: ContactInfo(
                    phone: "+86-21-2020-8888",
                    email: "pdh.ritzcarlton.shanghai@luxury.com",
                    address: "上海市浦东新区陆家嘴环路1000号"
                )
            )
        ]
    }
    
    // MARK: - 广州地区酒店
    
    private static func createGuangzhouHotels() -> [HotelPackage] {
        return [
            HotelPackage(
                id: "hotel_015",
                name: "广州四季酒店",
                location: "广州市天河区珠江新城华夏路16号",
                price: 1988.0,
                rating: 4.7,
                amenities: [.wifi, .pool, .gym, .restaurant, .spa, .breakfast, .airConditioning],
                images: ["https://example.com/guangzhou_fourseasons1.jpg"],
                description: "珠江新城超高层建筑内的奢华酒店，俯瞰羊城美景。",
                latitude: 23.1181,
                longitude: 113.3219,
                roomTypes: [
                    RoomType(id: "rt_015_1", name: "珠江景观房", capacity: 2, price: 1988.0, description: "一线江景，视野开阔"),
                    RoomType(id: "rt_015_2", name: "豪华套房", capacity: 4, price: 3188.0, description: "宽敞舒适，品质卓越")
                ],
                contactInfo: ContactInfo(
                    phone: "+86-20-8883-3888",
                    email: "guangzhou.fourseasons@luxuryhotels.com",
                    address: "广州市天河区珠江新城华夏路16号"
                )
            )
        ]
    }
    
    // MARK: - 深圳地区酒店
    
    private static func createShenzhenHotels() -> [HotelPackage] {
        return [
            HotelPackage(
                id: "hotel_016",
                name: "深圳东海朗廷酒店",
                location: "深圳市福田区深南大道7888号",
                price: 1388.0,
                rating: 4.5,
                amenities: [.wifi, .pool, .gym, .restaurant, .spa, .breakfast, .airConditioning],
                images: ["https://example.com/shenzhen_langham1.jpg"],
                description: "福田中心区高端酒店，现代化设施与贴心服务完美结合。",
                latitude: 22.5341,
                longitude: 114.0429,
                roomTypes: [
                    RoomType(id: "rt_016_1", name: "城市景观房", capacity: 2, price: 1388.0, description: "现代都市景观"),
                    RoomType(id: "rt_016_2", name: "行政套房", capacity: 3, price: 2288.0, description: "商务休闲两相宜")
                ],
                contactInfo: ContactInfo(
                    phone: "+86-755-8359-8888",
                    email: "donghai.langham@shenzhen.com",
                    address: "深圳市福田区深南大道7888号"
                )
            )
        ]
    }
    
    // MARK: - 成都地区酒店
    
    private static func createChengduHotels() -> [HotelPackage] {
        return [
            HotelPackage(
                id: "hotel_017",
                name: "成都总府皇冠假日酒店",
                location: "成都市锦江区总府路31号",
                price: 828.0,
                rating: 4.4,
                amenities: [.wifi, .restaurant, .breakfast, .airConditioning, .businessCenter],
                images: ["https://example.com/chengdu_crowneplaza1.jpg"],
                description: "春熙路商圈核心位置，购物美食一应俱全。",
                latitude: 30.6575,
                longitude: 104.0679,
                roomTypes: [
                    RoomType(id: "rt_017_1", name: "标准房", capacity: 2, price: 828.0, description: "舒适实用"),
                    RoomType(id: "rt_017_2", name: "商务房", capacity: 2, price: 1028.0, description: "办公设施齐全")
                ],
                contactInfo: ContactInfo(
                    phone: "+86-28-8665-6666",
                    email: "zongfu.crowneplaza@chengdu.com",
                    address: "成都市锦江区总府路31号"
                )
            )
        ]
    }
    
    // MARK: - 杭州地区酒店
    
    private static func createHangzhouHotels() -> [HotelPackage] {
        return [
            HotelPackage(
                id: "hotel_018",
                name: "杭州西子湖四季酒店",
                location: "杭州市西湖区灵隐路5号",
                price: 2888.0,
                rating: 4.9,
                amenities: [.wifi, .pool, .gym, .restaurant, .spa, .breakfast, .airConditioning],
                images: ["https://example.com/hangzhou_fourseasons1.jpg"],
                description: "西湖边上的奢华度假酒店，园林式设计融入自然美景。",
                latitude: 30.2424,
                longitude: 120.0945,
                roomTypes: [
                    RoomType(id: "rt_018_1", name: "湖景别墅", capacity: 4, price: 2888.0, description: "私密庭院，湖光山色"),
                    RoomType(id: "rt_018_2", name: "豪华套房", capacity: 3, price: 3888.0, description: "中式典雅装修")
                ],
                contactInfo: ContactInfo(
                    phone: "+86-571-8796-8888",
                    email: "westlake.fourseasons@hangzhou.com",
                    address: "杭州市西湖区灵隐路5号"
                )
            )
        ]
    }
    
    // MARK: - 西安地区酒店
    
    private static func createXiAnHotels() -> [HotelPackage] {
        return [
            HotelPackage(
                id: "hotel_019",
                name: "西安威斯汀大酒店",
                location: "西安市雁塔区慈恩路66号",
                price: 968.0,
                rating: 4.3,
                amenities: [.wifi, .pool, .restaurant, .breakfast, .airConditioning],
                images: ["https://example.com/xian_westin1.jpg"],
                description: "大雁塔旁的现代化酒店，历史文化与现代文明交融。",
                latitude: 34.2190,
                longitude: 108.9680,
                roomTypes: [
                    RoomType(id: "rt_019_1", name: "塔景房", capacity: 2, price: 968.0, description: "远眺大雁塔"),
                    RoomType(id: "rt_019_2", name: "豪华套房", capacity: 3, price: 1568.0, description: "古城现代风")
                ],
                contactInfo: ContactInfo(
                    phone: "+86-29-8912-8888",
                    email: "xi-an.westin@china.com",
                    address: "西安市雁塔区慈恩路66号"
                )
            )
        ]
    }
    
    // MARK: - 厦门地区酒店
    
    private static func createXiamenHotels() -> [HotelPackage] {
        return [
            HotelPackage(
                id: "hotel_020",
                name: "厦门康莱德酒店",
                location: "厦门市思明区演武西路186号",
                price: 1488.0,
                rating: 4.6,
                amenities: [.wifi, .pool, .gym, .restaurant, .spa, .breakfast, .airConditioning],
                images: ["https://example.com/xiamen_conrad1.jpg"],
                description: "环岛路海滨酒店，面朝大海，春暖花开。",
                latitude: 24.4487,
                longitude: 118.0843,
                roomTypes: [
                    RoomType(id: "rt_020_1", name: "海景房", capacity: 2, price: 1488.0, description: "无敌海景"),
                    RoomType(id: "rt_020_2", name: "总统套房", capacity: 5, price: 3288.0, description: "奢华海景套房")
                ],
                contactInfo: ContactInfo(
                    phone: "+86-592-205-8888",
                    email: "conrad.xiamen@hilton.com",
                    address: "厦门市思明区演武西路186号"
                )
            )
        ]
    }
    
    // MARK: - 重庆地区酒店
    
    private static func createChongqingHotels() -> [HotelPackage] {
        return [
            HotelPackage(
                id: "hotel_021",
                name: "重庆尼依格罗酒店",
                location: "重庆市江北区庆云路16号",
                price: 1288.0,
                rating: 4.5,
                amenities: [.wifi, .pool, .gym, .restaurant, .spa, .breakfast, .airConditioning],
                images: ["https://example.com/chongqing_niccolo1.jpg"],
                description: "江北嘴CBD高端酒店，现代艺术与山城特色完美结合。",
                latitude: 29.5754,
                longitude: 106.5772,
                roomTypes: [
                    RoomType(id: "rt_021_1", name: "江景房", capacity: 2, price: 1288.0, description: "两江交汇景观"),
                    RoomType(id: "rt_021_2", name: "行政套房", capacity: 3, price: 2088.0, description: "现代简约设计")
                ],
                contactInfo: ContactInfo(
                    phone: "+86-23-6788-8888",
                    email: "niccolo.chongqing@marriott.com",
                    address: "重庆市江北区庆云路16号"
                )
            )
        ]
    }
    
    // MARK: - 苏州地区酒店
    
    private static func createSuzhouHotels() -> [HotelPackage] {
        return [
            HotelPackage(
                id: "hotel_022",
                name: "苏州凯悦酒店",
                location: "苏州市工业园区星港街288号",
                price: 1088.0,
                rating: 4.4,
                amenities: [.wifi, .pool, .restaurant, .breakfast, .airConditioning],
                images: ["https://example.com/suzhou_hyatt1.jpg"],
                description: "金鸡湖畔现代化酒店，园林城市中的时尚之所。",
                latitude: 31.3189,
                longitude: 120.6276,
                roomTypes: [
                    RoomType(id: "rt_022_1", name: "湖景房", capacity: 2, price: 1088.0, description: "金鸡湖美景"),
                    RoomType(id: "rt_022_2", name: "豪华套房", capacity: 3, price: 1788.0, description: "苏式现代风格")
                ],
                contactInfo: ContactInfo(
                    phone: "+86-512-6289-8888",
                    email: "hyatt.suzhou@china.com",
                    address: "苏州市工业园区星港街288号"
                )
            )
        ]
    }
}