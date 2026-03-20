//
//  CardView.swift
//  HotelBookingDemo
//
//  Created by Designer on 2024.
//

import UIKit

public enum CardStyle {
    case elevated
    case outlined
    case filled
    
    var backgroundColor: UIColor {
        switch self {
        case .elevated, .filled:
            return Colors.surface
        case .outlined:
            return .clear
        }
    }
    
    var borderColor: UIColor? {
        switch self {
        case .outlined:
            return Colors.border
        default:
            return nil
        }
    }
    
    var borderWidth: CGFloat {
        switch self {
        case .outlined:
            return BorderWidth.thin
        default:
            return 0
        }
    }
    
    var shadow: NSShadow? {
        switch self {
        case .elevated:
            return Shadows.medium
        default:
            return nil
        }
    }
}

public class CardView: UIView {
    
    // MARK: - Properties
    private let style: CardStyle
    private let cornerRadius: CGFloat
    
    // MARK: - UI Elements
    public let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initialization
    public init(style: CardStyle = .elevated, cornerRadius: CGFloat = BorderRadius.large) {
        self.style = style
        self.cornerRadius = cornerRadius
        super.init(frame: .zero)
        setupCard()
    }
    
    required init?(coder: NSCoder) {
        self.style = .elevated
        self.cornerRadius = BorderRadius.large
        super.init(coder: coder)
        setupCard()
    }
    
    // MARK: - Setup
    private func setupCard() {
        translatesAutoresizingMaskIntoConstraints = false
        
        // Apply style
        backgroundColor = style.backgroundColor
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        
        // Border
        if let borderColor = style.borderColor {
            layer.borderColor = borderColor.cgColor
            layer.borderWidth = style.borderWidth
        }
        
        // Shadow
        if let shadow = style.shadow {
            layer.shadowColor = (shadow.shadowColor as? UIColor)?.cgColor
            layer.shadowOffset = shadow.shadowOffset
            layer.shadowOpacity = Float((shadow.shadowColor as? UIColor)?.cgColor.alpha ?? 0)
            layer.shadowRadius = shadow.shadowBlurRadius
        }
        
        // Add content view
        addSubview(contentView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.m),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.m),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.m),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Spacing.m)
        ])
    }
    
    // MARK: - Public Methods
    public func addArrangedSubview(_ view: UIView) {
        contentView.addSubview(view)
    }
    
    public func setContentInsets(_ insets: UIEdgeInsets) {
        contentView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: insets.top,
            leading: insets.left,
            bottom: insets.bottom,
            trailing: insets.right
        )
    }
}

// MARK: - Convenience Extensions
public extension CardView {
    static func hotelCard() -> CardView {
        let card = CardView(style: .elevated, cornerRadius: BorderRadius.xlarge)
        card.layer.shadowOpacity = 0.1
        card.layer.shadowRadius = 8
        card.layer.shadowOffset = CGSize(width: 0, height: 4)
        return card
    }
    
    static func infoCard() -> CardView {
        let card = CardView(style: .outlined, cornerRadius: BorderRadius.medium)
        return card
    }
    
    static func featureCard() -> CardView {
        let card = CardView(style: .filled, cornerRadius: BorderRadius.large)
        return card
    }
}