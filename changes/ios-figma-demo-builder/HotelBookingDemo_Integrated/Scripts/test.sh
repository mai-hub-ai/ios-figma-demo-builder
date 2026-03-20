#!/bin/bash

# HotelBookingDemo 测试脚本

set -e

echo "🧪 运行测试套件..."

# 运行单元测试
echo "🔬 运行单元测试..."
swift test --enable-code-coverage

# 生成代码覆盖率报告
echo "📊 生成代码覆盖率报告..."
if [ -f ".build/debug/codecov/default.profdata" ]; then
    xcrun llvm-cov export -format="html" \
        .build/debug/HotelBookingDemoPackageTests.xctest/Contents/MacOS/HotelBookingDemoPackageTests \
        -instr-profile .build/debug/codecov/default.profdata \
        -o coverage-report
        
    echo "✅ 代码覆盖率报告已生成: coverage-report/index.html"
else
    echo "⚠️ 未找到覆盖率数据文件"
fi

echo "✅ 测试完成!"