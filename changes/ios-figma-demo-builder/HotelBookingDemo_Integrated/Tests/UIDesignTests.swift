//
//  UIDesignTests.swift
//  HotelBookingDemoTests
//
//  Created by Designer on 2024.
//

import XCTest
@testable import HotelBookingDemo

class DesignSystemTests: XCTestCase {
    
    // MARK: - Color Token Tests
    func testColorTokensExist() {
        XCTAssertNotNil(Colors.primary)
        XCTAssertNotNil(Colors.primaryGold)
        XCTAssertNotNil(Colors.accentRed)
        XCTAssertNotNil(Colors.background)
        XCTAssertNotNil(Colors.surface)
    }
    
    func testHexColorConversion() {
        let blueColor = UIColor(hex: "#1A73E8")
        XCTAssertEqual(blueColor.cgColor.components?[0], 26.0/255.0, accuracy: 0.01)
        XCTAssertEqual(blueColor.cgColor.components?[1], 115.0/255.0, accuracy: 0.01)
        XCTAssertEqual(blueColor.cgColor.components?[2], 232.0/255.0, accuracy: 0.01)
    }
    
    func testRGBColorConversion() {
        let whiteColor = UIColor(hex: "#FFFFFF")
        let blackColor = UIColor(hex: "#000000")
        
        XCTAssertEqual(whiteColor, UIColor.white)
        XCTAssertEqual(blackColor, UIColor.black)
    }
    
    // MARK: - Typography Tests
    func testTypographyTokensExist() {
        XCTAssertNotNil(Typography.displayLarge)
        XCTAssertNotNil(Typography.bodyMedium)
        XCTAssertNotNil(Typography.labelSmall)
        XCTAssertNotNil(Typography.priceLarge)
    }
    
    func testFontSizeValues() {
        XCTAssertEqual(Typography.displayLarge.pointSize, 32)
        XCTAssertEqual(Typography.bodyMedium.pointSize, 14)
        XCTAssertEqual(Typography.labelSmall.pointSize, 11)
    }
    
    // MARK: - Spacing Tests
    func testSpacingTokens() {
        XCTAssertEqual(Spacing.xs, 8)
        XCTAssertEqual(Spacing.m, 16)
        XCTAssertEqual(Spacing.xxl, 32)
    }
    
    // MARK: - Theme Tests
    func testThemeManagerSingleton() {
        let manager1 = ThemeManager.shared
        let manager2 = ThemeManager.shared
        XCTAssertTrue(manager1 === manager2)
    }
    
    func testThemeDefaults() {
        let themeManager = ThemeManager.shared
        XCTAssertEqual(themeManager.theme, .light)
    }
    
    func testThemeColorMapping() {
        let themeManager = ThemeManager.shared
        
        // Light theme colors
        XCTAssertEqual(themeManager.backgroundColor(for: .light), Colors.background)
        XCTAssertEqual(themeManager.surfaceColor(for: .light), Colors.surface)
        XCTAssertEqual(themeManager.textColor(for: .light, style: .primary), UIColor.label)
        
        // Dark theme colors
        XCTAssertNotEqual(themeManager.backgroundColor(for: .dark), Colors.background)
        XCTAssertNotEqual(themeManager.surfaceColor(for: .dark), Colors.surface)
    }
}

class ComponentTests: XCTestCase {
    
    // MARK: - Button Tests
    func testCustomButtonInitialization() {
        let button = CustomButton(style: .primary, size: .medium)
        
        XCTAssertNotNil(button)
        XCTAssertEqual(button.titleLabel?.font, Typography.bodyMedium)
        XCTAssertEqual(button.backgroundColor, Colors.primary)
    }
    
    func testButtonSizes() {
        let smallButton = CustomButton(size: .small)
        let mediumButton = CustomButton(size: .medium)
        let largeButton = CustomButton(size: .large)
        
        XCTAssertEqual(smallButton.frame.height, 32)
        XCTAssertEqual(mediumButton.frame.height, 44)
        XCTAssertEqual(largeButton.frame.height, 56)
    }
    
    func testButtonStyles() {
        let primaryButton = CustomButton(style: .primary)
        let secondaryButton = CustomButton(style: .secondary)
        let outlinedButton = CustomButton(style: .outlined)
        
        XCTAssertEqual(primaryButton.backgroundColor, Colors.primary)
        XCTAssertEqual(secondaryButton.backgroundColor, Colors.surfaceSecondary)
        XCTAssertEqual(outlinedButton.layer.borderWidth, BorderWidth.thin)
    }
    
