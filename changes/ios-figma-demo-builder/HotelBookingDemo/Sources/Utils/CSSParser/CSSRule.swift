//
//  CSSRule.swift
//  HotelBookingDemo
//
//  Created by Builder on 2024.
//

import Foundation

/// Represents a parsed CSS rule from Figma export
struct CSSRule {
    let selector: String
    let properties: [String: String]
    let lineNumber: Int
    let sourceRange: Range<String.Index>?
    
    /// Categorizes the rule type for easier processing
    var category: RuleCategory {
        if selector.contains("color") || selector.contains("background") {
            return .color
        } else if selector.contains("font") || selector.contains("text") {
            return .typography
        } else if selector.contains("margin") || selector.contains("padding") {
            return .layout
        } else if selector.contains("width") || selector.contains("height") {
            return .dimension
        }
        return .general
    }
}

enum RuleCategory {
    case color
    case typography
    case layout
    case dimension
    case general
}