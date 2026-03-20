// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "HotelBookingDemo",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "HotelBookingDemo",
            targets: ["HotelBookingDemo"]
        )
    ],
    dependencies: [
        // 添加必要的第三方依赖
    ],
    targets: [
        .target(
            name: "HotelBookingDemo",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "HotelBookingDemoTests",
            dependencies: ["HotelBookingDemo"],
            path: "Tests"
        )
    ]
)