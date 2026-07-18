import Foundation

struct FeatureModel: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
    let tier: FeatureTier
    var isEnabled: Bool = false
    var isLocked: Bool = false
}

enum FeatureTier: String, Codable {
    case basic = "Basic"
    case pro = "Pro"
    case vip = "VIP"

    var label: String { rawValue }

    var icon: String {
        switch self {
        case .basic: return "shield"
        case .pro: return "bolt"
        case .vip: return "crown"
        }
    }
}

struct OptimizerSection: Identifiable {
    let id = UUID()
    let title: String
    let tier: FeatureTier
    let features: [FeatureModel]
    var isLocked: Bool = false
}

extension FeatureModel {
    static let basicFeatures: [FeatureModel] = [
        FeatureModel(title: "Sensitivity Booster", subtitle: "Enhanced aiming sensitivity", icon: "target", tier: .basic, isLocked: false),
        FeatureModel(title: "Screen Booster", subtitle: "Optimize display performance", icon: "display", tier: .basic, isLocked: false),
        FeatureModel(title: "120Hz Screen", subtitle: "Enable high refresh rate", icon: "speedometer", tier: .basic, isLocked: false),
        FeatureModel(title: "Feather Aim", subtitle: "Smooth crosshair movement", icon: "crosshair", tier: .basic, isLocked: false),
        FeatureModel(title: "Headshot Fix", subtitle: "Improved headshot accuracy", icon: "bullseye", tier: .basic, isLocked: false)
    ]

    static let proFeatures: [FeatureModel] = [
        FeatureModel(title: "AimLock Assist Pro", subtitle: "Advanced aim assistance", icon: "lock.shield", tier: .pro, isLocked: true),
        FeatureModel(title: "Auto Trigger Pro", subtitle: "Smart trigger activation", icon: "bolt.fill", tier: .pro, isLocked: true),
        FeatureModel(title: "Recoil Control Pro", subtitle: "Weapon recoil management", icon: "arrow.up.arrow.down", tier: .pro, isLocked: true),
        FeatureModel(title: "Crosshair Overlay", subtitle: "Custom crosshair display", icon: "plus.viewfinder", tier: .pro, isLocked: true)
    ]

    static let vipFeatures: [FeatureModel] = [
        FeatureModel(title: "AimLock Ultra", subtitle: "Ultimate aim technology", icon: "target", tier: .vip, isLocked: true),
        FeatureModel(title: "Anchor Aim", subtitle: "Precision locking system", icon: "anchor", tier: .vip, isLocked: true),
        FeatureModel(title: "Crosshair Premium", subtitle: "Premium crosshair pack", icon: "circle.grid.cross", tier: .vip, isLocked: true)
    ]
}

struct AdvancedTuner {
    var touchSensitivity: Double = 0.5
    var recoilCompensation: Double = 0.3
    var touchResponse: TouchResponse = .ms2
}

enum TouchResponse: String, CaseIterable {
    case ms1 = "1ms"
    case ms2 = "2ms"
    case ms4 = "4ms"
    case ms8 = "8ms"

    var value: Int {
        switch self {
        case .ms1: return 1
        case .ms2: return 2
        case .ms4: return 4
        case .ms8: return 8
        }
    }
}
