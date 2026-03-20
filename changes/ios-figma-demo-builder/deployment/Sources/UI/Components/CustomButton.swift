//
//  CustomButton.swift
//  HotelBookingDemo
//
//  Created by Designer on 2024.
//

import UIKit

public enum ButtonStyle {
    case primary
    case secondary
    case outlined
    case text
    case danger
    
    var backgroundColor: UIColor {
        switch self {
        case .primary:
            return Colors.primary
        case .secondary:
            return Colors.surfaceSecondary
        case .outlined:
            return .clear
        case .text:
            return .clear
        case .danger:
            return Colors.error
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .primary, .danger:
            return .white
        case .secondary, .outlined:
            return Colors.textPrimary
        case .text:
            return Colors.primary
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
}

public enum ButtonSize {
    case small
    case medium
    case large
    
    var height: CGFloat {
        switch self {
        case .small:
            return 32
        case .medium:
            return 44
        case .large:
            return 56
        }
    }
    
    var fontSize: UIFont {
        switch self {
        case .small:
            return Typography.labelMedium
        case .medium:
            return Typography.bodyMedium
        case .large:
            return Typography.bodyLarge
        }
    }
    
    var horizontalPadding: CGFloat {
        switch self {
        case .small:
            return Spacing.s
        case .medium:
            return Spacing.m
        case .large:
            return Spacing.l
        }
    }
}

public class CustomButton: UIButton {
    
    // MARK: - Properties
    private let style: ButtonStyle
    private let size: ButtonSize
    
    // MARK: - Initialization
    public init(style: ButtonStyle = .primary, size: ButtonSize = .medium) {
        self.style = style
        self.size = size
        super.init(frame: .zero)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        self.style = .primary
        self.size = .medium
        super.init(coder: coder)
        setupButton()
    }
    
    // MARK: - Setup
    private func setupButton() {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: size.height).isActive = true
        
        // Apply style
        backgroundColor = style.backgroundColor
        setTitleColor(style.titleColor, for: .normal)
        titleLabel?.font = size.fontSize
        
        // Border
        if let borderColor = style.borderColor {
            layer.borderColor = borderColor.cgColor
            layer.borderWidth = style.borderWidth
        }
        
        // Corner radius
        layer.cornerRadius = BorderRadius.medium
        layer.masksToBounds = true
        
        // Content insets
        contentEdgeInsets = UIEdgeInsets(
            top: 0,
            left: size.horizontalPadding,
            bottom: 0,
            right: size.horizontalPadding
        )
        
        // Shadow for primary buttons
        if style == .primary || style == .danger {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 2)
            layer.shadowOpacity = 0.1
            layer.shadowRadius = 4
        }
        
        // State configurations
        setupStateConfigurations()
    }
    
    private func setupStateConfigurations() {
        // Highlighted state
        setBackgroundImage(UIImage.imageWithColor(style.backgroundColor.withAlphaComponent(0.8)), for: .highlighted)
        
        // Disabled state
        setBackgroundImage(UIImage.imageWithColor(Colors.surfaceSecondary), for: .disabled)
        setTitleColor(Colors.textDisabled, for: .disabled)
    }
    
    // MARK: - Public Methods
    public func setLoading(_ isLoading: Bool) {
        isEnabled = !isLoading
        if isLoading {
            setTitle("", for: .normal)
            let indicator = UIActivityIndicatorView(style: .medium)
            indicator.startAnimating()
            addSubview(indicator)
            indicator.translatesAutoresizingMaskIntoConstraints = false
            indicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            indicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        } else {
            // Restore original title
        }
    }
}

// MARK: - UIImage Extension
extension UIImage {
    static func imageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
}