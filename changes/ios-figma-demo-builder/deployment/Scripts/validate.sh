#!/bin/bash

# HotelBookingDemo 项目验证脚本

echo "🔍 验证项目完整性..."

# 检查必需文件
REQUIRED_FILES=(
    ".gitignore"
    "README.md"
    "Package.swift"
    ".github/workflows/ci.yml"
    "Scripts/build.sh"
    "Scripts/test.sh"
    "Scripts/code-quality.sh"
    "Documentation/DeliveryChecklist.md"
    "Documentation/VersionManagement.md"
    "Documentation/OperationsGuide.md"
)

MISSING_FILES=()

echo "📋 检查必需文件..."
for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file"
    else
        echo "❌ $file (缺失)"
        MISSING_FILES+=("$file")
    fi
done

# 检查目录结构
REQUIRED_DIRS=(
    "Sources"
    "Tests"
    "Scripts"
    "Documentation"
    ".github/workflows"
)

echo -e "\n📁 检查目录结构..."
for dir in "${REQUIRED_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        echo "✅ $dir/"
    else
        echo "❌ $dir/ (缺失)"
        MISSING_FILES+=("$dir/")
    fi
done

# 检查脚本执行权限
echo -e "\n⚙️ 检查脚本权限..."
SCRIPTS=("Scripts/build.sh" "Scripts/test.sh" "Scripts/code-quality.sh")
for script in "${SCRIPTS[@]}"; do
    if [ -f "$script" ] && [ -x "$script" ]; then
        echo "✅ $script (可执行)"
    elif [ -f "$script" ]; then
        echo "⚠️ $script (无执行权限)"
    else
        echo "❌ $script (缺失)"
    fi
done

# 输出结果
echo -e "\n📊 验证结果:"
if [ ${#MISSING_FILES[@]} -eq 0 ]; then
    echo "🎉 所有必需文件和目录都已正确配置!"
    echo "✅ 项目结构完整"
    echo "✅ CI/CD配置完成"
    echo "✅ 自动化脚本就绪"
    echo "✅ 文档体系完整"
    echo ""
    echo "🚀 项目已准备好进行开发!"
    exit 0
else
    echo "❌ 发现 ${#MISSING_FILES[@]} 个问题:"
    for file in "${MISSING_FILES[@]}"; do
        echo "   - $file"
    done
    echo ""
    echo "请修复上述问题后再继续。"
    exit 1
fi