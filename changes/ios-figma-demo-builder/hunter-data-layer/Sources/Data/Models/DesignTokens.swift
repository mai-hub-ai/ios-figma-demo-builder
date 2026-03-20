//
//  DesignTokens.swift
//  HotelBookingData
//
//  Created by Hunter on 2024.
//  Copyright © 2024 Hunter. All rights reserved.
//

import Foundation
import UIKit

/// 设计令牌集合
public struct DesignTokens: Codable, Equatable {
    public let colors: ColorTokens
    public let typography: TypographyTokens
    public let spacing: SpacingTokens
    public let borderRadius: BorderRadiusTokens
    public let shadows: ShadowTokens
    public let breakpoints: BreakpointTokens
    
    public init(
        colors: ColorTokens,
        typography: TypographyTokens,
        spacing: SpacingTokens,
        borderRadius: BorderRadiusTokens,
        shadows: ShadowTokens,
        breakpoints: BreakpointTokens
    ) {
        self.colors = colors
        self.typography = typography
        self.spacing = spacing
        self.borderRadius = borderRadius
        self.shadows = shadows
        self.breakpoints = breakpoints
    }
    
    /// 合并另一个设计令牌集
    public func merging(with other: DesignTokens) -> DesignTokens {
        return DesignTokens(
            colors: colors.merging(with: other.colors),
            typography: typography.merging(with: other.typography),
            spacing: spacing.merging(with: other.spacing),
            borderRadius: borderRadius.merging(with: other.borderRadius),
            shadows: shadows.merging(with: other.shadows),
            breakpoints: breakpoints.merging(with: other.breakpoints)
        )
    }
}

// MARK: - 颜色令牌

public struct ColorTokens: Codable, Equatable {
    // 主色调
    public let primary: TokenValue
    public let primaryHover: TokenValue
    public let primaryActive: TokenValue
    
    // 次要色调
    public let secondary: TokenValue
    public let secondaryHover: TokenValue
    
    // 中性色调
    public let background: TokenValue
    public let surface: TokenValue
    public let surfaceVariant: TokenValue
    
    // 文本颜色
    public let onBackground: TokenValue
    public let onSurface: TokenValue
    public let onSurfaceVariant: TokenValue
    
    // 状态颜色
    public let success: TokenValue
    public let warning: TokenValue
    public let error: TokenValue
    public let info: TokenValue
    
    // 其他颜色
    public let outline: TokenValue
    public let shadow: TokenValue
    
    public init(
        primary: TokenValue,
        primaryHover: TokenValue,
        primaryActive: TokenValue,
        secondary: TokenValue,
        secondaryHover: TokenValue,
        background: TokenValue,
        surface: TokenValue,
        surfaceVariant: TokenValue,
        onBackground: TokenValue,
        onSurface: TokenValue,
        onSurfaceVariant: TokenValue,
        success: TokenValue,
        warning: TokenValue,
        error: TokenValue,
        info: TokenValue,
        outline: TokenValue,
        shadow: TokenValue
    ) {
        self.primary = primary
        self.primaryHover = primaryHover
        self.primaryActive = primaryActive
        self.secondary = secondary
        self.secondaryHover = secondaryHover
        self.background = background
        self.surface = surface
        self.surfaceVariant = surfaceVariant
        self.onBackground = onBackground
        self.onSurface = onSurface
        self.onSurfaceVariant = onSurfaceVariant
        self.success = success
        self.warning = warning
        self.error = error
        self.info = info
        self.outline = outline
        self.shadow = shadow
    }
    
