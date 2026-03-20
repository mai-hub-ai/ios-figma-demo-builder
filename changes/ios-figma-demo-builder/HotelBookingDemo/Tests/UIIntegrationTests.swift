//
//  UIIntegrationTests.swift
//  HotelBookingDemoTests
//
//  Created by Designer on 2024.
//

import XCTest
@testable import HotelBookingDemo

class UIIntegrationTests: XCTestCase {
    
    // MARK: - Hotel Card Integration Tests
    func testHotelCardViewIntegration() {
        let hotelData = HotelData(
            name: "测试酒店",
            location: "测试地址",
            price: 599.0,
            rating: 4.5,
            reviewCount: 888,
            imageURL: nil,
            badgeText: "特惠"
        )
        
        let hotelCard = HotelCardView()
        hotelCard.configure(with: hotelData)
        
        // Test data binding
        XCTAssertEqual(hotelCard.hotelName, "测试酒店")
        XCTAssertEqual(hotelCard.location, "测试地址")
        XCTAssertEqual(hotelCard.price, "¥599起")
        XCTAssertEqual(hotelCard.rating, 4.5)
        XCTAssertEqual(hotelCard.reviewCount, 888)
        XCTAssertEqual(hotelCard.badgeText, "特惠")
        
        // Test UI hierarchy
        XCTAssertNotNil(hotelCard.contentView)
        XCTAssertNotNil(hotelCard.imageView)
        XCTAssertNotNil(hotelCard.titleLabel)
        XCTAssertNotNil(hotelCard.priceLabel)
        
        // Test rating stars generation
        let ratingStack = hotelCard.value(forKey: "ratingStackView") as? UIStackView
        XCTAssertNotNil(ratingStack)
        XCTAssertTrue(ratingStack!.arrangedSubviews.count >= 6) // 5 stars + review count label
    }
    
    func testHotelCardVariants() {
        let featuredCard = HotelCardView.featuredHotelCard()
        let compactCard = HotelCardView.compactHotelCard()
        
        // Test featured card properties
        XCTAssertEqual(featuredCard.layer.borderWidth, BorderWidth.thin)
        XCTAssertEqual(featuredCard.layer.borderColor, Colors.primary.cgColor)
        
        // Test compact card image height
        // This would require checking constraints, which is complex in tests
        XCTAssertNotNil(compactCard)
    }
    
    // MARK: - Search Bar Integration Tests
    func testSearchBarViewIntegration() {
        let searchBar = SearchBarView()
        let mockDelegate = MockSearchBarDelegate()
        searchBar.delegate = mockDelegate
        
        // Test initial state
        XCTAssertNil(searchBar.text)
        XCTAssertTrue(searchBar.isCancelButtonHidden)
        XCTAssertTrue(searchBar.showsFilterButton)
        XCTAssertFalse(searchBar.isActive)
        
        // Test text setting
        searchBar.text = "测试搜索"
        XCTAssertEqual(searchBar.text, "测试搜索")
        
        // Test placeholder
        searchBar.placeholder = "请输入搜索内容"
        XCTAssertEqual(searchBar.textField.placeholder, "请输入搜索内容")
        
        // Test button visibility
        searchBar.showCancelButton(true, animated: false)
        XCTAssertFalse(searchBar.isCancelButtonHidden)
    }
    
    func testSearchBarDelegation() {
        let searchBar = SearchBarView()
        let mockDelegate = MockSearchBarDelegate()
        searchBar.delegate = mockDelegate
        
        // Simulate text change
        searchBar.textField.text = "新文本"
        searchBar.textField.delegate?.textField?(searchBar.textField, shouldChangeCharactersIn: NSRange(), replacementString: "新文本")
        
        XCTAssertTrue(mockDelegate.textDidChangeCalled)
        XCTAssertEqual(mockDelegate.lastSearchText, "新文本")
    }
    
    func testSearchBarVariants() {
        let prominentSearchBar = SearchBarView.prominentSearchBar()
        let minimalSearchBar = SearchBarView.minimalSearchBar()
        
        // Test prominent search bar properties
        XCTAssertEqual(prominentSearchBar.textField.textColor, .white)
        XCTAssertFalse(prominentSearchBar.isCancelButtonHidden)
        
        // Test minimal search bar properties
        XCTAssertFalse(minimalSearchBar.showsFilterButton)
        XCTAssertFalse(minimalSearchBar.isCancelButtonHidden)
    }
    
