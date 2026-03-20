//
//  CoordinatorType.swift
//  HotelBookingDemo
//
//  Created by Builder on 2024.
//

import UIKit

protocol CoordinatorType: AnyObject {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [CoordinatorType] { get set }
    
    func start()
    func addChild(_ coordinator: CoordinatorType)
    func removeChild(_ coordinator: CoordinatorType)
}