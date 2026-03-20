//
//  AutoLayoutHelper.swift
//  HotelBookingDemo
//
//  Created by Designer on 2024.
//

import UIKit

public class AutoLayoutHelper {
    
    // MARK: - Edge Constraints
    public static func pinToEdges(
        _ view: UIView,
        in superview: UIView,
        insets: UIEdgeInsets = .zero,
        activate: Bool = true
    ) -> [NSLayoutConstraint] {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            view.topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top),
            view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left),
            view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right),
            view.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom)
        ]
        
        if activate {
            NSLayoutConstraint.activate(constraints)
        }
        
        return constraints
    }
    
    // MARK: - Size Constraints
    public static func setSize(
        _ view: UIView,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        activate: Bool = true
    ) -> [NSLayoutConstraint] {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints: [NSLayoutConstraint] = []
        
        if let width = width {
            let widthConstraint = view.widthAnchor.constraint(equalToConstant: width)
            constraints.append(widthConstraint)
        }
        
        if let height = height {
            let heightConstraint = view.heightAnchor.constraint(equalToConstant: height)
            constraints.append(heightConstraint)
        }
        
        if activate {
            NSLayoutConstraint.activate(constraints)
        }
        
        return constraints
    }
    
    // MARK: - Center Constraints
    public static func center(
        _ view: UIView,
        in superview: UIView,
        offsetX: CGFloat = 0,
        offsetY: CGFloat = 0,
        activate: Bool = true
    ) -> [NSLayoutConstraint] {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            view.centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: offsetX),
            view.centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: offsetY)
        ]
        
        if activate {
            NSLayoutConstraint.activate(constraints)
        }
        
        return constraints
    }
    
    // MARK: - Stack View Helpers
    public static func createVerticalStack(
        views: [UIView],
        spacing: CGFloat = Spacing.m,
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill,
        activate: Bool = true
    ) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .vertical
        stackView.spacing = spacing
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        if activate {
            // You would typically add this to a superview and set constraints there
        }
        
        return stackView
    }
    
    public static func createHorizontalStack(
        views: [UIView],
        spacing: CGFloat = Spacing.m,
        alignment: UIStackView.Alignment = .center,
        distribution: UIStackView.Distribution = .fill,
        activate: Bool = true
    ) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .horizontal
        stackView.spacing = spacing
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        if activate {
            // You would typically add this to a superview and set constraints there
        }
        
        return stackView
    }
    
    // MARK: - Flexible Constraint Builder
    public struct ConstraintBuilder {
        private var constraints: [NSLayoutConstraint] = []
        
        public mutating func add(_ constraint: NSLayoutConstraint) {
            constraints.append(constraint)
        }
        
        public func activate() {
            NSLayoutConstraint.activate(constraints)
        }
        
        public var isActive: Bool {
            didSet {
                if isActive {
                    NSLayoutConstraint.activate(constraints)
                } else {
                    NSLayoutConstraint.deactivate(constraints)
                }
            }
        }
        
        public init(isActive: Bool = true) {
            self.isActive = isActive
        }
    }
    
    // MARK: - Advanced Layout Patterns
    public static func createCardLayout(
        contentView: UIView,
        in container: UIView,
        padding: UIEdgeInsets = UIEdgeInsets(top: Spacing.m, left: Spacing.m, bottom: Spacing.m, right: Spacing.m)
    ) -> [NSLayoutConstraint] {
        return pinToEdges(contentView, in: container, insets: padding)
    }
    
    public static func createHeaderFooterLayout(
        header: UIView,
        content: UIView,
        footer: UIView,
        in container: UIView,
        verticalSpacing: CGFloat = Spacing.m
    ) -> [NSLayoutConstraint] {
        header.translatesAutoresizingMaskIntoConstraints = false
        content.translatesAutoresizingMaskIntoConstraints = false
        footer.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            // Header
            header.topAnchor.constraint(equalTo: container.topAnchor),
            header.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            
            // Content
            content.topAnchor.constraint(equalTo: header.bottomAnchor, constant: verticalSpacing),
            content.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            
            // Footer
            footer.topAnchor.constraint(equalTo: content.bottomAnchor, constant: verticalSpacing),
            footer.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            footer.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            footer.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
        return constraints
    }
    
    public static func createSideBySideLayout(
        leftView: UIView,
        rightView: UIView,
        in container: UIView,
        spacing: CGFloat = Spacing.m,
        leftWidthRatio: CGFloat = 0.5
    ) -> [NSLayoutConstraint] {
        leftView.translatesAutoresizingMaskIntoConstraints = false
        rightView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            // Left view
            leftView.topAnchor.constraint(equalTo: container.topAnchor),
            leftView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            leftView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            
            // Right view
            rightView.topAnchor.constraint(equalTo: container.topAnchor),
            rightView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            rightView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            
            // Spacing and width ratio
            rightView.leadingAnchor.constraint(equalTo: leftView.trailingAnchor, constant: spacing),
            leftView.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: leftWidthRatio)
        ]
        
        NSLayoutConstraint.activate(constraints)
        return constraints
    }
    
    // MARK: - Responsive Constraints
    public static func createResponsiveConstraints(
        for view: UIView,
        minWidth: CGFloat? = nil,
        maxWidth: CGFloat? = nil,
        minHeight: CGFloat? = nil,
        maxHeight: CGFloat? = nil
    ) -> [NSLayoutConstraint] {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints: [NSLayoutConstraint] = []
        
        if let minWidth = minWidth {
            let constraint = view.widthAnchor.constraint(greaterThanOrEqualToConstant: minWidth)
            constraint.priority = .defaultHigh
            constraints.append(constraint)
        }
        
        if let maxWidth = maxWidth {
            let constraint = view.widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth)
            constraint.priority = .defaultHigh
            constraints.append(constraint)
        }
        
        if let minHeight = minHeight {
            let constraint = view.heightAnchor.constraint(greaterThanOrEqualToConstant: minHeight)
            constraint.priority = .defaultHigh
            constraints.append(constraint)
        }
        
        if let maxHeight = maxHeight {
            let constraint = view.heightAnchor.constraint(lessThanOrEqualToConstant: maxHeight)
            constraint.priority = .defaultHigh
            constraints.append(constraint)
        }
        
        return constraints
    }
    
    // MARK: - Safe Area Support
    public static func pinToSafeArea(
        _ view: UIView,
        in superview: UIView,
        insets: UIEdgeInsets = .zero,
        activate: Bool = true
    ) -> [NSLayoutConstraint] {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            view.topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: insets.top),
            view.leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor, constant: insets.left),
            view.trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor, constant: -insets.right),
            view.bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: -insets.bottom)
        ]
        
        if activate {
            NSLayoutConstraint.activate(constraints)
        }
        
        return constraints
    }
}

// MARK: - UIView Extension for Easy Constraint Access
public extension UIView {
    func pinToEdges(of superview: UIView, insets: UIEdgeInsets = .zero) {
        AutoLayoutHelper.pinToEdges(self, in: superview, insets: insets)
    }
    
    func center(in superview: UIView, offsetX: CGFloat = 0, offsetY: CGFloat = 0) {
        AutoLayoutHelper.center(self, in: superview, offsetX: offsetX, offsetY: offsetY)
    }
    
    func setSize(width: CGFloat? = nil, height: CGFloat? = nil) {
        AutoLayoutHelper.setSize(self, width: width, height: height)
    }
}