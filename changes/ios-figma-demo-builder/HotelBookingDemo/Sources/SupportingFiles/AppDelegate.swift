//
//  AppDelegate.swift
//  HotelBookingDemo
//
//  Created by Builder on 2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // 创建标签栏控制器展示多个demo
        let tabBarController = UITabBarController()
        
        // Figma CSS Demo
        let figmaDemoVC = FigmaCSSDemoViewController()
        figmaDemoVC.tabBarItem = UITabBarItem(title: "Figma转换", image: UIImage(systemName: "wand.and.stars"), tag: 0)
        
        // Designer完整demo
        let designerDemoVC = DesignerDay2DemoViewController()
        designerDemoVC.tabBarItem = UITabBarItem(title: "完整组件", image: UIImage(systemName: "paintbrush"), tag: 1)
        
        tabBarController.viewControllers = [figmaDemoVC, designerDemoVC]
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }
}