//
//  PriceDisplayView.swift
//  HotelBookingDemo
//
//  Created by Designer on 2024.
//

import UIKit

public class PriceDisplayView: UIView {
    
    // MARK: - UI Components
    private let originalPriceLabel: CustomLabel = {
        let label = CustomLabel(style: .bodySmall)
        label.textColor = Colors.textSecondary
        label.attributedText = NSAttributedString(string: "", attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
        return label
    }()
    
    private let currentPriceLabel: CustomLabel = {
        let label = CustomLabel(style: .priceLarge)
        return label
    }()
    
    private let discountBadge: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.accentRed
        view.layer.cornerRadius = BorderRadius.small
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let discountLabel: CustomLabel = {
        let label = CustomLabel(style: .labelSmall)
        label.textColor = .white
        return label
    }()
    
    private let perNightLabel: CustomLabel = {
        let label = CustomLabel(text: "每晚", style: .bodySmall)
        label.textColor = Colors.textSecondary
        return label
    }()
    
    private let totalPriceLabel: CustomLabel = {
        let label = CustomLabel(style: .bodyMedium)
        label.textColor = Colors.textSecondary
        return label
    }()
    
    // MARK: - Properties
    public var originalPrice: Double? {
        didSet { updatePriceDisplay() }
    }
    
    public var currentPrice: Double = 0 {
        didSet { updatePriceDisplay() }
    }
    
    public var nights: Int = 1 {
        didSet { updatePriceDisplay() }
    }
    
    public var currencySymbol: String = "¥" {
        didSet { updatePriceDisplay() }
    }
    
    public var showDiscount: Bool = true {
        didSet { discountBadge.isHidden = !showDiscount }
    }
    
    public var showTotalPrice: Bool = true {
        didSet { totalPriceLabel.isHidden = !showTotalPrice }
    }
    
    // MARK: - Initialization
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupPriceDisplay()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupPriceDisplay()
    }
    
    // MARK: - Setup
    private func setupPriceDisplay() {
        translatesAutoresizingMaskIntoConstraints = false
        
        // Setup discount badge
        discountBadge.addSubview(discountLabel)
        discountLabel.pinToEdges(of: discountBadge, insets: UIEdgeInsets(top: Spacing.xs, left: Spacing.s, bottom: Spacing.xs, right: Spacing.s))
        discountBadge.isHidden = true
        
        // Create price stack
        let priceStack = AutoLayoutHelper.createVerticalStack(
            views: [currentPriceLabel, perNightLabel],
            spacing: Spacing.xxs
        )
        
        // Create main stack
        let mainStack = AutoLayoutHelper.createHorizontalStack(
            views: [originalPriceLabel, priceStack, discountBadge],
            spacing: Spacing.s,
            alignment: .bottom
        )
        
        // Add subviews
        addSubview(mainStack)
        addSubview(totalPriceLabel)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            totalPriceLabel.topAnchor.constraint(equalTo: mainStack.bottomAnchor, constant: Spacing.xs),
            totalPriceLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            totalPriceLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            totalPriceLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // Initial update
        updatePriceDisplay()
    }
    
    // MARK: - Price Calculation and Display
    private func updatePriceDisplay() {
        // Update current price
        currentPriceLabel.text = "\(currencySymbol)\(Int(currentPrice))"
        
        // Update original price and discount
        if let original = originalPrice, original > currentPrice {
            originalPriceLabel.text = "\(currencySymbol)\(Int(original))"
            originalPriceLabel.isHidden = false
            
            if showDiscount {
                let discountPercent = Int(((original - currentPrice) / original) * 100)
                discountLabel.text = "-\(discountPercent)%"
                discountBadge.isHidden = false
            }
        } else {
            originalPriceLabel.isHidden = true
            discountBadge.isHidden = true
        }
        
        // Update total price
        let totalPrice = currentPrice * Double(nights)
        totalPriceLabel.text = "\(nights)晚总计 \(currencySymbol)\(Int(totalPrice))"
        totalPriceLabel.isHidden = !showTotalPrice || nights <= 1
    }
    
    // MARK: - Animation
    public func animatePriceChange() {
        UIView.transition(
            with: self,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: {
                self.updatePriceDisplay()
            },
            completion: nil
        )
    }
    