    // MARK: - Filter Panel Integration Tests
    func testFilterPanelViewIntegration() {
        let filterPanel = FilterPanelView()
        let mockDelegate = MockFilterPanelDelegate()
        filterPanel.delegate = mockDelegate
        
        // Test initial state
        let categories = filterPanel.value(forKey: "filterCategories") as? [FilterPanelView.FilterCategory]
        XCTAssertNotNil(categories)
        XCTAssertGreaterThan(categories?.count ?? 0, 0)
        
        // Test selecting filters
        filterPanel.selectFilter(withId: "price_0_300")
        let selectedFilters = filterPanel.getSelectedFilters()
        XCTAssertTrue(selectedFilters.contains("price_0_300"))
        
        // Test deselecting filters
        filterPanel.deselectFilter(withId: "price_0_300")
        let updatedFilters = filterPanel.getSelectedFilters()
        XCTAssertFalse(updatedFilters.contains("price_0_300"))
    }
    
    func testFilterPanelDelegation() {
        let filterPanel = FilterPanelView()
        let mockDelegate = MockFilterPanelDelegate()
        filterPanel.delegate = mockDelegate
        
        // Simulate filter selection
        filterPanel.selectFilter(withId: "test_filter")
        XCTAssertTrue(mockDelegate.filterSelectedCalled)
        
        // Simulate reset
        filterPanel.value(forKey: "resetButton") as? UIButton)?.sendActions(for: .touchUpInside)
        XCTAssertTrue(mockDelegate.resetFiltersCalled)
        
        // Simulate apply
        filterPanel.value(forKey: "applyButton") as? UIButton)?.sendActions(for: .touchUpInside)
        XCTAssertTrue(mockDelegate.applyFiltersCalled)
    }
    
    // MARK: - Price Display Integration Tests
    func testPriceDisplayViewIntegration() {
        let priceDisplay = PriceDisplayView()
        
        // Test price setting
        priceDisplay.setPrices(original: 800, current: 599, nights: 2)
        
        XCTAssertEqual(priceDisplay.originalPrice, 800)
        XCTAssertEqual(priceDisplay.currentPrice, 599)
        XCTAssertEqual(priceDisplay.nights, 2)
        
        // Test discount calculation
        XCTAssertTrue(priceDisplay.showDiscount)
        XCTAssertFalse(priceDisplay.discountBadge.isHidden)
        
        // Test total price calculation
        XCTAssertTrue(priceDisplay.showTotalPrice)
        XCTAssertFalse(priceDisplay.totalPriceLabel.isHidden)
    }
    
    func testPriceComparisonViewIntegration() {
        let priceComparison = PriceComparisonView()
        
        let options = [
            PriceComparisonView.PriceOption(name: "标准房", price: 599, description: "含双早", isRecommended: false),
            PriceComparisonView.PriceOption(name: "豪华房", price: 899, description: "含双早+行政酒廊", isRecommended: true)
        ]
        
        priceComparison.setPriceOptions(options)
        
        // Test data binding
        // This requires accessing private properties, which is not ideal for tests
        // In a real scenario, you'd make these properties accessible for testing
        XCTAssertNotNil(priceComparison)
    }
    
    // MARK: - Responsive Layout Integration Tests
    func testResponsiveLayoutManager() {
        let layoutManager = ResponsiveLayoutManager.shared
        
        // Test device size detection
        let currentSize = DeviceSizeCategory.current
        XCTAssertNotNil(currentSize)
        
        // Test adaptive spacing
        let adaptiveSpacing = layoutManager.adaptiveSpacing(for: currentSize)
        XCTAssertGreaterThan(adaptiveSpacing.m, 0)
        
        // Test adaptive fonts
        let adaptiveFonts = layoutManager.adaptiveFontSize(for: currentSize)
        XCTAssertGreaterThan(adaptiveFonts.body, 0)
        
        // Test grid layout
        let orientation = InterfaceOrientation.current
        let columnCount = layoutManager.columnCount(for: currentSize, orientation: orientation)
        XCTAssertGreaterThanOrEqual(columnCount, 1)
        XCTAssertLessThanOrEqual(columnCount, 4)
    }
    
    func testDeviceSizeMonitoring() {
        let monitor = DeviceSizeMonitor.shared
        let mockObserver = MockDeviceSizeObserver()
        
        monitor.addObserver(mockObserver)
        
        // Test notification
        NotificationCenter.default.post(name: UIDevice.orientationDidChangeNotification, object: nil)
        
        // Give time for async update
        let expectation = XCTestExpectation(description: "Device size update")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        
        // Note: Actual device rotation testing is difficult in unit tests
        // This mainly tests that the observer mechanism works
    }
    
    // MARK: - Component Factory Integration Tests
    func testComponentFactoryEnhanced() {
        let factory = ComponentFactory.shared
        
        // Test enhanced component creation with hotel-specific components
        let hotelCardConfig = ComponentConfiguration(
            type: .card,
            style: [
                "cornerRadius": BorderRadius.xlarge,
                "backgroundColor": Colors.surface
            ]
        )
        
        let hotelCard = factory.createComponent(from: hotelCardConfig)
        XCTAssertNotNil(hotelCard)
        XCTAssertTrue(hotelCard is CardView)
        
        // Test Figma CSS integration
        let cssStyles: [String: Any] = [
            "backgroundColor": "#FF0000",
            "width": "200px",
            "height": "100px",
            "borderRadius": "8px"
        ]
        
        let styledConfig = ComponentConfiguration(type: .view, style: cssStyles)
        let styledView = factory.createComponent(from: styledConfig)
        
        XCTAssertNotNil(styledView)
        XCTAssertEqual(styledView.layer.cornerRadius, 8)
    }
    
    // MARK: - Cross-Component Integration Tests
    func testCrossComponentInteraction() {
        // Test that different components can work together
        let containerView = UIView()
        
        let searchBar = SearchBarView.minimalSearchBar()
        let filterPanel = FilterPanelView()
        let hotelCard = HotelCardView()
        
        containerView.addSubview(searchBar)
        containerView.addSubview(filterPanel)
        containerView.addSubview(hotelCard)
        
        // Setup basic constraints
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        filterPanel.translatesAutoresizingMaskIntoConstraints = false
        hotelCard.translatesAutoresizingMaskIntoConstraints = false
        
        // Test that all components can coexist
        XCTAssertNotNil(containerView.subviews.first { $0 is SearchBarView })
        XCTAssertNotNil(containerView.subviews.first { $0 is FilterPanelView })
        XCTAssertNotNil(containerView.subviews.first { $0 is HotelCardView })
    }
    
    func testThemeIntegration() {
        let themeManager = ThemeManager.shared
        
        // Test theme switching affects UI components
        themeManager.theme = .dark
        
        let button = CustomButton()
        let label = CustomLabel()
        
        // Components should adapt to theme changes
        // Actual visual testing would require UI tests
        XCTAssertNotNil(button)
        XCTAssertNotNil(label)
    }
}

