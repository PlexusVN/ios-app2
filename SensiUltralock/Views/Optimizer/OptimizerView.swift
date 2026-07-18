import SwiftUI

struct OptimizerView: View {
    let tier: Tier
    @StateObject private var viewModel = OptimizerViewModel()
    @State private var showVIPPopup = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                headerSection

                ForEach(viewModel.sections) { section in
                    sectionView(section)
                }

                advancedTunerSection

                if viewModel.showVipUnlock {
                    unlockVIPCard
                }

                Spacer().frame(height: 100)
            }
            .padding(.horizontal, AppTheme.padding)
            .padding(.top, 16)
        }
        .onAppear {
            viewModel.setup(for: tier)
        }
        .alertPopup(
            isPresented: $showVIPPopup,
            title: "VIP Only",
            message: "Upgrade to VIP tier to unlock this feature.",
            buttonText: "Upgrade",
            buttonColor: AppColors.vip
        )
    }

    private var headerSection: some View {
        VStack(spacing: 6) {
            Text("GAME OPTIMIZER")
                .font(.system(size: 22, weight: .heavy))
                .foregroundColor(.white)
                .tracking(3)
                .shadow(color: AppColors.glowRed.opacity(0.3), radius: 8)

            Text("Enhance your gaming experience")
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }

    private func sectionView(_ section: OptimizerSection) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: section.tier.icon)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(tierColor(section.tier))

                Text(section.title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                    .tracking(2)

                Spacer()

                if section.isLocked {
                    PremiumBadge(text: "LOCKED", color: AppColors.textSecondary, icon: "lock.fill")
                } else {
                    PremiumBadge(text: "ACTIVE", color: AppColors.success, icon: "checkmark")
                }
            }

            if section.isLocked {
                lockedOverlay
            }

            LazyVStack(spacing: 8) {
                ForEach(section.features) { feature in
                    FeatureCard(feature: feature) { feat in
                        if feat.isLocked {
                            HapticManager.shared.warning()
                            if section.tier == .vip {
                                showVIPPopup = true
                            }
                        } else {
                            viewModel.toggleFeature(feat)
                        }
                    }
                }
            }
            .disabled(section.isLocked)
        }
        .padding(16)
        .background(AppColors.card)
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                .stroke(AppColors.borderDim, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
    }

    private var lockedOverlay: some View {
        VStack(spacing: 8) {
            Image(systemName: "lock.shield")
                .font(.system(size: 32, weight: .semibold))
                .foregroundColor(AppColors.textSecondary)
            Text("Upgrade to unlock")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(AppColors.cardSecondary.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private var advancedTunerSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 10) {
                Image(systemName: "slider.vertical.3")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(AppColors.vip)

                Text("ADVANCED TUNER HUD")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                    .tracking(2)

                Spacer()

                PremiumBadge(text: "VIP", color: AppColors.vip, icon: "crown.fill")
            }

            VStack(spacing: 16) {
                VStack(spacing: 6) {
                    HStack {
                        Text("Touch Sensitivity")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(AppColors.textSecondary)
                        Spacer()
                        Text("\(Int(viewModel.advancedTuner.touchSensitivity * 100))%")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white)
                    }

                    Slider(value: $viewModel.advancedTuner.touchSensitivity, in: 0...1)
                        .accentColor(viewModel.tunerLocked ? AppColors.textSecondary : AppColors.glowRed)
                        .disabled(viewModel.tunerLocked)
                }

                VStack(spacing: 6) {
                    HStack {
                        Text("Recoil Compensation")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(AppColors.textSecondary)
                        Spacer()
                        Text("\(Int(viewModel.advancedTuner.recoilCompensation * 100))%")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white)
                    }

                    Slider(value: $viewModel.advancedTuner.recoilCompensation, in: 0...1)
                        .accentColor(viewModel.tunerLocked ? AppColors.textSecondary : AppColors.glowRed)
                        .disabled(viewModel.tunerLocked)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Touch Response")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(AppColors.textSecondary)

                    HStack(spacing: 8) {
                        ForEach(TouchResponse.allCases, id: \.self) { response in
                            Button(action: {
                                guard !viewModel.tunerLocked else { return }
                                viewModel.selectedResponse = response
                                HapticManager.shared.selection()
                            }) {
                                Text(response.rawValue)
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(
                                        viewModel.selectedResponse == response ? .white : AppColors.textSecondary
                                    )
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 36)
                                    .background(
                                        viewModel.selectedResponse == response
                                            ? AppColors.primaryRed
                                            : AppColors.card
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(
                                                viewModel.selectedResponse == response
                                                    ? AppColors.glowRed.opacity(0.5)
                                                    : AppColors.borderDim,
                                                lineWidth: 1
                                            )
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .disabled(viewModel.tunerLocked)
                        }
                    }
                }
            }
            .opacity(viewModel.tunerLocked ? 0.5 : 1)
            .disabled(viewModel.tunerLocked)
        }
        .padding(16)
        .background(AppColors.card)
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                .stroke(AppColors.borderDim, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
    }

    private var unlockVIPCard: some View {
        VStack(spacing: 14) {
            Image(systemName: "crown.fill")
                .font(.system(size: 36))
                .foregroundColor(AppColors.vip)

            Text("Unlock VIP Features")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)

            Text("Get access to all premium features including Advanced Tuner HUD, AimLock Ultra, and more.")
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)

            PrimaryButton(
                title: "UPGRADE NOW",
                icon: "crown",
                gradient: LinearGradient(
                    colors: [AppColors.vip, Color(hex: "#FFD700")],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            ) {
                HapticManager.shared.heavy()
            }
        }
        .padding(24)
        .background(AppColors.card)
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                .stroke(AppColors.vip.opacity(0.3), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
        .shadow(color: AppColors.vip.opacity(0.15), radius: 20)
    }

    private func tierColor(_ tier: FeatureTier) -> Color {
        switch tier {
        case .basic: return AppColors.tierBasic
        case .pro: return AppColors.pro
        case .vip: return AppColors.vip
        }
    }
}