    public func merging(with other: ColorTokens) -> ColorTokens {
        return ColorTokens(
            primary: other.primary.value.isEmpty ? primary : other.primary,
            primaryHover: other.primaryHover.value.isEmpty ? primaryHover : other.primaryHover,
            primaryActive: other.primaryActive.value.isEmpty ? primaryActive : other.primaryActive,
            secondary: other.secondary.value.isEmpty ? secondary : other.secondary,
            secondaryHover: other.secondaryHover.value.isEmpty ? secondaryHover : other.secondaryHover,
            background: other.background.value.isEmpty ? background : other.background,
            surface: other.surface.value.isEmpty ? surface : other.surface,
            surfaceVariant: other.surfaceVariant.value.isEmpty ? surfaceVariant : other.surfaceVariant,
            onBackground: other.onBackground.value.isEmpty ? onBackground : other.onBackground,
            onSurface: other.onSurface.value.isEmpty ? onSurface : other.onSurface,
            onSurfaceVariant: other.onSurfaceVariant.value.isEmpty ? onSurfaceVariant : other.onSurfaceVariant,
            success: other.success.value.isEmpty ? success : other.success,
            warning: other.warning.value.isEmpty ? warning : other.warning,
            error: other.error.value.isEmpty ? error : other.error,
            info: other.info.value.isEmpty ? info : other.info,
            outline: other.outline.value.isEmpty ? outline : other.outline,
            shadow: other.shadow.value.isEmpty ? shadow : other.shadow
        )
    }
}

// MARK: - 排版令牌

public struct TypographyTokens: Codable, Equatable {
    public let displayLarge: FontToken
    public let displayMedium: FontToken
    public let displaySmall: FontToken
    public let headlineLarge: FontToken
    public let headlineMedium: FontToken
    public let headlineSmall: FontToken
    public let titleLarge: FontToken
    public let titleMedium: FontToken
    public let titleSmall: FontToken
    public let bodyLarge: FontToken
    public let bodyMedium: FontToken
    public let bodySmall: FontToken
    public let labelLarge: FontToken
    public let labelMedium: FontToken
    public let labelSmall: FontToken
    
    public init(
        displayLarge: FontToken,
        displayMedium: FontToken,
        displaySmall: FontToken,
        headlineLarge: FontToken,
        headlineMedium: FontToken,
        headlineSmall: FontToken,
        titleLarge: FontToken,
        titleMedium: FontToken,
        titleSmall: FontToken,
        bodyLarge: FontToken,
        bodyMedium: FontToken,
        bodySmall: FontToken,
        labelLarge: FontToken,
        labelMedium: FontToken,
        labelSmall: FontToken
    ) {
        self.displayLarge = displayLarge
        self.displayMedium = displayMedium
        self.displaySmall = displaySmall
        self.headlineLarge = headlineLarge
        self.headlineMedium = headlineMedium
        self.headlineSmall = headlineSmall
        self.titleLarge = titleLarge
        self.titleMedium = titleMedium
        self.titleSmall = titleSmall
        self.bodyLarge = bodyLarge
        self.bodyMedium = bodyMedium
        self.bodySmall = bodySmall
        self.labelLarge = labelLarge
        self.labelMedium = labelMedium
        self.labelSmall = labelSmall
    }
    
    public func merging(with other: TypographyTokens) -> TypographyTokens {
        return TypographyTokens(
            displayLarge: other.displayLarge.fontName.isEmpty ? displayLarge : other.displayLarge,
            displayMedium: other.displayMedium.fontName.isEmpty ? displayMedium : other.displayMedium,
            displaySmall: other.displaySmall.fontName.isEmpty ? displaySmall : other.displaySmall,
            headlineLarge: other.headlineLarge.fontName.isEmpty ? headlineLarge : other.headlineLarge,
            headlineMedium: other.headlineMedium.fontName.isEmpty ? headlineMedium : other.headlineMedium,
            headlineSmall: other.headlineSmall.fontName.isEmpty ? headlineSmall : other.headlineSmall,
            titleLarge: other.titleLarge.fontName.isEmpty ? titleLarge : other.titleLarge,
            titleMedium: other.titleMedium.fontName.isEmpty ? titleMedium : other.titleMedium,
            titleSmall: other.titleSmall.fontName.isEmpty ? titleSmall : other.titleSmall,
            bodyLarge: other.bodyLarge.fontName.isEmpty ? bodyLarge : other.bodyLarge,
            bodyMedium: other.bodyMedium.fontName.isEmpty ? bodyMedium : other.bodyMedium,
            bodySmall: other.bodySmall.fontName.isEmpty ? bodySmall : other.bodySmall,
            labelLarge: other.labelLarge.fontName.isEmpty ? labelLarge : other.labelLarge,
            labelMedium: other.labelMedium.fontName.isEmpty ? labelMedium : other.labelMedium,
            labelSmall: other.labelSmall.fontName.isEmpty ? labelSmall : other.labelSmall
        )
    }
}

