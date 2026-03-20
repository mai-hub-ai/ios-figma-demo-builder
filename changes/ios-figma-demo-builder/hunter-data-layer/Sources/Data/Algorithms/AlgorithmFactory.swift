//
//  AlgorithmFactory.swift
//  HotelBookingData
//
//  Created by Hunter on 2024.
//  Copyright © 2024 Hunter. All rights reserved.
//

import Foundation

/// 算法工厂类
public class AlgorithmFactory {
    
    public enum AlgorithmType {
        case `default`
        case advanced
        case custom(weights: ScoringWeights)
        
        public static let `default`: AlgorithmType = .default
    }
    
    private static var shared: AlgorithmFactory?
    private var algorithms: [String: (scoring: ScoringAlgorithm, sorting: SortingAlgorithm)] = [:]
    
    /// 获取单例实例
    public static func shared() -> AlgorithmFactory {
        if shared == nil {
            shared = AlgorithmFactory()
        }
        return shared!
    }
    
    /// 私有初始化方法
    private init() {}
    
    /// 获取评分算法
    public func getScoringAlgorithm(type: AlgorithmType = .default) -> ScoringAlgorithm {
        let (scoringAlgorithm, _) = getAlgorithmPair(type: type)
        return scoringAlgorithm
    }
    
    /// 获取排序算法
    public func getSortingAlgorithm(type: AlgorithmType = .default) -> SortingAlgorithm {
        let (_, sortingAlgorithm) = getAlgorithmPair(type: type)
        return sortingAlgorithm
    }
    
    /// 获取算法对
    public func getAlgorithmPair(
        type: AlgorithmType = .default
    ) -> (scoring: ScoringAlgorithm, sorting: SortingAlgorithm) {
        let key = typeKey(for: type)
        
        if let existingPair = algorithms[key] {
            return existingPair
        }
        
        let newPair: (ScoringAlgorithm, SortingAlgorithm)
        switch type {
        case .default:
            newPair = (DefaultScoringAlgorithm(), DefaultSortingAlgorithm())
            
        case .advanced:
            newPair = (DefaultScoringAlgorithm(), AdvancedSortingAlgorithm())
            
        case .custom(let weights):
            let customScoring = CustomWeightedScoringAlgorithm(weights: weights)
            newPair = (customScoring, DefaultSortingAlgorithm())
        }
        
        algorithms[key] = newPair
        return newPair
    }
    
    /// 清除缓存的算法
    public func clearCache() {
        algorithms.removeAll()
    }
    
    /// 移除特定类型的算法
    public func removeAlgorithm(type: AlgorithmType) {
        let key = typeKey(for: type)
        algorithms.removeValue(forKey: key)
    }
    
    // MARK: - 私有方法
    
    private func typeKey(for type: AlgorithmType) -> String {
        switch type {
        case .default:
            return "default"
        case .advanced:
            return "advanced"
        case .custom(let weights):
            return "custom_\(weights.rating)_\(weights.price)_\(weights.amenities)"
        }
    }
}

// MARK: - 自定义权重评分算法

/// 支持自定义权重的评分算法
public class CustomWeightedScoringAlgorithm: ScoringAlgorithm {
    
    private let weights: ScoringWeights
    private let baseAlgorithm = DefaultScoringAlgorithm()
    
    public init(weights: ScoringWeights) {
        self.weights = weights
    }
    
    public func calculateScore(for hotel: HotelPackage, with context: ScoringContext) -> Double {
        // 使用自定义权重创建新的上下文
        let customContext = ScoringContext(
            userRequirements: context.userRequirements,
            searchFilters: context.searchFilters,
            weights: weights,
            currentDate: context.currentDate
        )
        
        return baseAlgorithm.calculateScore(for: hotel, with: customContext)
    }
    
    public func calculateScores(
        for hotels: [HotelPackage],
        with context: ScoringContext
    ) -> [HotelPackage: Double] {
        let customContext = ScoringContext(
            userRequirements: context.userRequirements,
            searchFilters: context.searchFilters,
            weights: weights,
            currentDate: context.currentDate
        )
        
        return baseAlgorithm.calculateScores(for: hotels, with: customContext)
    }
}

// MARK: - 算法配置管理器

/// 算法配置管理器
public class AlgorithmConfigurationManager {
    
    public static let shared = AlgorithmConfigurationManager()
    
    private var configurations: [String: AlgorithmConfiguration] = [:]
    
    private init() {
        // 初始化默认配置
        setupDefaultConfigurations()
    }
    
    /// 获取配置
    public func getConfiguration(named name: String) -> AlgorithmConfiguration? {
        return configurations[name]
    }
    
    /// 注册新配置
    public func registerConfiguration(_ configuration: AlgorithmConfiguration, named name: String) {
        configurations[name] = configuration
    }
    
    /// 获取所有配置名称
    public func availableConfigurations() -> [String] {
        return Array(configurations.keys)
    }
    
    private func setupDefaultConfigurations() {
        // 价格敏感型配置
        let priceSensitive = AlgorithmConfiguration(
            name: "价格优先",
            description: "优先考虑价格因素，适合预算敏感的用户",
            scoringWeights: .priceSensitive,
            defaultSort: .priceLowToHigh
        )
        
        // 品质导向型配置
        let qualityFocused = AlgorithmConfiguration(
            name: "品质优先",
            description: "优先考虑酒店品质和评分，适合追求高品质体验的用户",
            scoringWeights: .qualityFocused,
            defaultSort: .rating
        )
        
        // 平衡型配置
        let balanced = AlgorithmConfiguration(
            name: "平衡推荐",
            description: "综合考虑各项因素，提供平衡的推荐结果",
            scoringWeights: .default,
            defaultSort: .relevance
        )
        
        configurations["price_sensitive"] = priceSensitive
        configurations["quality_focused"] = qualityFocused
        configurations["balanced"] = balanced
    }
}

/// 算法配置
public struct AlgorithmConfiguration {
    public let name: String
    public let description: String
    public let scoringWeights: ScoringWeights
    public let defaultSort: SortOption
    
    public init(
        name: String,
        description: String,
        scoringWeights: ScoringWeights,
        defaultSort: SortOption
    ) {
        self.name = name
        self.description = description
        self.scoringWeights = scoringWeights
        self.defaultSort = defaultSort
    }
}

// MARK: - 便捷扩展

extension HotelPackage {
    
    /// 使用指定算法计算自身评分
    public func calculateScore(
        with algorithm: ScoringAlgorithm,
        context: ScoringContext
    ) -> Double {
        return algorithm.calculateScore(for: self, with: context)
    }
}

extension Array where Element == HotelPackage {
    
    /// 使用指定算法对酒店数组进行评分
    public func calculateScores(
        with algorithm: ScoringAlgorithm,
        context: ScoringContext
    ) -> [HotelPackage: Double] {
        return algorithm.calculateScores(for: self, with: context)
    }
    
    /// 使用指定算法和排序方式进行排序
    public func sorted(
        with algorithm: SortingAlgorithm,
        context: SortingContext
    ) -> [HotelPackage] {
        return algorithm.sort(self, with: context)
    }
}