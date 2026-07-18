import SwiftUI

struct SystemInfoView: View {
    @StateObject private var viewModel = SystemViewModel()

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                headerSection

                LazyVGrid(columns: columns, spacing: 12) {
                    SystemCard(title: "Device Name", value: viewModel.systemInfo.deviceName, icon: "iphone", color: AppColors.glowRed)
                    SystemCard(title: "Model", value: viewModel.systemInfo.deviceModel, icon: "chip", color: AppColors.pro)
                    SystemCard(title: "System", value: viewModel.systemInfo.systemVersion, icon: "gearshape.2", color: AppColors.glowRed)
                    SystemCard(title: "CPU", value: "\(viewModel.systemInfo.cpuCores) Cores", icon: "cpu", color: AppColors.pro)
                    SystemCard(title: "RAM", value: viewModel.systemInfo.ramTotal, icon: "memorychip", color: AppColors.glowRed)
                    SystemCard(title: "Storage", value: viewModel.systemInfo.storageUsed, icon: "externaldrive", color: AppColors.pro, progress: storageProgress)
                    batteryCard
                    SystemCard(title: "Storage Total", value: viewModel.systemInfo.storageTotal, icon: "externaldrive.badge.checkmark", color: AppColors.glowRed)
                    SystemCard(title: "Refresh Rate", value: "\(viewModel.systemInfo.refreshRate) Hz", icon: "display", color: AppColors.pro)
                    SystemCard(title: "Resolution", value: viewModel.systemInfo.screenResolution, icon: "rectangle.split.2x2", color: AppColors.glowRed)
                    SystemCard(title: "Brightness", value: "\(Int(viewModel.systemInfo.brightness * 100))%", icon: "sun.max", color: AppColors.pro, progress: brightnessProgress)
                    SystemCard(title: "Language", value: viewModel.systemInfo.language, icon: "globe", color: AppColors.glowRed)
                    SystemCard(title: "Region", value: viewModel.systemInfo.region, icon: "map", color: AppColors.pro)
                    SystemCard(title: "Network", value: viewModel.systemInfo.networkType, icon: "wifi", color: AppColors.glowRed)
                    SystemCard(title: "IP Address", value: viewModel.systemInfo.ipAddress, icon: "network", color: AppColors.pro)
                    SystemCard(title: "UUID", value: String(viewModel.systemInfo.uuid.prefix(16)) + "...", icon: "qrcode", color: AppColors.glowRed)
                    SystemCard(title: "App Version", value: viewModel.systemInfo.appVersion, icon: "apps.iphone", color: AppColors.pro)
                    SystemCard(title: "Build", value: viewModel.systemInfo.buildNumber, icon: "hammer", color: AppColors.glowRed)
                }

                Spacer().frame(height: 100)
            }
            .padding(.horizontal, AppTheme.padding)
            .padding(.top, 16)
        }
        .refreshable {
            viewModel.refresh()
        }
    }

    private var headerSection: some View {
        VStack(spacing: 6) {
            Text("SYSTEM DASHBOARD")
                .font(.system(size: 22, weight: .heavy))
                .foregroundColor(.white)
                .tracking(3)
                .shadow(color: AppColors.glowRed.opacity(0.3), radius: 8)

            Text("Real-time device information")
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }

    private var batteryCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "battery.100")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(batteryColor)
                    .frame(width: 38, height: 38)
                    .background(batteryColor.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(batteryColor.opacity(0.2), lineWidth: 1)
                    )

                Spacer()

                if viewModel.systemInfo.isCharging {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(AppColors.success)
                }
            }

            Text("Battery")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(AppColors.textSecondary)

            Text("\(Int(viewModel.batteryLevel * 100))%")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)

            HStack {
                Text(viewModel.systemInfo.batteryHealth)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(AppColors.success)
                Spacer()
                if viewModel.systemInfo.isCharging {
                    Text("Charging")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(AppColors.success)
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(AppColors.cardSecondary)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(AppColors.borderDim, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private var storageProgress: Float {
        0.45
    }

    private var brightnessProgress: Float {
        Float(viewModel.systemInfo.brightness)
    }

    private var batteryColor: Color {
        let level = viewModel.batteryLevel
        if level > 0.6 { return AppColors.success }
        if level > 0.2 { return AppColors.warning }
        return AppColors.statusOffline
    }
}
