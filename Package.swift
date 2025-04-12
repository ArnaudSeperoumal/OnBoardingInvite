// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "OnBoardingInvite",
    platforms: [.iOS(.v18)],
    products: [
        .library(name: "OnBoardingInvite", targets: ["OnBoardingInvite"])
    ],
    targets: [
        .target(
            name: "OnBoardingInvite",
            path: "OnBoardingInvite/Sources/OnBoardingInvite"
        ),
        .testTarget(
            name: "OnBoardingInviteTests",
            dependencies: ["OnBoardingInvite"],
            path: "OnBoardingInvite/Tests/OnBoardingInviteTests"
        )
    ]
)
