import ProjectDescription

let targets: [Target] = [
    Target(
        name: "HaebitLogger",
        platform: .iOS,
        product: .framework,
        bundleId: "com.seunghun.haebitlogger",
        deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone]),
        sources: ["HaebitLogger/Sources/**"],
        dependencies: []
    ),
    Target(
        name: "HaebitLoggerTests",
        platform: .iOS,
        product: .unitTests,
        bundleId: "com.seunghun.haebitlogger.tests",
        sources: ["HaebitLoggerTests/Sources/**"],
        dependencies: [
            .target(name: "HaebitLogger")
        ],
        settings: .settings(
            base: ["DEVELOPMENT_TEAM": "5HZQ3M82FA"],
            configurations: [],
            defaultSettings: .recommended
        )
    ),
    Target(
        name: "HaebitLoggerDemo",
        platform: .iOS,
        product: .app,
        bundleId: "com.seunghun.haebitlogger.demo",
        deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone]),
        infoPlist: .extendingDefault(with: ["UILaunchStoryboardName": "LaunchScreen"]),
        sources: ["HaebitLoggerDemo/Sources/**"],
        resources: ["HaebitLoggerDemo/Resources/**"],
        dependencies: [
            .target(name: "HaebitLogger")
        ],
        settings: .settings(
            base: ["DEVELOPMENT_TEAM": "5HZQ3M82FA"],
            configurations: [],
            defaultSettings: .recommended
        )
    )
]

let project = Project(
    name: "HaebitLogger",
    organizationName: "seunghun",
    targets: targets
)
