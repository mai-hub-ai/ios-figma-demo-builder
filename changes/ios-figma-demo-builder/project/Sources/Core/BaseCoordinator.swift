//
//  BaseCoordinator.swift
//  HotelBookingDemo
//
//  Created by Builder on 2024.
//

import UIKit

class BaseCoordinator: CoordinatorType {
    var navigationController: UINavigationController
    var childCoordinators: [CoordinatorType] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        // 子类需要重写此方法
        fatalError("Start method must be overridden")
    }
    
    func addChild(_ coordinator: CoordinatorType) {
        childCoordinators.append(coordinator)
    }
    
    func removeChild(_ coordinator: CoordinatorType) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}