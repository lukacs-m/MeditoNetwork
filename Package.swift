// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MeditoNetwork",
    platforms: [
           .iOS(.v13),
           .macOS(.v10_15),
           .tvOS(.v13),
           .watchOS(.v6)
       ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "MeditoNetwork",
            targets: ["MeditoNetwork"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(name: "MeditoModels", url: "https://github.com/lukacs-m/MeditoModels", from: "0.1.4"),
        .package(name: "Networking", url: "https://github.com/lukacs-m/Networking", from: "0.3.3")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "MeditoNetwork",
            dependencies: ["MeditoModels", "Networking"]),
        .testTarget(
            name: "MeditoNetworkTests",
            dependencies: ["MeditoNetwork"]),
    ]
)
