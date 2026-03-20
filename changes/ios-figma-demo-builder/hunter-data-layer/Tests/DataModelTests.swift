//
//  HotelPackageTests.swift
//  HotelBookingDataTests
//
//  Created by Hunter on 2024.
//  Copyright © 2024 Hunter. All rights reserved.
//

import XCTest
@testable import HotelBookingData

final class HotelPackageTests: XCTestCase {
    
    func testHotelPackageInitialization() {
        // Given
        let priceInfo = PriceInfo(basePrice: 1000, totalPrice: 1100, pricePerNight: 1000)
        let ratingInfo = RatingInfo(overallRating: 4.5, reviewCount: 100)
        let amenities: [Amenity] = [.wifi, .pool]
        let images = [ImageInfo(url: "test.jpg")]
        let roomTypes = [RoomType(id: "1", name: "Standard", capacity: 2, price: 1000, description: "Test")]
        let contactInfo = ContactInfo(phone: "123", email: "test@test.com", address: "Test Address")
        let availabilityInfo = AvailabilityInfo(
            checkInDate: Date(),
            checkOutDate: Date().addingTimeInterval(86400),
            availableRooms: 5,
            maxGuests: 4
        )
        
        // When
        let hotel = HotelPackage(
            id: "test_hotel",
            name: "Test Hotel",
            location: "Test Location",
            priceInfo: priceInfo,
            ratingInfo: ratingInfo,
            amenities: amenities,
            images: images,
            description: "Test Description",
            latitude: 39.9042,
            longitude: 116.4074,
            roomTypes: roomTypes,
            contactInfo: contactInfo,
            availabilityInfo: availabilityInfo
        )
        
        // Then
        XCTAssertEqual(hotel.id, "test_hotel")
        XCTAssertEqual(hotel.name, "Test Hotel")
        XCTAssertEqual(hotel.price, 1100)
        XCTAssertEqual(hotel.rating, 4.5)
        XCTAssertTrue(hotel.hasAmenity(.wifi))
        XCTAssertFalse(hotel.hasAmenity(.gym))
    }
    
    func testHotelPriceDisplay() {
        // Given
        let priceInfo = PriceInfo(basePrice: 1288, totalPrice: 1416.8, pricePerNight: 1288)
        let hotel = createTestHotel(priceInfo: priceInfo)
        
        // When
        let displayPrice = hotel.priceDisplay
        
        // Then
        XCTAssertEqual(displayPrice, "¥1417")
    }
    
    func testHotelHasAvailability() {
        // Given
        let availabilityInfo = AvailabilityInfo(
            checkInDate: Date(),
            checkOutDate: Date().addingTimeInterval(86400),
            availableRooms: 3,
            maxGuests: 4
        )
        let hotel = createTestHotel(availabilityInfo: availabilityInfo)
        
        // When & Then
        XCTAssertTrue(hotel.hasAvailability)
    }
    
    func testHotelNoAvailability() {
        // Given
        let availabilityInfo = AvailabilityInfo(
            checkInDate: Date(),
            checkOutDate: Date().addingTimeInterval(86400),
            availableRooms: 0,
            maxGuests: 4
        )
        let hotel = createTestHotel(availabilityInfo: availabilityInfo)
        
        // When & Then
        XCTAssertFalse(hotel.hasAvailability)
    }
    
    // MARK: - Helper Methods
    
    private func createTestHotel(
        priceInfo: PriceInfo = PriceInfo(basePrice: 1000, totalPrice: 1100, pricePerNight: 1000),
        ratingInfo: RatingInfo = RatingInfo(overallRating: 4.0, reviewCount: 50),
        availabilityInfo: AvailabilityInfo = AvailabilityInfo(
            checkInDate: Date(),
            checkOutDate: Date().addingTimeInterval(86400),
            availableRooms: 2,
            maxGuests: 4
        )
    ) -> HotelPackage {
        return HotelPackage(
            id: "test",
            name: "Test Hotel",
            location: "Test Location",
            priceInfo: priceInfo,
            ratingInfo: ratingInfo,
            amenities: [.wifi],
            images: [ImageInfo(url: "test.jpg")],
            description: "Test",
            latitude: 0,
            longitude: 0,
            roomTypes: [],
            contactInfo: ContactInfo(phone: "", email: "", address: ""),
            availabilityInfo: availabilityInfo
        )
    }
}

final class PriceInfoTests: XCTestCase {
    
    func testPriceInfoCalculations() {
        // Given
        let priceInfo = PriceInfo(
            basePrice: 1000,
            taxesAndFees: 100,
            totalPrice: 1100,
            pricePerNight: 1000
        )
        
        // When & Then
        XCTAssertEqual(priceInfo.displayPrice, "¥1100")
        XCTAssertEqual(priceInfo.nightlyPriceDisplay, "¥1000/晚")
        XCTAssertFalse(priceInfo.hasDiscount)
        XCTAssertNil(priceInfo.discountPercentage)
    }
    
    func testPriceInfoWithDiscount() {
        // Given
        let priceInfo = PriceInfo(
            basePrice: 1000,
            taxesAndFees: 100,
            discount: 100,
            totalPrice: 1000,
            pricePerNight: 1000
        )
        
        // When & Then
        XCTAssertTrue(priceInfo.hasDiscount)
        XCTAssertEqual(priceInfo.discountPercentage, 10.0)
    }
}

final class RatingInfoTests: XCTestCase {
    
    func testRatingInfoLevels() {
        // Given
        let excellentRating = RatingInfo(overallRating: 4.8, reviewCount: 100)
        let goodRating = RatingInfo(overallRating: 3.5, reviewCount: 50)
        let poorRating = RatingInfo(overallRating: 1.5, reviewCount: 10)
        
        // When & Then
        XCTAssertEqual(excellentRating.ratingLevel, .excellent)
        XCTAssertTrue(excellentRating.isHighRated)
        
        XCTAssertEqual(goodRating.ratingLevel, .good)
        XCTAssertFalse(goodRating.isHighRated)
        
        XCTAssertEqual(poorRating.ratingLevel, .poor)
        XCTAssertFalse(poorRating.isHighRated)
    }
    
    func testRatingDisplay() {
        // Given
        let ratingInfo = RatingInfo(overallRating: 4.33, reviewCount: 75)
        
        // When
        let display = ratingInfo.displayRating
        
        // Then
        XCTAssertEqual(display, "4.3")
    }
}