// MARK: - 间距令牌

public struct SpacingTokens: Codable, Equatable {
    public let xxxs: TokenValue  // 2px
    public let xxs: TokenValue   // 4px
    public let xs: TokenValue    // 8px
    public let s: TokenValue     // 12px
    public let m: TokenValue     // 16px
    public let l: TokenValue     // 24px
    public let xl: TokenValue    // 32px
    public let xxl: TokenValue   // 48px
    public let xxxl: TokenValue  // 64px
    
    public init(
        xxxs: TokenValue,
        xxs: TokenValue,
        xs: TokenValue,
        s: TokenValue,
        m: TokenValue,
        l: TokenValue,
        xl: TokenValue,
        xxl: TokenValue,
        xxxl: TokenValue
    ) {
        self.xxxs = xxxs
        self.xxs = xxs
        self.xs = xs
        self.s = s
        self.m = m
        self.l = l
        self.xl = xl
        self.xxl = xxl
        self.xxxl = xxxl
    }
    
    public func merging(with other: SpacingTokens) -> SpacingTokens {
        return SpacingTokens(
            xxxs: other.xxxs.value.isEmpty ? xxxs : other.xxxs,
            xxs: other.xxs.value.isEmpty ? xxs : other.xxs,
            xs: other.xs.value.isEmpty ? xs : other.xs,
            s: other.s.value.isEmpty ? s : other.s,
            m: other.m.value.isEmpty ? m : other.m,
            l: other.l.value.isEmpty ? l : other.l,
            xl: other.xl.value.isEmpty ? xl : other.xl,
            xxl: other.xxl.value.isEmpty ? xxl : other.xxl,
            xxxl: other.xxxl.value.isEmpty ? xxxl : other.xxxl
        )
    }
}

// MARK: - 圆角令牌

public struct BorderRadiusTokens: Codable, Equatable {
    public let none: TokenValue   // 0px
    public let xs: TokenValue     // 2px
    public let s: TokenValue      // 4px
    public let m: TokenValue      // 8px
    public let l: TokenValue      // 12px
    public let xl: TokenValue     // 16px
    public let pill: TokenValue   // 9999px
    public let circle: TokenValue // 50%
    
    public init(
        none: TokenValue,
        xs: TokenValue,
        s: TokenValue,
        m: TokenValue,
        l: TokenValue,
        xl: TokenValue,
        pill: TokenValue,
        circle: TokenValue
    ) {
        self.none = none
        self.xs = xs
        self.s = s
        self.m = m
        self.l = l
        self.xl = xl
        self.pill = pill
        self.circle = circle
    }
    
    public func merging(with other: BorderRadiusTokens) -> BorderRadiusTokens {
        return BorderRadiusTokens(
            none: other.none.value.isEmpty ? none : other.none,
            xs: other.xs.value.isEmpty ? xs : other.xs,
            s: other.s.value.isEmpty ? s : other.s,
            m: other.m.value.isEmpty ? m : other.m,
            l: other.l.value.isEmpty ? l : other.l,
            xl: other.xl.value.isEmpty ? xl : other.xl,
            pill: other.pill.value.isEmpty ? pill : other.pill,
            circle: other.circle.value.isEmpty ? circle : other.circle
        )
    }
}