    // MARK: - Label Tests
    func testCustomLabelInitialization() {
        let label = CustomLabel(style: .headlineLarge)
        
        XCTAssertNotNil(label)
        XCTAssertEqual(label.font, Typography.headlineLarge)
        XCTAssertEqual(label.numberOfLines, 0)
    }
    
    func testLabelStyles() {
        let priceLabel = CustomLabel(style: .priceLarge)
        let bodyLabel = CustomLabel(style: .bodyMedium)
        
        XCTAssertEqual(priceLabel.textColor, Colors.accentRed)
        XCTAssertEqual(bodyLabel.textColor, Colors.textPrimary)
    }
    
    // MARK: - Card Tests
    func testCardViewInitialization() {
        let card = CardView(style: .elevated)
        
        XCTAssertNotNil(card)
        XCTAssertEqual(card.backgroundColor, Colors.surface)
        XCTAssertNotNil(card.contentView)
    }
    
    func testCardStyles() {
        let elevatedCard = CardView(style: .elevated)
        let outlinedCard = CardView(style: .outlined)
        let filledCard = CardView(style: .filled)
        
        XCTAssertNotNil(elevatedCard.layer.shadowColor)
        XCTAssertEqual(outlinedCard.layer.borderWidth, BorderWidth.thin)
        XCTAssertEqual(filledCard.backgroundColor, Colors.surface)
    }
}

class FigmaStyleConverterTests: XCTestCase {
    
    // MARK: - Color Conversion Tests
    func testHexColorConversion() {
        let color = FigmaStyleConverter.convertColor(from: "#FF0000")
        XCTAssertNotNil(color)
        XCTAssertEqual(color?.cgColor.components?[0], 1.0, accuracy: 0.01)
        XCTAssertEqual(color?.cgColor.components?[1], 0.0, accuracy: 0.01)
        XCTAssertEqual(color?.cgColor.components?[2], 0.0, accuracy: 0.01)
    }
    
    func testRGBColorConversion() {
        let color = FigmaStyleConverter.convertColor(from: "rgb(255, 0, 0)")
        XCTAssertNotNil(color)
        XCTAssertEqual(color?.cgColor.components?[0], 1.0, accuracy: 0.01)
    }
    
    func testRGBAColorConversion() {
        let color = FigmaStyleConverter.convertColor(from: "rgba(255, 0, 0, 0.5)")
        XCTAssertNotNil(color)
        XCTAssertEqual(color?.cgColor.alpha, 0.5, accuracy: 0.01)
    }
    
    func testNamedColorConversion() {
        let blackColor = FigmaStyleConverter.convertColor(from: "black")
        let whiteColor = FigmaStyleConverter.convertColor(from: "white")
        
        XCTAssertEqual(blackColor, .black)
        XCTAssertEqual(whiteColor, .white)
    }
    
    // MARK: - Font Conversion Tests
    func testFontConversion() {
        let font = FigmaStyleConverter.convertFont(from: "16px bold")
        XCTAssertNotNil(font)
        XCTAssertEqual(font?.pointSize, 16)
    }
    
    func testFontWeightConversion() {
        let boldFont = FigmaStyleConverter.convertFont(from: "14px bold")
        let regularFont = FigmaStyleConverter.convertFont(from: "14px regular")
        
        XCTAssertNotNil(boldFont)
        XCTAssertNotNil(regularFont)
    }
    
    // MARK: - Spacing Conversion Tests
    func testPixelSpacingConversion() {
        let spacing = FigmaStyleConverter.convertSpacing(from: "16px")
        XCTAssertEqual(spacing, 16)
    }
    
    func testPointSpacingConversion() {
        let spacing = FigmaStyleConverter.convertSpacing(from: "12pt")
        XCTAssertEqual(spacing, 12)
    }
    
    func testRemSpacingConversion() {
        let spacing = FigmaStyleConverter.convertSpacing(from: "1rem")
        XCTAssertEqual(spacing, 16) // 1rem = 16px
    }
    
    // MARK: - Layout Conversion Tests
    func testTextAlignmentConversion() {
        XCTAssertEqual(FigmaStyleConverter.convertTextAlign(from: "center"), .center)
        XCTAssertEqual(FigmaStyleConverter.convertTextAlign(from: "left"), .left)
        XCTAssertEqual(FigmaStyleConverter.convertTextAlign(from: "right"), .right)
    }
    
