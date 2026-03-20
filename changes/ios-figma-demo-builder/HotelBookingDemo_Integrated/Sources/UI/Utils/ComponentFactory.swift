//
//  ComponentFactory.swift
//  HotelBookingDemo
//
//  Created by Designer on 2024.
//

import UIKit

// MARK: - Component Configuration Models
public struct ComponentConfiguration {
    public let type: ComponentType
    public let style: [String: Any]
    public let constraints: [LayoutConstraint]
    public let children: [ComponentConfiguration]
    
    public init(type: ComponentType, style: [String: Any] = [:], constraints: [LayoutConstraint] = [], children: [ComponentConfiguration] = []) {
        self.type = type
        self.style = style
        self.constraints = constraints
        self.children = children
    }
}

public enum ComponentType {
    case view
    case label
    case button
    case imageView
    case stackView
    case scrollView
    case collectionView
    case tableView
    case textField
    case textView
    case card
}

public struct LayoutConstraint {
    public let attribute: NSLayoutConstraint.Attribute
    public let relation: NSLayoutConstraint.Relation
    public let constant: CGFloat
    public let multiplier: CGFloat
    public let priority: UILayoutPriority
    
    public init(attribute: NSLayoutConstraint.Attribute, relation: NSLayoutConstraint.Relation = .equal, constant: CGFloat = 0, multiplier: CGFloat = 1.0, priority: UILayoutPriority = .required) {
        self.attribute = attribute
        self.relation = relation
        self.constant = constant
        self.multiplier = multiplier
        self.priority = priority
    }
}

// MARK: - Component Factory
public class ComponentFactory {
    
    public static let shared = ComponentFactory()
    
    private init() {}
    
    // MARK: - Component Creation
    public func createComponent(from config: ComponentConfiguration) -> UIView {
        let view = createView(for: config.type)
        applyStyles(to: view, with: config.style)
        applyConstraints(to: view, with: config.constraints)
        
        // Create and add child components
        for childConfig in config.children {
            let childView = createComponent(from: childConfig)
            if let stackView = view as? UIStackView {
                stackView.addArrangedSubview(childView)
            } else {
                view.addSubview(childView)
            }
        }
        
        return view
    }
    
    private func createView(for type: ComponentType) -> UIView {
        switch type {
        case .view:
            return UIView()
        case .label:
            return CustomLabel()
        case .button:
            return CustomButton()
        case .imageView:
            return UIImageView()
        case .stackView:
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        case .scrollView:
            let scrollView = UIScrollView()
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            return scrollView
        case .collectionView:
            let layout = UICollectionViewFlowLayout()
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            return collectionView
        case .tableView:
            let tableView = UITableView()
            tableView.translatesAutoresizingMaskIntoConstraints = false
            return tableView
        case .textField:
            let textField = UITextField()
            textField.translatesAutoresizingMaskIntoConstraints = false
            return textField
        case .textView:
            let textView = UITextView()
            textView.translatesAutoresizingMaskIntoConstraints = false
            return textView
        case .card:
            return CardView()
        }
    }
    
    // MARK: - Style Application
    private func applyStyles(to view: UIView, with styles: [String: Any]) {
        for (property, value) in styles {
            applyStyleProperty(property, value: value, to: view)
        }
    }
    
