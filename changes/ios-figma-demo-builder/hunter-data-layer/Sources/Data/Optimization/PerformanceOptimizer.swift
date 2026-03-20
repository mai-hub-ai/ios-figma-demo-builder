//
//  PerformanceOptimizer.swift
//  HotelBookingData
//
//  Created by Hunter on 2024.
//  Copyright © 2024 Hunter. All rights reserved.
//

import Foundation

/// 性能优化器协议
public protocol PerformanceOptimizer {
    
    /// 优化数据处理性能
    func optimizeDataProcessing<T>(_ data: [T]) -> [T]
    
    /// 批量处理数据
    func processBatchData<T>(_ data: [T], batchSize: Int, processor: (T) -> T?) -> [T]
    
    /// 缓存热点数据
    func cacheHotData<T: Hashable>(key: String, value: T, expiration: TimeInterval)
    
    /// 获取缓存数据
    func getCachedData<T>(key: String) -> T?
    
    /// 清理过期缓存
    func cleanupExpiredCache()
}

/// 默认性能优化器实现
public class DefaultPerformanceOptimizer: PerformanceOptimizer {
    
    private var cache: [String: CacheEntry] = [:]
    private let cacheQueue = DispatchQueue(label: "performance.cache.queue", qos: .utility)
    private let processingQueue = DispatchQueue(label: "performance.processing.queue", qos: .userInitiated)
    
    // MARK: - PerformanceOptimizer 协议实现
    
    public func optimizeDataProcessing<T>(_ data: [T]) -> [T] {
        // 并行处理大数据集
        if data.count > 1000 {
            return processInParallel(data)
        }
        
        // 对中小数据集使用优化的串行处理
        return processSequentially(data)
    }
    
    public func processBatchData<T>(_ data: [T], batchSize: Int, processor: (T) -> T?) -> [T] {
        guard !data.isEmpty else { return [] }
        
        let batches = stride(from: 0, to: data.count, by: batchSize).map {
            Array(data[$0..<min($0 + batchSize, data.count)])
        }
        
        var results: [T] = []
        let group = DispatchGroup()
        let resultQueue = DispatchQueue(label: "batch.results.queue")
        
        for batch in batches {
            processingQueue.async(group: group) {
                let processedBatch = batch.compactMap { processor($0) }
                resultQueue.async {
                    results.append(contentsOf: processedBatch)
                }
            }
        }
        
        group.wait()
        return results
    }
    
    public func cacheHotData<T: Hashable>(key: String, value: T, expiration: TimeInterval) {
        cacheQueue.async { [weak self] in
            guard let self = self else { return }
            
            let entry = CacheEntry(
                value: value,
                expirationDate: Date().addingTimeInterval(expiration)
            )
            self.cache[key] = entry
        }
    }
    
    public func getCachedData<T>(key: String) -> T? {
        var cachedValue: T?
        cacheQueue.sync {
            guard let entry = cache[key],
                  entry.expirationDate > Date() else {
                cachedValue = nil
                return
            }
            cachedValue = entry.value as? T
        }
        return cachedValue
    }
    
    public func cleanupExpiredCache() {
        cacheQueue.async { [weak self] in
            guard let self = self else { return }
            
            let now = Date()
            self.cache = self.cache.filter { $0.value.expirationDate > now }
        }
    }
    
    // MARK: - 私有方法
    
    private func processInParallel<T>(_ data: [T]) -> [T] {
        let processors = ProcessInfo.processInfo.processorCount
        let chunkSize = max(1, data.count / processors)
        
        let chunks = stride(from: 0, to: data.count, by: chunkSize).map {
            Array(data[$0..<min($0 + chunkSize, data.count)])
        }
        
        let group = DispatchGroup()
        var results: [[T]] = Array(repeating: [], count: chunks.count)
        let resultQueue = DispatchQueue(label: "parallel.results.queue")
        
        for (index, chunk) in chunks.enumerated() {
            processingQueue.async(group: group) {
                let processedChunk = self.processChunk(chunk)
                resultQueue.async {
                    results[index] = processedChunk
                }
            }
        }
        
        group.wait()
        return results.flatMap { $0 }
    }
    
    private func processSequentially<T>(_ data: [T]) -> [T] {
        // 对小数据集使用优化的处理方式
        return data.map { processDataItem($0) }
    }
    
    private func processChunk<T>(_ chunk: [T]) -> [T] {
        return chunk.map { processDataItem($0) }
    }
    
