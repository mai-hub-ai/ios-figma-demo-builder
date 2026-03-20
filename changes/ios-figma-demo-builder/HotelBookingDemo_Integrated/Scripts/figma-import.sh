#!/bin/bash

# Figma CSS 解析和转换工具
# 用法: ./Scripts/figma-import.sh <css_file_path>

set -e

# 配置变量
CSS_FILE_PATH="$1"
OUTPUT_DIR="Sources/UI/FigmaGenerated"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

echo "🎨 开始处理Figma CSS文件: $CSS_FILE_PATH"

# 检查输入文件
if [ ! -f "$CSS_FILE_PATH" ]; then
    echo "❌ CSS文件不存在: $CSS_FILE_PATH"
    echo "用法: $0 <css_file_path>"
    exit 1
fi

# 创建输出目录
mkdir -p "$OUTPUT_DIR"

# 备份原有文件
if [ -d "$OUTPUT_DIR" ] && [ "$(ls -A $OUTPUT_DIR)" ]; then
    BACKUP_DIR="Backup/FigmaGenerated_$TIMESTAMP"
    mkdir -p "$BACKUP_DIR"
    cp -r "$OUTPUT_DIR"/* "$BACKUP_DIR"/ 2>/dev/null || true
    echo "💾 已备份原有文件到: $BACKUP_DIR"
fi

# 解析CSS文件
echo "🔍 解析CSS样式规则..."

# 提取颜色定义
echo "🎨 提取颜色令牌..."
grep -E "(#[0-9a-fA-F]{6}|rgb|rgba|hsl|hsla)" "$CSS_FILE_PATH" | \
    sed -E 's/.*color[^:]*:[[:space:]]*([^;]+);.*/\1/' | \
    sort | uniq > "$OUTPUT_DIR/colors_temp.txt"

# 提取字体样式
echo "🔤 提取字体令牌..."
grep -E "(font-family|font-size|font-weight)" "$CSS_FILE_PATH" | \
    sed -E 's/.*font-([a-z-]+)[[:space:]]*:[[:space:]]*([^;]+);.*/\1:\2/' | \
    sort | uniq > "$OUTPUT_DIR/fonts_temp.txt"

# 提取间距定义
echo "📏 提取间距令牌..."
grep -E "(margin|padding)" "$CSS_FILE_PATH" | \
    sed -E 's/.*(margin|padding)-([a-z]+)[[:space:]]*:[[:space:]]*([^;]+);.*/\1-\2:\3/' | \
    sort | uniq > "$OUTPUT_DIR/spacing_temp.txt"

# 生成Swift代码文件
echo "📱 生成Swift组件代码..."

# 生成颜色枚举
cat > "$OUTPUT_DIR/FigmaColors.swift" << EOF
//
//  FigmaColors.swift
//  HotelBookingDemo
//
//  Figma CSS 导入的颜色令牌
//  生成时间: $(date)

import UIKit

enum FigmaColors {
EOF

while IFS= read -r color_line; do
    if [[ -n "$color_line" ]]; then
        # 简单的颜色名称提取逻辑
        color_name=$(echo "$color_line" | tr '[:upper:]' '[:lower:]' | tr -cd '[:alnum:]')
        echo "    static let $color_name = UIColor(css: \"$color_line\")" >> "$OUTPUT_DIR/FigmaColors.swift"
    fi
done < "$OUTPUT_DIR/colors_temp.txt"

cat >> "$OUTPUT_DIR/FigmaColors.swift" << EOF
}

// MARK: - UIColor Extension
extension UIColor {
    convenience init(css: String) {
        // 简化的CSS颜色解析
        if css.hasPrefix("#") {
            let hexString = String(css.dropFirst())
            var rgbValue: UInt64 = 0
            Scanner(string: hexString).scanHexInt64(&rgbValue)
            
            let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
            let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
            
            self.init(red: red, green: green, blue: blue, alpha: 1.0)
        } else {
            self.init(white: 0.0, alpha: 1.0) // 默认颜色
        }
    }
}
EOF

# 生成字体枚举
cat > "$OUTPUT_DIR/FigmaFonts.swift" << EOF
//
//  FigmaFonts.swift
//  HotelBookingDemo
//
//  Figma CSS 导入的字体令牌
//  生成时间: $(date)

import UIKit

enum FigmaFonts {
EOF

while IFS= read -r font_line; do
    if [[ -n "$font_line" ]]; then
        property=$(echo "$font_line" | cut -d':' -f1)
        value=$(echo "$font_line" | cut -d':' -f2)
        
        case "$property" in
            "family")
                font_name=$(echo "$value" | tr -cd '[:alnum:]')
                echo "    static let $font_name = UIFont(name: \"$value\", size: 16.0) ?? .systemFont(ofSize: 16.0)" >> "$OUTPUT_DIR/FigmaFonts.swift"
                ;;
            "size")
                size_value=$(echo "$value" | tr -cd '[:digit:]')
                echo "    static let size$size_value = UIFont.systemFont(ofSize: CGFloat($size_value))" >> "$OUTPUT_DIR/FigmaFonts.swift"
                ;;
        esac
    fi
done < "$OUTPUT_DIR/fonts_temp.txt"

cat >> "$OUTPUT_DIR/FigmaFonts.swift" << EOF
}
EOF

# 清理临时文件
rm -f "$OUTPUT_DIR"/*_temp.txt

echo "✅ Figma CSS处理完成!"
echo "📁 生成文件位置: $OUTPUT_DIR/"
echo "📎 包含文件:"
echo "   - FigmaColors.swift"
echo "   - FigmaFonts.swift"
echo ""
echo "💡 下一步: 将生成的组件集成到项目中"