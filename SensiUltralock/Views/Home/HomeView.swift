import SwiftUI

struct HomeView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @State private var selectedTab = 0
    @State private var fps: Int = 60
    @State private var serverOnline = true

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            VStack(spacing: 0) {
                TopBar(
                    title: "SENSI ULTRALOCK",
                    tier: authViewModel.user?.tier ?? .basic,
                    fps: fps,
                    serverStatus: serverOnline
                )

                TabView(selection: $selectedTab) {
                    OptimizerView(tier: authViewModel.user?.tier ?? .basic)
                        .tag(0)

                    SystemInfoView()
                        .tag(1)

                    MemberView(
                        user: authViewModel.user ?? .placeholder,
                        onLogout: {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                authViewModel.logout()
                            }
                        }
                    )
                    .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }

            VStack {
                Spacer()
                customTabBar
            }
            .ignoresSafeArea(.keyboard)
        }
        .preferredColorScheme(.dark)
        .onAppear {
            startFPSMonitor()
        }
    }

    private var customTabBar: some View {
        HStack(spacing: 0) {
            tabButton(index: 0, icon: "slider.horizontal.3", label: "Optimizer")
            tabButton(index: 1, icon: "desktopcomputer", label: "System")
            tabButton(index: 2, icon: "person.crop.circle", label: "Member")
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            ZStack {
                AppColors.tabBarBg
                AppColors.glass
            }
        )
        .overlay(
            Rectangle()
                .fill(AppColors.borderDim)
                .frame(height: 1),
            alignment: .top
        )
    }

    private func tabButton(index: Int, icon: String, label: String) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                selectedTab = index
            }
            HapticManager.shared.selection()
        }) {
            VStack(spacing: 4) {
                ZStack {
                    if selectedTab == index {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppColors.primaryRed.opacity(0.15))
                            .frame(width: 44, height: 36)
                    }

                    Image(systemName: icon)
                        .font(.system(size: 20, weight: selectedTab == index ? .bold : .regular))
                        .foregroundColor(selectedTab == index ? AppColors.glowRed : AppColors.textSecondary)
                        .scaleEffect(selectedTab == index ? 1.1 : 1)
                }

                Text(label)
                    .font(.system(size: 10, weight: selectedTab == index ? .bold : .medium))
                    .foregroundColor(selectedTab == index ? AppColors.glowRed : AppColors.textSecondary)
            }
            .frame(maxWidth: .infinity)
        }
    }

    private func startFPSMonitor() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            fps = Int.random(in: 58...62)
            serverOnline = Bool.random()
        }
    }
}
