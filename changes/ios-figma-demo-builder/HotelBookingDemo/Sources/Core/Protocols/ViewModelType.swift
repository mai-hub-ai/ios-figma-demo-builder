//
//  ViewModelType.swift
//  HotelBookingDemo
//
//  Created by Builder on 2024.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}