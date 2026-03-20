//
//  HotelCardView.swift
//  HotelBookingDemo
//
//  Created by Designer on 2024.
//

import UIKit

public class HotelCardView: CardView {
    
    // MARK: - UI Components
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = BorderRadius.large
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: CustomLabel = {
        let label = CustomLabel(style: .headlineMedium)
        label.numberOfLines = 2
        return label
    }()
    
    private let locationLabel: CustomLabel = {
        let label = CustomLabel(style: .bodySmall)
        label.textColor = Colors.textSecondary
        return label
    }()
    
    private let ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Spacing.xs
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let priceLabel: CustomLabel = {
        let label = CustomLabel(style: .priceLarge)
        return label
    }()
    
    private let badgeView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.primaryGold
        view.layer.cornerRadius = BorderRadius.small
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let badgeLabel: CustomLabel = {
        let label = CustomLabel(style: .labelSmall)
        label.textColor = Colors.textPrimary
        return label
    }()
    
    // MARK: - Properties
    public var hotelName: String? {
        didSet { titleLabel.text = hotelName }
    }
    
    public var location: String? {
        didSet { locationLabel.text = location }
    }
    
    public var price: String? {
        didSet { priceLabel.text = price }
    }
    
    public var rating: Double = 0.0 {
        didSet { updateRatingStars() }
    }
    
    public var reviewCount: Int = 0 {
        didSet { updateReviewCount() }
    }
    
    public var imageURL: String? {
        didSet { loadImage() }
    }
    
    public var badgeText: String? {
        didSet {
            badgeLabel.text = badgeText
            badgeView.isHidden = badgeText == nil
        }
    }
    
    // MARK: - Initialization
    override public init(style: CardStyle = .elevated, cornerRadius: CGFloat = BorderRadius.xlarge) {
        super.init(style: style, cornerRadius: cornerRadius)
        setupHotelCard()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupHotelCard()
    }
    
    // MARK: - Setup
    private func setupHotelCard() {
        // Setup badge
        badgeView.addSubview(badgeLabel)
        badgeLabel.pinToEdges(of: badgeView, insets: UIEdgeInsets(top: Spacing.xs, left: Spacing.s, bottom: Spacing.xs, right: Spacing.s))
        badgeView.isHidden = true
        
        // Create main content stack
        let textStack = AutoLayoutHelper.createVerticalStack(
            views: [titleLabel, locationLabel, ratingStackView],
            spacing: Spacing.xs
        )
        
        let priceStack = AutoLayoutHelper.createVerticalStack(
            views: [badgeView, UIView(), priceLabel],
            spacing: Spacing.s
        )
        
        let infoStack = AutoLayoutHelper.createHorizontalStack(
            views: [textStack, priceStack],
            spacing: Spacing.m,
            alignment: .top
        )
        
        // Add image view
        contentView.addSubview(imageView)
        contentView.addSubview(infoStack)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            // Image view
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 160),
            
            // Info stack
            infoStack.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Spacing.m),
            infoStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            infoStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            infoStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        // Initialize with sample data for demo
        setupSampleData()
    }
    
    private func setupSampleData() {
        hotelName = "Grand Plaza Hotel"
        location = "市中心商务区"
        price = "¥899起"
        rating = 4.8
        reviewCount = 1234
        badgeText = "推荐"
        
        // Add sample stars
        updateRatingStars()
    }
    
    // MARK: - Rating System
    private func updateRatingStars() {
        // Clear existing stars
        ratingStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Add star icons (using system icons for demo)
        for i in 0..<5 {
            let starImageView = UIImageView()
            starImageView.contentMode = .scaleAspectFit
            starImageView.tintColor = i < Int(rating) ? Colors.warning : Colors.border
            starImageView.image = UIImage(systemName: "star.fill")
            starImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
            starImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
            
            ratingStackView.addArrangedSubview(starImageView)
        }
        
        // Add review count
        let reviewLabel = CustomLabel(text: "(\(reviewCount)条评价)", style: .bodySmall)
        reviewLabel.textColor = Colors.textSecondary
        ratingStackView.addArrangedSubview(reviewLabel)
    }
    
    private func updateReviewCount() {
        // Update review count in rating stack
        if let reviewLabel = ratingStackView.arrangedSubviews.last as? UILabel {
            reviewLabel.text = "(\(reviewCount)条评价)"
        }
    }
    
    // MARK: - Image Loading
    private func loadImage() {
        guard let urlString = imageURL, let url = URL(string: urlString) else {
            // Set placeholder image
            imageView.image = UIImage(systemName: "house")
            imageView.tintColor = Colors.textSecondary
            return
        }
        
        // In a real app, you'd use an image loading library like SDWebImage
        // For demo purposes, we'll just show the placeholder
        imageView.image = UIImage(systemName: "photo")
        imageView.tintColor = Colors.textSecondary
    }
    
    // MARK: - Convenience Methods
    public func configure(with hotelData: HotelData) {
        self.hotelName = hotelData.name
        self.location = hotelData.location
        self.price = "¥\(Int(hotelData.price))/晚"
        self.rating = hotelData.rating
        self.reviewCount = hotelData.reviewCount
        self.imageURL = hotelData.imageURL
        self.badgeText = hotelData.badgeText
    }
}

// MARK: - Data Model
public struct HotelData {
    public let name: String
    public let location: String
    public let price: Double
    public let rating: Double
    public let reviewCount: Int
    public let imageURL: String?
    public let badgeText: String?
    
    public init(name: String, location: String, price: Double, rating: Double, reviewCount: Int, imageURL: String?, badgeText: String? = nil) {
        self.name = name
        self.location = location
        self.price = price
        self.rating = rating
        self.reviewCount = reviewCount
        self.imageURL = imageURL
        self.badgeText = badgeText
    }
}

// MARK: - Convenience Extensions
public extension HotelCardView {
    static func featuredHotelCard() -> HotelCardView {
        let card = HotelCardView()
        card.layer.borderWidth = BorderWidth.thin
        card.layer.borderColor = Colors.primary.cgColor
        return card
    }
    
    static func compactHotelCard() -> HotelCardView {
        let card = HotelCardView()
        card.imageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        return card
    }
}