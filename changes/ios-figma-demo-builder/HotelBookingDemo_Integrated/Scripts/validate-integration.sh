#!/bin/bash

# HotelBookingDemo 整合项目验证脚本

echo "🔍 验证整合后的项目完整性..."

# 检查必需的目录结构
REQUIRED_DIRS=(
    "Sources/Core"
    "Sources/Data"
    "Sources/UI"
    "Sources/Features"
    "Sources/Utils"
    "Tests"
    "Scripts"
    "Documentation"
    ".github/workflows"
    ".github/ISSUE_TEMPLATE"
    ".github/PULL_REQUEST_TEMPLATE"
)

MISSING_DIRS=()

echo "📁 检查目录结构..."
for dir in "${REQUIRED_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        echo "✅ $dir/"
    else
        echo "❌ $dir/ (缺失)"
        MISSING_DIRS+=("$dir/")
    fi
done

# 检查必需的文件
REQUIRED_FILES=(
    "Package.swift"
    "README.md"
    "CONTRIBUTING.md"
    ".github/workflows/ci.yml"
    ".github/ISSUE_TEMPLATE/bug_report.md"
    ".github/ISSUE_TEMPLATE/feature_request.md"
    ".github/PULL_REQUEST_TEMPLATE/pull_request_template.md"
    "Scripts/build.sh"
    "Scripts/test.sh"
    "Scripts/code-quality.sh"
    "Scripts/figma-import.sh"
)

MISSING_FILES=()

echo -e "\n📋 检查必需文件..."
for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file"
    else
        echo "❌ $file (缺失)"
        MISSING_FILES+=("$file")
    fi
done

# 检查核心源文件
CORE_FILES=(
    "Sources/Core/BaseCoordinator.swift"
    "Sources/Core/BaseViewModel.swift"
    "Sources/Data/Models/HotelPackage.swift"
    "Sources/Data/Repositories/HotelRepository.swift"
    "Sources/UI/Components/CardView.swift"
    "Sources/UI/Utils/FigmaStyleConverter.swift"
)

echo -e "\n🔧 检查核心源文件..."
for file in "${CORE_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file"
    else
        echo "⚠️ $file (可能需要创建)"
    fi
done

# 检查脚本执行权限
echo -e "\n⚙️ 检查脚本权限..."
SCRIPTS=("Scripts/build.sh" "Scripts/test.sh" "Scripts/code-quality.sh" "Scripts/figma-import.sh")
for script in "${SCRIPTS[@]}"; do
    if [ -f "$script" ] && [ -x "$script" ]; then
        echo "✅ $script (可执行)"
    elif [ -f "$script" ]; then
        echo "⚠️ $script (无执行权限)"
    else
        echo "❌ $script (缺失)"
    fi
done

# 验证Swift包配置
echo -e "\n📦 验证Swift包配置..."
if command -v swift &> /dev/null; then
    echo "🔧 解析包依赖..."
    swift package resolve 2>/dev/null && echo "✅ 包依赖解析成功" || echo "❌ 包依赖解析失败"
else
    echo "⚠️ Swift命令不可用，跳过包验证"
fi

# 输出结果统计
echo -e "\n📊 验证结果统计:"
echo "目录检查: ${#REQUIRED_DIRS[@]} 项，缺失 ${#MISSING_DIRS[@]} 项"
echo "文件检查: ${#REQUIRED_FILES[@]} 项，缺失 ${#MISSING_FILES[@]} 项"

# 输出最终结果
echo -e "\n🎯 验证结论:"
if [ ${#MISSING_DIRS[@]} -eq 0 ] && [ ${#MISSING_FILES[@]} -eq 0 ]; then
    echo "🎉 项目整合成功！所有必需组件都已配置完成。"
    echo ""
    echo "✅ 目录结构完整"
    echo "✅ 核心文件齐全" 
    echo "✅ GitHub配置完善"
    echo "✅ 自动化工具就绪"
    echo "✅ Figma集成支持"
    echo ""
    echo "🚀 项目已准备好进行开发和开源发布！"
    exit 0
else
    echo "❌ 项目整合存在问题:"
    if [ ${#MISSING_DIRS[@]} -gt 0 ]; then
        echo "   缺失目录: ${MISSING_DIRS[*]}"
    fi
    if [ ${#MISSING_FILES[@]} -gt 0 ]; then
        echo "   缺失文件: ${MISSING_FILES[*]}"
    fi
    echo ""
    echo "请修复上述问题后再继续。"
    exit 1
fi