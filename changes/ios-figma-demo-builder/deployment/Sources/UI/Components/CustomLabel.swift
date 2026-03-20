//
//  CustomLabel.swift
//  HotelBookingDemo
//
//  Created by Designer on 2024.
//

import UIKit

public enum LabelStyle {
    case displayLarge
    case displayMedium
    case displaySmall
    case headlineLarge
    case headlineMedium
    case headlineSmall
    case titleLarge
    case titleMedium
    case titleSmall
    case bodyLarge
    case bodyMedium
    case bodySmall
    case labelLarge
    case labelMedium
    case labelSmall
    case priceLarge
    case priceMedium
    case priceSmall
    
    var font: UIFont {
        switch self {
        case .displayLarge: return Typography.displayLarge
        case .displayMedium: return Typography.displayMedium
        case .displaySmall: return Typography.displaySmall
        case .headlineLarge: return Typography.headlineLarge
        case .headlineMedium: return Typography.headlineMedium
        case .headlineSmall: return Typography.headlineSmall
        case .titleLarge: return Typography.titleLarge
        case .titleMedium: return Typography.titleMedium
        case .titleSmall: return Typography.titleSmall
        case .bodyLarge: return Typography.bodyLarge
        case .bodyMedium: return Typography.bodyMedium
        case .bodySmall: return Typography.bodySmall
        case .labelLarge: return Typography.labelLarge
        case .labelMedium: return Typography.labelMedium
        case .labelSmall: return Typography.labelSmall
        case .priceLarge: return Typography.priceLarge
        case .priceMedium: return Typography.priceMedium
        case .priceSmall: return Typography.priceSmall
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .priceLarge, .priceMedium, .priceSmall:
            return Colors.accentRed
        default:
            return Colors.textPrimary
        }
    }
    
    var numberOfLines: Int {
        switch self {
        case .displayLarge, .displayMedium, .displaySmall:
            return 1
        default:
            return 0
        }
    }
}

public class CustomLabel: UILabel {
    
    // MARK: - Properties
    private let style: LabelStyle
    
    // MARK: - Initialization
    public init(style: LabelStyle = .bodyMedium) {
        self.style = style
        super.init(frame: .zero)
        setupLabel()
    }
    
    public init(text: String, style: LabelStyle = .bodyMedium) {
        self.style = style
        super.init(frame: .zero)
        self.text = text
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        self.style = .bodyMedium
        super.init(coder: coder)
        setupLabel()
    }
    
    // MARK: - Setup
    private func setupLabel() {
        translatesAutoresizingMaskIntoConstraints = false
        font = style.font
        textColor = style.textColor
        numberOfLines = style.numberOfLines
        textAlignment = .natural
        
        // Line spacing for multi-line labels
        if style.numberOfLines != 1 {
            setupLineSpacing()
        }
    }
    
    private func setupLineSpacing() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        paragraphStyle.alignment = textAlignment
        
        let attributedText = NSMutableAttributedString(string: self.text ?? "")
        attributedText.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedText.length)
        )
        
        self.attributedText = attributedText
    }
    
    // MARK: - Convenience Methods
    public func setText(_ text: String?, animated: Bool = false) {
        if animated {
            UIView.transition(
                with: self,
                duration: 0.25,
                options: .transitionCrossDissolve,
                animations: {
                    self.text = text
                },
                completion: nil
            )
        } else {
            self.text = text
        }
    }
    
    public func setAttributedText(_ text: NSAttributedString, animated: Bool = false) {
        if animated {
            UIView.transition(
                with: self,
                duration: 0.25,
                options: .transitionCrossDissolve,
                animations: {
                    self.attributedText = text
                },
                completion: nil
            )
        } else {
            self.attributedText = text
        }
    }
}