    private func applyStyleProperty(_ property: String, value: Any, to view: UIView) {
        switch property.lowercased() {
        case "backgroundcolor", "background-color":
            if let colorString = value as? String,
               let color = FigmaStyleConverter.convertColor(from: colorString) {
                view.backgroundColor = color
            } else if let color = value as? UIColor {
                view.backgroundColor = color
            }
            
        case "width":
            if let widthString = value as? String,
               let width = FigmaStyleConverter.convertSpacing(from: widthString) {
                view.widthAnchor.constraint(equalToConstant: width).isActive = true
            } else if let width = value as? CGFloat {
                view.widthAnchor.constraint(equalToConstant: width).isActive = true
            }
            
        case "height":
            if let heightString = value as? String,
               let height = FigmaStyleConverter.convertSpacing(from: heightString) {
                view.heightAnchor.constraint(equalToConstant: height).isActive = true
            } else if let height = value as? CGFloat {
                view.heightAnchor.constraint(equalToConstant: height).isActive = true
            }
            
        case "cornerradius", "border-radius":
            if let radiusString = value as? String,
               let radius = FigmaStyleConverter.convertBorderRadius(from: radiusString) {
                view.layer.cornerRadius = radius
            } else if let radius = value as? CGFloat {
                view.layer.cornerRadius = radius
            }
            
        case "text":
            if let label = view as? UILabel, let text = value as? String {
                label.text = text
            }
            
        case "font":
            if let label = view as? UILabel,
               let fontString = value as? String,
               let font = FigmaStyleConverter.convertFont(from: fontString) {
                label.font = font
            }
            
        case "textcolor", "color":
            if let label = view as? UILabel,
               let colorString = value as? String,
               let color = FigmaStyleConverter.convertColor(from: colorString) {
                label.textColor = color
            } else if let label = view as? UILabel, let color = value as? UIColor {
                label.textColor = color
            }
            
        case "textalignment", "text-align":
            if let label = view as? UILabel, let alignString = value as? String {
                label.textAlignment = FigmaStyleConverter.convertTextAlign(from: alignString)
            }
            
        case "axis":
            if let stackView = view as? UIStackView, let axisString = value as? String {
                stackView.axis = FigmaStyleConverter.convertFlexDirection(from: axisString)
            }
            
        case "spacing":
            if let stackView = view as? UIStackView,
               let spacingString = value as? String,
               let spacing = FigmaStyleConverter.convertSpacing(from: spacingString) {
                stackView.spacing = spacing
            } else if let stackView = view as? UIStackView, let spacing = value as? CGFloat {
                stackView.spacing = spacing
            }
            
        default:
            break
        }
    }
    
    // MARK: - Constraint Application
    private func applyConstraints(to view: UIView, with constraints: [LayoutConstraint]) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        for constraintConfig in constraints {
            // This is a simplified implementation - in practice, you'd need to know the superview
            // and which attributes to constrain to
            switch constraintConfig.attribute {
            case .width:
                view.widthAnchor.constraint(
                    relation: constraintConfig.relation,
                    constant: constraintConfig.constant
                ).isActive = true
                
            case .height:
                view.heightAnchor.constraint(
                    relation: constraintConfig.relation,
                    constant: constraintConfig.constant
                ).isActive = true
                
            default:
                // Handle other constraints as needed
                break
            }
        }
    }
    
    // MARK: - Convenience Methods
    public func createHotelCard(title: String, price: String, imageName: String?) -> CardView {
        let card = CardView.hotelCard()
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Spacing.s
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Image
        if let imageName = imageName {
            let imageView = UIImageView(image: UIImage(named: imageName))
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
            stackView.addArrangedSubview(imageView)
        }
        
        // Title
        let titleLabel = CustomLabel(text: title, style: .headlineMedium)
        stackView.addArrangedSubview(titleLabel)
        
        // Price
        let priceLabel = CustomLabel(text: price, style: .priceLarge)
        stackView.addArrangedSubview(priceLabel)
        
        card.contentView.addSubview(stackView)
        
        // Constraints
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: card.contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: card.contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: card.contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: card.contentView.bottomAnchor)
        ])
        
        return card
    }
    
    public func createSearchBar(placeholder: String) -> UIView {
        let container = UIView()
        container.backgroundColor = Colors.surface
        container.layer.cornerRadius = BorderRadius.large
        container.layer.borderWidth = BorderWidth.thin
        container.layer.borderColor = Colors.border.cgColor
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Spacing.s
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Search icon
        let searchIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchIcon.tintColor = Colors.textSecondary
        searchIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        // Text field
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.font = Typography.bodyMedium
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(searchIcon)
        stackView.addArrangedSubview(textField)
        
        container.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: container.topAnchor, constant: Spacing.s),
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: Spacing.m),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -Spacing.m),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -Spacing.s),
            container.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        return container
    }
}