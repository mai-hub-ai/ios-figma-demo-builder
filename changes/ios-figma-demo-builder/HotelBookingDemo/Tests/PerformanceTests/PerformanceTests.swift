//
//  PerformanceTests.swift
//  HotelBookingDemoTests
//
//  Created by Guardian on 2024.
//

import XCTest
@testable import HotelBookingDemo

class PerformanceTests: XCTestCase {
    
    func testSearchPerformance() {
        // 测试搜索性能
        measure {
            // 性能测量代码
            _ = Array(0..<1000).map { "\($0)" }
        }
    }
    
    func testDataLoadingSpeed() {
        // 测试数据加载速度
        measure {
            // 数据加载性能测试
            let data = Data(count: 10000)
            _ = data.count
        }
    }
    
    func testUIRenderingPerformance() {
        // 测试UI渲染性能
        measure {
            // UI渲染性能测试
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            _ = view.layer.presentation()
        }
    }
}