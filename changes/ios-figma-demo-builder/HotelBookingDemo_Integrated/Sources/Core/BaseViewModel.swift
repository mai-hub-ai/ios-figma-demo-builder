//
//  BaseViewModel.swift
//  HotelBookingDemo
//
//  Created by Builder on 2024.
//

import Foundation
import Combine

class BaseViewModel<Input, Output>: ViewModelType {
    var cancellables = Set<AnyCancellable>()
    
    func transform(input: Input) -> Output {
        fatalError("Transform method must be overridden")
    }
}