//
//  DIContainer.swift
//  HotelBookingDemo
//
//  Created by Builder on 2024.
//

import Foundation

class DIContainer {
    static let shared = DIContainer()
    
    private init() {}
    
    // 服务注册表
    private var services: [String: Any] = [:]
    
    func register<Service>(_ service: Service, for type: Service.Type) {
        let key = String(describing: type)
        services[key] = service
    }
    
    func resolve<Service>(_ type: Service.Type) -> Service? {
        let key = String(describing: type)
        return services[key] as? Service
    }
}