    // MARK: - Convenience Methods
    public func setPrices(original: Double?, current: Double, nights: Int = 1) {
        self.originalPrice = original
        self.currentPrice = current
        self.nights = nights
    }
    
    public func highlightBestPrice() {
        currentPriceLabel.textColor = Colors.accentRed
        layer.borderWidth = BorderWidth.thin
        layer.borderColor = Colors.accentRed.cgColor
        layer.cornerRadius = BorderRadius.small
    }
}

// MARK: - Price Comparison View
public class PriceComparisonView: UIView {
    
    // MARK: - UI Components
    private let titleLabel: CustomLabel = {
        let label = CustomLabel(text: "价格对比", style: .titleMedium)
        return label
    }()
    
    private let pricesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Spacing.s
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Data Model
    public struct PriceOption {
        public let name: String
        public let price: Double
        public let description: String?
        public let isRecommended: Bool
        
        public init(name: String, price: Double, description: String? = nil, isRecommended: Bool = false) {
            self.name = name
            self.price = price
            self.description = description
            self.isRecommended = isRecommended
        }
    }
    
    // MARK: - Properties
    private var priceOptions: [PriceOption] = []
    
    // MARK: - Initialization
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupPriceComparison()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupPriceComparison()
    }
    
    // MARK: - Setup
    private func setupPriceComparison() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = Colors.surface
        layer.cornerRadius = BorderRadius.medium
        layer.borderWidth = BorderWidth.thin
        layer.borderColor = Colors.border.cgColor
        
        addSubview(titleLabel)
        addSubview(pricesStackView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.m),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.m),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.m),
            
            pricesStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Spacing.m),
            pricesStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.m),
            pricesStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.m),
            pricesStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Spacing.m)
        ])
    }
    
    // MARK: - Public Methods
    public func setPriceOptions(_ options: [PriceOption]) {
        self.priceOptions = options
        updatePriceOptions()
    }
    
    private func updatePriceOptions() {
        // Clear existing views
        pricesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for option in priceOptions {
            let optionView = createPriceOptionView(for: option)
            pricesStackView.addArrangedSubview(optionView)
        }
    }
    
    private func createPriceOptionView(for option: PriceOption) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let nameLabel = CustomLabel(text: option.name, style: .bodyMedium)
        
        let priceLabel = CustomLabel(text: "¥\(Int(option.price))", style: .priceMedium)
        priceLabel.textColor = option.isRecommended ? Colors.accentRed : Colors.textPrimary
        
        let descriptionLabel = CustomLabel(text: option.description ?? "", style: .bodySmall)
        descriptionLabel.textColor = Colors.textSecondary
        descriptionLabel.isHidden = option.description == nil
        
        let stackView = AutoLayoutHelper.createVerticalStack(
            views: [nameLabel, priceLabel, descriptionLabel],
            spacing: Spacing.xs
        )
        
        container.addSubview(stackView)
        stackView.pinToEdges(of: container)
        
        // Add recommendation badge if needed
        if option.isRecommended {
            let badge = createRecommendationBadge()
            container.addSubview(badge)
            badge.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                badge.topAnchor.constraint(equalTo: container.topAnchor),
                badge.trailingAnchor.constraint(equalTo: container.trailingAnchor)
            ])
        }
        
        return container
    }
    
    private func createRecommendationBadge() -> UIView {
        let badge = UIView()
        badge.backgroundColor = Colors.accentRed
        badge.layer.cornerRadius = BorderRadius.small
        
        let label = CustomLabel(text: "推荐", style: .labelSmall)
        label.textColor = .white
        
        badge.addSubview(label)
        label.pinToEdges(of: badge, insets: UIEdgeInsets(top: Spacing.xxs, left: Spacing.s, bottom: Spacing.xxs, right: Spacing.s))
        
        return badge
    }
}

// MARK: - Convenience Extensions
public extension PriceDisplayView {
    static func compactPriceDisplay() -> PriceDisplayView {
        let view = PriceDisplayView()
        view.perNightLabel.isHidden = true
        view.totalPriceLabel.isHidden = true
        return view
    }
    
    static func detailedPriceDisplay() -> PriceDisplayView {
        let view = PriceDisplayView()
        view.showTotalPrice = true
        view.showDiscount = true
        return view
    }
}