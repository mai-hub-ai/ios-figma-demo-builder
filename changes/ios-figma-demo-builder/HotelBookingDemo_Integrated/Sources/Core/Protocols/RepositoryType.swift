//
//  RepositoryType.swift
//  HotelBookingDemo
//
//  Created by Builder on 2024.
//

import Foundation

protocol RepositoryType {
    associatedtype Entity
    associatedtype Query
    
    func fetch(with query: Query?) -> [Entity]
    func save(_ entity: Entity) -> Bool
    func delete(_ entity: Entity) -> Bool
}