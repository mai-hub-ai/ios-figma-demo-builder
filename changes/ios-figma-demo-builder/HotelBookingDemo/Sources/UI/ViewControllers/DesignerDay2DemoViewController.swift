//
//  DesignerDay2DemoViewController.swift
//  HotelBookingDemo
//
//  Created by Designer on 2024.
//

import UIKit

class DesignerDay2DemoViewController: BaseViewController {
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Spacing.xl
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDemoUI()
    }
    
    override func setupUI() {
        super.setupUI()
        title = "Designer Day 2 Demo"
        view.backgroundColor = ThemeManager.shared.backgroundColor(for: .light)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: Spacing.m),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Spacing.m),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -Spacing.m),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -Spacing.m),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -2 * Spacing.m)
        ])
        
        setupDemoSections()
    }
    
    // MARK: - Demo Sections
    private func setupDemoSections() {
        // Section 1: Enhanced Figma Style Converter
        addSectionTitle("🎨 Enhanced Figma Style Converter")
        addFigmaConverterDemo()
        
        // Section 2: Hotel Components
        addSectionTitle("🏨 Hotel Specialized Components")
        addHotelComponentsDemo()
        
        // Section 3: Responsive Layout System
        addSectionTitle("📱 Responsive Layout System")
        addResponsiveLayoutDemo()
        
        // Section 4: Component Integration
        addSectionTitle("🔗 Component Integration")
        addIntegrationDemo()
    }
    
    private func addSectionTitle(_ title: String) {
        let titleLabel = CustomLabel(text: title, style: .headlineLarge)
        stackView.addArrangedSubview(titleLabel)
        
        // Add divider
        let divider = UIView()
        divider.backgroundColor = Colors.border
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        stackView.addArrangedSubview(divider)
    }
    
    // MARK: - Figma Converter Demo
    private func addFigmaConverterDemo() {
        let converterDemoView = UIView()
        converterDemoView.backgroundColor = Colors.surfaceSecondary
        converterDemoView.layer.cornerRadius = BorderRadius.medium
        converterDemoView.translatesAutoresizingMaskIntoConstraints = false
        converterDemoView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        let titleLabel = CustomLabel(text: "Figma CSS转换示例", style: .titleMedium)
        
        // Demo CSS to UIKit conversion
        let cssExamples = [
            ("背景色转换", "#FF5733 → UIColor"),
            ("字体转换", "16px bold → UIFont"),
            ("布局转换", "margin: 16px → NSLayoutConstraint"),
            ("组件映射", ".button-primary → CustomButton")
        ]
        
        let examplesStack = AutoLayoutHelper.createVerticalStack(
            views: cssExamples.map { example in
                createKeyValueRow(key: example.0, value: example.1)
            },
            spacing: Spacing.s
        )
        
        let demoStack = AutoLayoutHelper.createVerticalStack(
            views: [titleLabel, examplesStack],
            spacing: Spacing.m
        )
        
        converterDemoView.addSubview(demoStack)
        demoStack.pinToEdges(of: converterDemoView, insets: UIEdgeInsets(top: Spacing.m, left: Spacing.m, bottom: Spacing.m, right: Spacing.m))
        
        stackView.addArrangedSubview(converterDemoView)
    }
    
    // MARK: - Hotel Components Demo
    private func addHotelComponentsDemo() {
        // Hotel Card Demo
        let hotelCard = createDemoHotelCard()
        
        // Search Bar Demo
        let searchBar = SearchBarView.minimalSearchBar()
        searchBar.text = "北京王府井"
        searchBar.placeholder = "搜索目的地"
        
        // Filter Panel Preview
        let filterPreview = createFilterPanelPreview()
        
        // Price Display Demo
        let priceDisplay = PriceDisplayView.detailedPriceDisplay()
        priceDisplay.setPrices(original: 1200, current: 899, nights: 3)
        
        let hotelComponentsStack = AutoLayoutHelper.createVerticalStack(
            views: [hotelCard, searchBar, filterPreview, priceDisplay],
            spacing: Spacing.l
        )
        
        stackView.addArrangedSubview(hotelComponentsStack)
    }
    
    private func createDemoHotelCard() -> HotelCardView {
        let hotelData = HotelData(
            name: "北京国际饭店",
            location: "北京市东城区建国门内大街9号",
            price: 899.0,
            rating: 4.6,
            reviewCount: 2156,
            imageURL: nil,
            badgeText: "限时特价"
        )
        
        let card = HotelCardView.featuredHotelCard()
        card.configure(with: hotelData)
        return card
    }
    
    private func createFilterPanelPreview() -> UIView {
        let container = UIView()
        container.backgroundColor = Colors.surface
        container.layer.cornerRadius = BorderRadius.medium
        container.layer.borderWidth = BorderWidth.thin
        container.layer.borderColor = Colors.border.cgColor
        container.translatesAutoresizingMaskIntoConstraints = false
        container.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        let titleLabel = CustomLabel(text: "筛选面板预览", style: .titleMedium)
        let filtersLabel = CustomLabel(text: "• 价格范围: ¥500-800\n• 星级: 四星及以上\n• 设施: 免费WiFi, 停车场", style: .bodySmall)
        filtersLabel.numberOfLines = 0
        
        let previewStack = AutoLayoutHelper.createVerticalStack(
            views: [titleLabel, filtersLabel],
            spacing: Spacing.s
        )
        
        container.addSubview(previewStack)
        previewStack.pinToEdges(of: container, insets: UIEdgeInsets(top: Spacing.m, left: Spacing.m, bottom: Spacing.m, right: Spacing.m))
        
        return container
    }
    
    // MARK: - Responsive Layout Demo
    private func addResponsiveLayoutDemo() {
        let responsiveDemoView = UIView()
        responsiveDemoView.backgroundColor = Colors.surfaceSecondary
        responsiveDemoView.layer.cornerRadius = BorderRadius.medium
        responsiveDemoView.translatesAutoresizingMaskIntoConstraints = false
        responsiveDemoView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        
        let currentDeviceLabel = CustomLabel(
            text: "当前设备: \(DeviceSizeCategory.current.name)",
            style: .headlineMedium
        )
        
        let orientationLabel = CustomLabel(
            text: "当前方向: \(InterfaceOrientation.current.isPortrait ? "竖屏" : "横屏")",
            style: .bodyMedium
        )
        
        // Grid layout demo
        let gridDemo = createGridDemo()
        
        let responsiveStack = AutoLayoutHelper.createVerticalStack(
            views: [currentDeviceLabel, orientationLabel, gridDemo],
            spacing: Spacing.m
        )
        
        responsiveDemoView.addSubview(responsiveStack)
        responsiveStack.pinToEdges(of: responsiveDemoView, insets: UIEdgeInsets(top: Spacing.m, left: Spacing.m, bottom: Spacing.m, right: Spacing.m))
        
        stackView.addArrangedSubview(responsiveDemoView)
    }
    
    private func createGridDemo() -> UIView {
        let gridContainer = UIView()
        gridContainer.translatesAutoresizingMaskIntoConstraints = false
        gridContainer.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let layoutManager = ResponsiveLayoutManager.shared
        let currentCategory = DeviceSizeCategory.current
        let currentOrientation = InterfaceOrientation.current
        let columnCount = layoutManager.columnCount(for: currentCategory, orientation: currentOrientation)
        
        let gridStack = UIStackView()
        gridStack.axis = .horizontal
        gridStack.distribution = .fillEqually
        gridStack.spacing = Spacing.s
        gridStack.translatesAutoresizingMaskIntoConstraints = false
        
        // Create colored boxes to represent grid columns
        for i in 0..<columnCount {
            let box = UIView()
            box.backgroundColor = Colors.primary.withAlphaComponent(0.3)
            box.layer.cornerRadius = BorderRadius.small
            box.translatesAutoresizingMaskIntoConstraints = false
            
            let label = CustomLabel(text: "列\(i+1)", style: .labelSmall)
            label.textColor = Colors.primary
            
            box.addSubview(label)
            label.center(in: box)
            
            gridStack.addArrangedSubview(box)
        }
        
        gridContainer.addSubview(gridStack)
        gridStack.pinToEdges(of: gridContainer)
        
        return gridContainer
    }
    
    // MARK: - Integration Demo
    private func addIntegrationDemo() {
        let integrationDemoView = UIView()
        integrationDemoView.backgroundColor = Colors.surface
        integrationDemoView.layer.cornerRadius = BorderRadius.medium
        integrationDemoView.layer.borderWidth = BorderWidth.thin
        integrationDemoView.layer.borderColor = Colors.primary.cgColor
        integrationDemoView.translatesAutoresizingMaskIntoConstraints = false
        integrationDemoView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        // Create integrated hotel search interface
        let searchSection = createIntegratedSearchSection()
        let resultsSection = createIntegratedResultsSection()
        
        let integrationStack = AutoLayoutHelper.createVerticalStack(
            views: [searchSection, resultsSection],
            spacing: Spacing.m
        )
        
        integrationDemoView.addSubview(integrationStack)
        integrationStack.pinToEdges(of: integrationDemoView, insets: UIEdgeInsets(top: Spacing.m, left: Spacing.m, bottom: Spacing.m, right: Spacing.m))
        
        stackView.addArrangedSubview(integrationDemoView)
    }
    
    private func createIntegratedSearchSection() -> UIView {
        let container = UIView()
        
        let searchBar = SearchBarView.minimalSearchBar()
        searchBar.placeholder = "搜索酒店..."
        
        let filterButton = CustomButton(style: .outlined, size: .small)
        filterButton.setTitle("筛选条件", for: .normal)
        filterButton.setImage(UIImage(systemName: "line.horizontal.3.decrease"), for: .normal)
        
        let searchStack = AutoLayoutHelper.createHorizontalStack(
            views: [searchBar, filterButton],
            spacing: Spacing.s
        )
        
        container.addSubview(searchStack)
        searchStack.pinToEdges(of: container)
        
        return container
    }
    
    private func createIntegratedResultsSection() -> UIView {
        let container = UIView()
        
        // Create a small grid of hotel cards
        let resultsStack = UIStackView()
        resultsStack.axis = .horizontal
        resultsStack.distribution = .fillEqually
        resultsStack.spacing = Spacing.s
        resultsStack.translatesAutoresizingMaskIntoConstraints = false
        
        // Add 2 demo hotel cards
        for i in 0..<2 {
            let hotelData = HotelData(
                name: "示范酒店\(i+1)",
                location: "示范地区\(i+1)",
                price: Double(600 + i * 100),
                rating: 4.0 + Double(i) * 0.3,
                reviewCount: 1000 + i * 500,
                imageURL: nil,
                badgeText: i == 0 ? "推荐" : nil
            )
            
            let card = HotelCardView.compactHotelCard()
            card.configure(with: hotelData)
            card.imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
            
            resultsStack.addArrangedSubview(card)
        }
        
        container.addSubview(resultsStack)
        resultsStack.pinToEdges(of: container)
        
        return container
    }
    
    // MARK: - Helper Methods
    private func createKeyValueRow(key: String, value: String) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        let keyLabel = CustomLabel(text: key, style: .bodySmall)
        keyLabel.textColor = Colors.textSecondary
        
        let valueLabel = CustomLabel(text: value, style: .bodySmall)
        valueLabel.textColor = Colors.primary
        
        let rowStack = AutoLayoutHelper.createHorizontalStack(
            views: [keyLabel, UIView(), valueLabel],
            spacing: Spacing.s
        )
        
        container.addSubview(rowStack)
        rowStack.pinToEdges(of: container)
        
        return container
    }
}