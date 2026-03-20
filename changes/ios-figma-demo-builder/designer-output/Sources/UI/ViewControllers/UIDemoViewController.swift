//
//  UIDemoViewController.swift
//  HotelBookingDemo
//
//  Created by Designer on 2024.
//

import UIKit

class UIDemoViewController: BaseViewController {
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Spacing.l
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
        title = "UI Design System Demo"
        view.backgroundColor = ThemeManager.shared.backgroundColor(for: .light)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            // ScrollView constraints
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // StackView constraints
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: Spacing.m),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Spacing.m),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -Spacing.m),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -Spacing.m),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -2 * Spacing.m)
        ])
        
        setupDemoComponents()
    }
    
    // MARK: - Demo Setup
    private func setupDemoComponents() {
        // Title Section
        addSectionTitle("🎨 Design Tokens")
        addDesignTokenDemo()
        
        // Buttons Section
        addSectionTitle("🔘 Buttons")
        addButtonDemo()
        
        // Labels Section
        addSectionTitle("📝 Labels")
        addLabelDemo()
        
        // Cards Section
        addSectionTitle("🃏 Cards")
        addCardDemo()
        
        // Layout Demo Section
        addSectionTitle("📐 Layout System")
        addLayoutDemo()
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
    
    private func addDesignTokenDemo() {
        let tokenStack = AutoLayoutHelper.createVerticalStack(
            views: [
                createTokenRow("Primary Color", Colors.primary),
                createTokenRow("Accent Gold", Colors.primaryGold),
                createTokenRow("Success Green", Colors.success),
                createTokenRow("Warning Yellow", Colors.warning),
                createTokenRow("Error Red", Colors.error)
            ],
            spacing: Spacing.s
        )
        stackView.addArrangedSubview(tokenStack)
    }
    
    private func createTokenRow(_ name: String, _ color: UIColor) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let nameLabel = CustomLabel(text: name, style: .bodyMedium)
        
        let colorView = UIView()
        colorView.backgroundColor = color
        colorView.layer.cornerRadius = BorderRadius.small
        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        colorView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let rowStack = AutoLayoutHelper.createHorizontalStack(
            views: [nameLabel, UIView(), colorView],
            spacing: Spacing.m,
            alignment: .center
        )
        
        container.addSubview(rowStack)
        rowStack.pinToEdges(of: container, insets: UIEdgeInsets(top: Spacing.xs, left: 0, bottom: Spacing.xs, right: 0))
        
        return container
    }
    
    private func addButtonDemo() {
        let buttonStack = AutoLayoutHelper.createHorizontalStack(
            views: [
                CustomButton(style: .primary, size: .medium),
                CustomButton(style: .secondary, size: .medium),
                CustomButton(style: .outlined, size: .medium)
            ],
            spacing: Spacing.m
        )
        
        // Set button titles
        if let primaryBtn = buttonStack.arrangedSubviews[0] as? CustomButton {
            primaryBtn.setTitle("Primary", for: .normal)
        }
        if let secondaryBtn = buttonStack.arrangedSubviews[1] as? CustomButton {
            secondaryBtn.setTitle("Secondary", for: .normal)
        }
        if let outlinedBtn = buttonStack.arrangedSubviews[2] as? CustomButton {
            outlinedBtn.setTitle("Outlined", for: .normal)
        }
        
        stackView.addArrangedSubview(buttonStack)
    }
    
    private func addLabelDemo() {
        let labelStack = AutoLayoutHelper.createVerticalStack(
            views: [
                CustomLabel(text: "Display Large Text", style: .displayLarge),
                CustomLabel(text: "Headline Medium Text", style: .headlineMedium),
                CustomLabel(text: "Body Medium Text", style: .bodyMedium),
                CustomLabel(text: "Price: $199", style: .priceLarge)
            ],
            spacing: Spacing.s
        )
        stackView.addArrangedSubview(labelStack)
    }
    
    private func addCardDemo() {
        let card = ComponentFactory.shared.createHotelCard(
            title: "Grand Plaza Hotel",
            price: "$199/night",
            imageName: nil
        )
        
        // Add some demo content to the card
        let demoLabel = CustomLabel(text: "⭐ 4.8 (1,234 reviews)\n📍 Downtown Location\n🏊 Pool • 🍽 Restaurant", style: .bodySmall)
        demoLabel.numberOfLines = 0
        card.contentView.addSubview(demoLabel)
        demoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            demoLabel.topAnchor.constraint(equalTo: card.contentView.subviews.last?.bottomAnchor ?? card.contentView.topAnchor, constant: Spacing.s),
            demoLabel.leadingAnchor.constraint(equalTo: card.contentView.leadingAnchor),
            demoLabel.trailingAnchor.constraint(equalTo: card.contentView.trailingAnchor),
            demoLabel.bottomAnchor.constraint(equalTo: card.contentView.bottomAnchor)
        ])
        
        stackView.addArrangedSubview(card)
    }
    
    private func addLayoutDemo() {
        // Create a responsive layout demo
        let layoutContainer = UIView()
        layoutContainer.backgroundColor = Colors.surfaceSecondary
        layoutContainer.layer.cornerRadius = BorderRadius.medium
        layoutContainer.translatesAutoresizingMaskIntoConstraints = false
        layoutContainer.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        let leftView = UIView()
        leftView.backgroundColor = Colors.primary
        leftView.layer.cornerRadius = BorderRadius.small
        
        let rightView = UIView()
        rightView.backgroundColor = Colors.primaryGold
        rightView.layer.cornerRadius = BorderRadius.small
        
        layoutContainer.addSubview(leftView)
        layoutContainer.addSubview(rightView)
        
        AutoLayoutHelper.createSideBySideLayout(
            leftView: leftView,
            rightView: rightView,
            in: layoutContainer,
            spacing: Spacing.m,
            leftWidthRatio: 0.6
        )
        
        stackView.addArrangedSubview(layoutContainer)
    }
}