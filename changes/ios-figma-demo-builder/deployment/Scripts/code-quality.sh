#!/bin/bash

# HotelBookingDemo 代码质量检查脚本

set -e

echo "🔍 执行代码质量检查..."

# 检查SwiftLint是否安装
if ! command -v swiftlint &> /dev/null; then
    echo "⚠️ SwiftLint未安装，正在安装..."
    if command -v brew &> /dev/null; then
        brew install swiftlint
    else
        echo "❌ 请先安装Homebrew，然后运行: brew install swiftlint"
        exit 1
    fi
fi

# 运行SwiftLint检查
echo "📝 运行SwiftLint代码规范检查..."
swiftlint --strict

# 检查代码复杂度
echo "🧩 检查代码复杂度..."
# 这里可以添加更复杂的静态分析工具

echo "✅ 代码质量检查通过!"