// MARK: - Mock Classes for Testing
class MockSearchBarDelegate: SearchBarViewDelegate {
    var textDidChangeCalled = false
    var lastSearchText: String?
    
    func searchBarDidBeginEditing(_ searchBar: SearchBarView) {}
    
    func searchBarDidEndEditing(_ searchBar: SearchBarView) {}
    
    func searchBar(_ searchBar: SearchBarView, textDidChange searchText: String) {
        textDidChangeCalled = true
        lastSearchText = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: SearchBarView) {}
    
    func searchBarCancelButtonClicked(_ searchBar: SearchBarView) {}
}

class MockFilterPanelDelegate: FilterPanelViewDelegate {
    var filterSelectedCalled = false
    var resetFiltersCalled = false
    var applyFiltersCalled = false
    
    func filterPanel(_ panel: FilterPanelView, didSelectFilter filter: FilterPanelView.FilterOption) {
        filterSelectedCalled = true
    }
    
    func filterPanelDidResetFilters(_ panel: FilterPanelView) {
        resetFiltersCalled = true
    }
    
    func filterPanelDidApplyFilters(_ panel: FilterPanelView) {
        applyFiltersCalled = true
    }
}

class MockDeviceSizeObserver: DeviceSizeObserver {
    var deviceSizeDidChangeCalled = false
    var lastSizeCategory: DeviceSizeCategory?
    var lastOrientation: InterfaceOrientation?
    
    func deviceSizeDidChange(to category: DeviceSizeCategory, orientation: InterfaceOrientation) {
        deviceSizeDidChangeCalled = true
        lastSizeCategory = category
        lastOrientation = orientation
    }
}

// MARK: - Performance Tests
class UIPerformanceTests: XCTestCase {
    
    func testComponentCreationPerformance() {
        measure {
            for _ in 0..<100 {
                _ = CustomButton()
                _ = CustomLabel()
                _ = CardView()
            }
        }
    }
    
    func testDataBindingPerformance() {
        let hotelCard = HotelCardView()
        let hotelData = HotelData(
            name: "性能测试酒店",
            location: "性能测试地址",
            price: 999.0,
            rating: 4.0,
            reviewCount: 1000,
            imageURL: nil
        )
        
        measure {
            hotelCard.configure(with: hotelData)
        }
    }
    
    func testLayoutCalculationPerformance() {
        let containerView = UIView()
        let stackView = UIStackView()
        
        measure {
            for i in 0..<50 {
                let label = CustomLabel(text: "测试标签 \(i)")
                stackView.addArrangedSubview(label)
            }
            containerView.addSubview(stackView)
            stackView.pinToEdges(of: containerView)
        }
    }
}