    func testFlexDirectionConversion() {
        XCTAssertEqual(FigmaStyleConverter.convertFlexDirection(from: "row"), .horizontal)
        XCTAssertEqual(FigmaStyleConverter.convertFlexDirection(from: "column"), .vertical)
    }
}

class ComponentFactoryTests: XCTestCase {
    
    // MARK: - Component Creation Tests
    func testCreateSimpleView() {
        let config = ComponentConfiguration(type: .view)
        let view = ComponentFactory.shared.createComponent(from: config)
        
        XCTAssertNotNil(view)
        XCTAssertTrue(view is UIView)
    }
    
    func testCreateLabel() {
        let config = ComponentConfiguration(type: .label)
        let label = ComponentFactory.shared.createComponent(from: config)
        
        XCTAssertNotNil(label)
        XCTAssertTrue(label is UILabel)
    }
    
    func testCreateButton() {
        let config = ComponentConfiguration(type: .button)
        let button = ComponentFactory.shared.createComponent(from: config)
        
        XCTAssertNotNil(button)
        XCTAssertTrue(button is UIButton)
    }
    
    func testApplyStyles() {
        let styles: [String: Any] = [
            "backgroundColor": "#FF0000",
            "width": "100px",
            "height": "50px"
        ]
        
        let config = ComponentConfiguration(type: .view, style: styles)
        let view = ComponentFactory.shared.createComponent(from: config)
        
        XCTAssertNotNil(view)
        XCTAssertEqual(view.frame.width, 100)
        XCTAssertEqual(view.frame.height, 50)
    }
    
    // MARK: - Convenience Method Tests
    func testCreateHotelCard() {
        let card = ComponentFactory.shared.createHotelCard(
            title: "Test Hotel",
            price: "$100",
            imageName: nil
        )
        
        XCTAssertNotNil(card)
        XCTAssertTrue(card is CardView)
    }
    
    func testCreateSearchBar() {
        let searchBar = ComponentFactory.shared.createSearchBar(placeholder: "Search hotels...")
        
        XCTAssertNotNil(searchBar)
        XCTAssertTrue(searchBar.subviews.first is UIStackView)
    }
}

class AutoLayoutHelperTests: XCTestCase {
    
    // MARK: - Constraint Tests
    func testPinToEdges() {
        let containerView = UIView()
        let childView = UIView()
        
        containerView.addSubview(childView)
        let constraints = AutoLayoutHelper.pinToEdges(childView, in: containerView, activate: false)
        
        XCTAssertEqual(constraints.count, 4)
        XCTAssertTrue(constraints.allSatisfy { !$0.isActive })
    }
    
    func testSetSize() {
        let view = UIView()
        let constraints = AutoLayoutHelper.setSize(view, width: 100, height: 50, activate: false)
        
        XCTAssertEqual(constraints.count, 2)
        XCTAssertEqual(constraints[0].constant, 100) // width
        XCTAssertEqual(constraints[1].constant, 50)  // height
    }
    
    func testCenterConstraints() {
        let containerView = UIView()
        let childView = UIView()
        
        containerView.addSubview(childView)
        let constraints = AutoLayoutHelper.center(childView, in: containerView, activate: false)
        
        XCTAssertEqual(constraints.count, 2)
        XCTAssertTrue(constraints.allSatisfy { !$0.isActive })
    }
    
    // MARK: - Stack View Tests
    func testCreateVerticalStack() {
        let views = [UIView(), UIView(), UIView()]
        let stackView = AutoLayoutHelper.createVerticalStack(views: views, spacing: 10)
        
        XCTAssertEqual(stackView.axis, .vertical)
        XCTAssertEqual(stackView.spacing, 10)
        XCTAssertEqual(stackView.arrangedSubviews.count, 3)
    }
    
    func testCreateHorizontalStack() {
        let views = [UIView(), UIView()]
        let stackView = AutoLayoutHelper.createHorizontalStack(views: views, spacing: 15)
        
        XCTAssertEqual(stackView.axis, .horizontal)
        XCTAssertEqual(stackView.spacing, 15)
        XCTAssertEqual(stackView.arrangedSubviews.count, 2)
    }
    
    // MARK: - UIView Extension Tests
    func testUIViewExtensions() {
        let containerView = UIView()
        let childView = UIView()
        
        containerView.addSubview(childView)
        childView.pinToEdges(of: containerView)
        
        // Check that constraints were created
        let constraints = containerView.constraints.filter { constraint in
            constraint.firstItem === childView || constraint.secondItem === childView
        }
        
        XCTAssertGreaterThan(constraints.count, 0)
    }
}