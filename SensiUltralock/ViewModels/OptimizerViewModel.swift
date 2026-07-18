import SwiftUI
import Combine

@MainActor
final class OptimizerViewModel: ObservableObject {
    @Published var sections: [OptimizerSection] = []
    @Published var advancedTuner = AdvancedTuner()
    @Published var selectedResponse: TouchResponse = .ms2
    @Published var showVipUnlock: Bool = false
    @Published var activeFeatureId: UUID?

    private var currentTier: Tier = .basic

    func setup(for tier: Tier) {
        currentTier = tier
        sections = [
            OptimizerSection(
                title: "BASIC OPTIMIZER",
                tier: .basic,
                features: FeatureModel.basicFeatures.map { feature in
                    var f = feature
                    f.isLocked = false
                    return f
                },
                isLocked: false
            ),
            OptimizerSection(
                title: "PRO FEATURES",
                tier: .pro,
                features: FeatureModel.proFeatures,
                isLocked: tier != .pro && tier != .vip
            ),
            OptimizerSection(
                title: "VIP ELITE",
                tier: .vip,
                features: FeatureModel.vipFeatures,
                isLocked: tier != .vip
            )
        ]

        if tier != .vip {
            showVipUnlock = true
        }
    }

    func toggleFeature(_ feature: FeatureModel) {
        guard !feature.isLocked else {
            HapticManager.shared.warning()
            return
        }
        HapticManager.shared.toggle()
        activeFeatureId = feature.id

        if let sectionIndex = sections.firstIndex(where: { $0.features.contains(where: { $0.id == feature.id }) }),
           let featureIndex = sections[sectionIndex].features.firstIndex(where: { $0.id == feature.id }) {
            sections[sectionIndex].features[featureIndex].isEnabled.toggle()
        }
    }

    var tunerLocked: Bool {
        currentTier != .vip
    }
}
