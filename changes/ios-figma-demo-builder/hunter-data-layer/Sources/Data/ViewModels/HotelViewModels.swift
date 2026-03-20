//
//  HotelListViewModel.swift
//  HotelBookingData
//
//  Created by Hunter on 2024.
//  Copyright © 2024 Hunter. All rights reserved.
//

import Foundation
import Combine

/// 酒店列表视图模型
public class HotelListViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published public private(set) var hotels: [HotelPackage] = []
    @Published public private(set) var isLoading: Bool = false
    @Published public private(set) var errorMessage: String?
    @Published public private(set) var searchFilters: SearchFilters = SearchFilters()
    @Published public private(set) var userRequirements: UserRequirements?
    
    // MARK: - Private Properties
    private let searchUseCase: HotelSearchUseCase
    private let recommendationEngine: RecommendationEngine
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    public init(
        searchUseCase: HotelSearchUseCase,
        recommendationEngine: RecommendationEngine
    ) {
        self.searchUseCase = searchUseCase
        self.recommendationEngine = recommendationEngine
    }
    
    // MARK: - Public Methods
    
    /// 搜索酒店
    public func searchHotels(with requirements: UserRequirements) {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        userRequirements = requirements
        
        Task {
            do {
                let results = try await searchUseCase.searchHotels(for: requirements)
                await MainActor.run {
                    self.hotels = results
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    /// 获取推荐酒店
    public func loadRecommendedHotels(for requirements: UserRequirements) {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        userRequirements = requirements
        
        Task {
            do {
                let recommendations = try await recommendationEngine.recommendHotels(for: requirements)
                await MainActor.run {
                    self.hotels = recommendations
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    /// 更新搜索过滤器
    public func updateSearchFilters(_ filters: SearchFilters) {
        searchFilters = filters
        // 如果已有用户需求，重新搜索
        if let requirements = userRequirements {
            searchHotels(with: requirements)
        }
    }
    
    /// 清除搜索结果
    public func clearSearchResults() {
        hotels = []
        errorMessage = nil
        userRequirements = nil
    }
    
    /// 重新加载数据
    public func reloadData() {
        if let requirements = userRequirements {
            searchHotels(with: requirements)
        }
    }
    
    // MARK: - Computed Properties
    
    /// 是否有搜索结果
    public var hasResults: Bool {
        return !hotels.isEmpty
    }
    
    /// 结果统计
    public var resultStatistics: SearchResultStatistics? {
        guard hasResults, let requirements = userRequirements else { return nil }
        
        let totalResults = hotels.count
        let averagePrice = hotels.reduce(0.0) { $0 + $0.price } / Double(totalResults)
        let averageRating = hotels.reduce(0.0) { $0 + $0.rating } / Double(totalResults)
        
        let prices = hotels.map { $0.price }
        let priceRange = (min: prices.min() ?? 0, max: prices.max() ?? 0)
        
        var ratingDistribution: [Double: Int] = [:]
        for hotel in hotels {
            let roundedRating = round(hotel.rating * 2) / 2
            ratingDistribution[roundedRating, default: 0] += 1
        }
        
        return SearchResultStatistics(
            totalResults: totalResults,
            averagePrice: averagePrice,
            averageRating: averageRating,
            priceRange: priceRange,
            ratingDistribution: ratingDistribution
        )
    }
}

// MARK: - 酒店详情视图模型

/// 酒店详情视图模型
public class HotelDetailViewModel: ObservableObject {
    
    @Published public private(set) var hotel: HotelPackage?
    @Published public private(set) var isLoading: Bool = false
    @Published public private(set) var errorMessage: String?
    @Published public private(set) var isBookmarked: Bool = false
    
    private let repository: HotelRepository
    
    public init(repository: HotelRepository) {
        self.repository = repository
    }
    
    /// 加载酒店详情
    public func loadHotelDetails(by id: String) {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let hotel = try await repository.getHotel(by: id)
                await MainActor.run {
                    self.hotel = hotel
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    /// 切换收藏状态
    public func toggleBookmark() {
        isBookmarked.toggle()
        // 这里可以添加实际的收藏逻辑
    }
    
    /// 预订酒店
    public func bookHotel(for dates: (checkIn: Date, checkOut: Date), guests: Int) {
        guard let hotel = hotel else { return }
        
        // 这里实现预订逻辑
        print("预订酒店: \(hotel.name)")
        print("入住: \(dates.checkIn), 退房: \(dates.checkOut), 人数: \(guests)")
    }
}

// MARK: - 搜索视图模型

/// 搜索视图模型
public class SearchViewModel: ObservableObject {
    
    @Published public private(set) var searchResults: [HotelPackage] = []
    @Published public private(set) var isLoading: Bool = false
    @Published public private(set) var errorMessage: String?
    @Published public var searchText: String = ""
    @Published public var destination: String = ""
    @Published public var checkInDate: Date = Date()
    @Published public var checkOutDate: Date = Date().addingTimeInterval(86400 * 2) // 默认2天
    @Published public var guests: Int = 2
    @Published public var rooms: Int = 1
    
    private let searchUseCase: HotelSearchUseCase
    private var searchCancellable: AnyCancellable?
    
    public init(searchUseCase: HotelSearchUseCase) {
        self.searchUseCase = searchUseCase
        
        // 设置搜索防抖
        setupSearchDebounce()
    }
    
    private func setupSearchDebounce() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] text in
                if !text.isEmpty {
                    self?.performSearch()
                }
            }
            .store(in: &cancellables)
    }
    
    /// 执行搜索
    public func performSearch() {
        guard !searchText.isEmpty || !destination.isEmpty else { return }
        
        isLoading = true
        errorMessage = nil
        
        let requirements = UserRequirements(
            destination: destination.isEmpty ? searchText : destination,
            checkInDate: checkInDate,
            checkOutDate: checkOutDate,
            guests: guests,
            rooms: rooms,
            preferences: []
        )
        
        Task {
            do {
                let results = try await searchUseCase.searchHotels(for: requirements)
                await MainActor.run {
                    self.searchResults = results
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    /// 清除搜索
    public func clearSearch() {
        searchText = ""
        destination = ""
        searchResults = []
        errorMessage = nil
    }
}