//
//  BaseViewController.swift
//  HotelBookingDemo
//
//  Created by Builder on 2024.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        bindViewModel()
    }
    
    // 子类重写的方法
    func setupUI() {
        // 设置基础UI元素
        view.backgroundColor = .systemBackground
    }
    
    func setupConstraints() {
        // 设置自动布局约束
    }
    
    func bindViewModel() {
        // 绑定ViewModel
    }
}