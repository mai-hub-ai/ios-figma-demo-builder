//
//  ArchitectureTests.swift
//  HotelBookingDemoTests
//
//  Created by Builder on 2024.
//

import XCTest
@testable import HotelBookingDemo

class ArchitectureTests: XCTestCase {

    func testBaseCoordinatorInitialization() {
        let navigationController = UINavigationController()
        let coordinator = BaseCoordinator(navigationController: navigationController)
        
        XCTAssertNotNil(coordinator)
        XCTAssertEqual(coordinator.childCoordinators.count, 0)
        XCTAssertTrue(coordinator.navigationController === navigationController)
    }
    
    func testDIContainerRegistration() {
        let container = DIContainer.shared
        
        let mockService = "Test Service"
        container.register(mockService, for: String.self)
        
        let resolvedService = container.resolve(String.self)
        XCTAssertEqual(resolvedService, mockService)
    }
    
    func testViewModelTypeProtocol() {
        // 测试协议存在性
        XCTAssertTrue(ViewModelType.self is Any.Type)
    }
    
    func testCoordinatorTypeProtocol() {
        // 测试协议存在性
        XCTAssertTrue(CoordinatorType.self is AnyObject.Protocol)
    }
}