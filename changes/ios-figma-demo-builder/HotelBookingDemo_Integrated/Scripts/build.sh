#!/bin/bash

# HotelBookingDemo 构建脚本
# 用法: ./Scripts/build.sh [debug|release]

set -e

# 配置变量
PROJECT_NAME="HotelBookingDemo"
SCHEME="HotelBookingDemo"
CONFIGURATION=${1:-debug}
BUILD_DIR="build"

echo "🚀 开始构建 $PROJECT_NAME ($CONFIGURATION)..."

# 清理之前的构建
echo "🧹 清理构建目录..."
rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR

# 解析参数
case $CONFIGURATION in
    "debug")
        XCODE_CONFIG="Debug"
        ;;
    "release")
        XCODE_CONFIG="Release"
        ;;
    *)
        echo "❌ 无效的配置参数: $CONFIGURATION"
        echo "用法: $0 [debug|release]"
        exit 1
        ;;
esac

# 构建项目
echo "🔨 构建项目..."
xcodebuild -scheme $SCHEME \
    -configuration $XCODE_CONFIG \
    -sdk iphoneos \
    -derivedDataPath $BUILD_DIR/DerivedData \
    clean build \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGN_IDENTITY="" \
    | xcpretty

# 检查构建结果
if [ ${PIPESTATUS[0]} -eq 0 ]; then
    echo "✅ 构建成功!"
    
    # 如果是Release模式，创建归档
    if [ "$CONFIGURATION" = "release" ]; then
        echo "📦 创建应用归档..."
        xcodebuild -scheme $SCHEME \
            -configuration Release \
            -sdk iphoneos \
            -archivePath $BUILD_DIR/$PROJECT_NAME.xcarchive \
            archive \
            CODE_SIGNING_REQUIRED=NO \
            CODE_SIGN_IDENTITY="" \
            | xcpretty
            
        if [ ${PIPESTATUS[0]} -eq 0 ]; then
            echo "✅ 归档创建成功: $BUILD_DIR/$PROJECT_NAME.xcarchive"
        else
            echo "❌ 归档创建失败"
            exit 1
        fi
    fi
else
    echo "❌ 构建失败"
    exit 1
fi

echo "🎉 构建完成!"