// MARK: - 阴影令牌

public struct ShadowTokens: Codable, Equatable {
    public let none: TokenValue
    public let xs: TokenValue
    public let s: TokenValue
    public let m: TokenValue
    public let l: TokenValue
    public let xl: TokenValue
    
    public init(
        none: TokenValue,
        xs: TokenValue,
        s: TokenValue,
        m: TokenValue,
        l: TokenValue,
        xl: TokenValue
    ) {
        self.none = none
        self.xs = xs
        self.s = s
        self.m = m
        self.l = l
        self.xl = xl
    }
    
    public func merging(with other: ShadowTokens) -> ShadowTokens {
        return ShadowTokens(
            none: other.none.value.isEmpty ? none : other.none,
            xs: other.xs.value.isEmpty ? xs : other.xs,
            s: other.s.value.isEmpty ? s : other.s,
            m: other.m.value.isEmpty ? m : other.m,
            l: other.l.value.isEmpty ? l : other.l,
            xl: other.xl.value.isEmpty ? xl : other.xl
        )
    }
}

// MARK: - 断点令牌

public struct BreakpointTokens: Codable, Equatable {
    public let mobile: TokenValue    // 0px
    public let tablet: TokenValue    // 768px
    public let laptop: TokenValue    // 1024px
    public let desktop: TokenValue   // 1200px
    public let wide: TokenValue      // 1440px
    
    public init(
        mobile: TokenValue,
        tablet: TokenValue,
        laptop: TokenValue,
        desktop: TokenValue,
        wide: TokenValue
    ) {
        self.mobile = mobile
        self.tablet = tablet
        self.laptop = laptop
        self.desktop = desktop
        self.wide = wide
    }
    
    public func merging(with other: BreakpointTokens) -> BreakpointTokens {
        return BreakpointTokens(
            mobile: other.mobile.value.isEmpty ? mobile : other.mobile,
            tablet: other.tablet.value.isEmpty ? tablet : other.tablet,
            laptop: other.laptop.value.isEmpty ? laptop : other.laptop,
            desktop: other.desktop.value.isEmpty ? desktop : other.desktop,
            wide: other.wide.value.isEmpty ? wide : other.wide
        )
    }
}

// MARK: - 基础令牌值类型

public struct TokenValue: Codable, Equatable {
    public let value: String
    public let description: String?
    
    public init(value: String, description: String? = nil) {
        self.value = value
        self.description = description
    }
    
    /// 转换为UIColor（如果是颜色值）
    public func toUIColor() -> UIColor? {
        return FigmaStyleConverter.convertColor(from: value)
    }
    
    /// 转换为CGFloat（如果是数值）
    public func toCGFloat() -> CGFloat? {
        return FigmaStyleConverter.convertSpacing(from: value)
    }
}

public struct FontToken: Codable, Equatable {
    public let fontName: String
    public let fontSize: TokenValue
    public let fontWeight: String
    public let lineHeight: TokenValue?
    public let letterSpacing: TokenValue?
    public let description: String?
    
    public init(
        fontName: String,
        fontSize: TokenValue,
        fontWeight: String,
        lineHeight: TokenValue? = nil,
        letterSpacing: TokenValue? = nil,
        description: String? = nil
    ) {
        self.fontName = fontName
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.lineHeight = lineHeight
        self.letterSpacing = letterSpacing
        self.description = description
    }
    
    /// 转换为UIFont
    public func toUIFont() -> UIFont? {
        guard let fontSizeValue = fontSize.toCGFloat() else { return nil }
        let weight = FigmaStyleConverter.convertFontWeight(from: fontWeight) ?? .regular
        return UIFont(name: fontName, size: fontSizeValue) ?? UIFont.systemFont(ofSize: fontSizeValue, weight: weight)
    }
}