    private func processDataItem<T>(_ item: T) -> T {
        // 这里可以添加具体的数据处理逻辑
        // 例如：数据清洗、格式转换、验证等
        return item
    }
}

// MARK: - 缓存相关结构

private struct CacheEntry {
    let value: Any
    let expirationDate: Date
}

// MARK: - 数据预加载器

/// 数据预加载器
public class DataPreloader {
    
    private let repository: HotelRepository
    private let optimizer: PerformanceOptimizer
    private let preloadQueue = DispatchQueue(label: "preload.queue", qos: .background)
    
    public init(repository: HotelRepository, optimizer: PerformanceOptimizer) {
        self.repository = repository
        self.optimizer = optimizer
    }
    
    /// 预加载热门目的地数据
    public func preloadPopularDestinations() {
        preloadQueue.async { [weak self] in
            guard let self = self else { return }
            
            Task {
                do {
                    let popularHotels = try await self.repository.getAllHotels()
                    let groupedByCity = Dictionary(grouping: popularHotels) { hotel in
                        self.extractCity(from: hotel.location)
                    }
                    
                    // 缓存每个城市的热门酒店
                    for (city, hotels) in groupedByCity {
                        let sortedHotels = hotels.sorted { $0.rating > $1.rating }.prefix(10)
                        self.optimizer.cacheHotData(
                            key: "popular_\(city)",
                            value: Array(sortedHotels),
                            expiration: 3600 // 1小时过期
                        )
                    }
                } catch {
                    print("预加载失败: \(error)")
                }
            }
        }
    }
    
    /// 预加载用户偏好数据
    public func preloadUserPreferences(for userId: String) {
        preloadQueue.async { [weak self] in
            guard let self = self else { return }
            
            Task {
                do {
                    // 模拟获取用户历史数据
                    let userHistory = try await self.getUserSearchHistory(userId: userId)
                    self.optimizer.cacheHotData(
                        key: "user_history_\(userId)",
                        value: userHistory,
                        expiration: 1800 // 30分钟过期
                    )
                } catch {
                    print("预加载用户数据失败: \(error)")
                }
            }
        }
    }
    
    private func extractCity(from location: String) -> String {
        // 简单的城市提取逻辑
        if location.contains("北京市") { return "北京" }
        if location.contains("上海市") { return "上海" }
        if location.contains("广州市") { return "广州" }
        if location.contains("深圳市") { return "深圳" }
        return "其他"
    }
    
    private func getUserSearchHistory(userId: String) async throws -> [String] {
        // 模拟用户搜索历史
        return ["北京", "上海", "广州", "深圳", "杭州"]
    }
}

// MARK: - 内存监控

/// 内存监控器
public class MemoryMonitor {
    
    public static let shared = MemoryMonitor()
    
    private let memoryWarningThreshold: Double = 0.8 // 80%内存使用率阈值
    
    private init() {
        setupMemoryWarningObserver()
    }
    
    private func setupMemoryWarningObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleMemoryWarning),
            name: UIApplication.didReceiveMemoryWarningNotification,
            object: nil
        )
    }
    
    @objc private func handleMemoryWarning() {
        print("⚠️ 收到内存警告，执行清理操作")
        cleanupMemory()
    }
    
    /// 检查内存使用情况
    public func checkMemoryUsage() -> MemoryInfo {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size) / 4
        
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }
        
        if kerr == KERN_SUCCESS {
            let usedMB = Double(info.resident_size) / 1024.0 / 1024.0
            let freeMB = Double(info.virtual_size - info.resident_size) / 1024.0 / 1024.0
            
            return MemoryInfo(
                usedMemoryMB: usedMB,
                freeMemoryMB: freeMB,
                isCritical: usedMB > (usedMB + freeMB) * memoryWarningThreshold
            )
        }
        
        return MemoryInfo(usedMemoryMB: 0, freeMemoryMB: 0, isCritical: false)
    }
    
    /// 清理内存
    public func cleanupMemory() {
        // 清理缓存
        DefaultPerformanceOptimizer().cleanupExpiredCache()
        
        // 释放不必要的资源
        // 这里可以添加更多清理逻辑
    }
}

public struct MemoryInfo {
    public let usedMemoryMB: Double
    public let freeMemoryMB: Double
    public let isCritical: Bool
    
    public var totalMemoryMB: Double {
        return usedMemoryMB + freeMemoryMB
    }
    
    public var usagePercentage: Double {
        return totalMemoryMB > 0 ? (usedMemoryMB / totalMemoryMB) * 100 : 0
    }
}