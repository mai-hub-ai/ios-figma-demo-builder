//
//  CSSParser.swift
//  HotelBookingDemo
//
//  Created by Builder on 2024.
//

import Foundation

/// Parses Figma CSS exports into structured data
class CSSParser {
    
    struct ParseResult {
        let rules: [CSSRule]
        let errors: [ParseError]
        let warnings: [ParseWarning]
    }
    
    struct ParseError {
        let message: String
        let lineNumber: Int
        let column: Int
    }
    
    struct ParseWarning {
        let message: String
        let lineNumber: Int
    }
    
    /// Parses CSS string and returns structured rules
    func parse(_ cssString: String) -> ParseResult {
        var rules: [CSSRule] = []
        var errors: [ParseError] = []
        var warnings: [ParseWarning] = []
        
        let lines = cssString.components(separatedBy: .newlines)
        
        var currentSelector = ""
        var currentProperties: [String: String] = [:]
        var lineNumber = 0
        
        for line in lines {
            lineNumber += 1
            
            let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Skip empty lines and comments
            if trimmedLine.isEmpty || trimmedLine.hasPrefix("/*") {
                continue
            }
            
            // Selector detection
            if trimmedLine.hasSuffix("{") {
                currentSelector = trimmedLine.dropLast().trimmingCharacters(in: .whitespaces)
                currentProperties.removeAll()
            }
            // Property detection
            else if trimmedLine.hasSuffix(";") && trimmedLine.contains(":") {
                let propertyPair = trimmedLine.dropLast().components(separatedBy: ":")
                if propertyPair.count == 2 {
                    let key = propertyPair[0].trimmingCharacters(in: .whitespaces)
                    let value = propertyPair[1].trimmingCharacters(in: .whitespaces)
                    currentProperties[key] = value
                }
            }
            // Rule completion
            else if trimmedLine == "}" && !currentSelector.isEmpty {
                let rule = CSSRule(
                    selector: currentSelector,
                    properties: currentProperties,
                    lineNumber: lineNumber,
                    sourceRange: nil
                )
                rules.append(rule)
                currentSelector = ""
                currentProperties.removeAll()
            }
        }
        
        return ParseResult(rules: rules, errors: errors, warnings: warnings)
    }
}