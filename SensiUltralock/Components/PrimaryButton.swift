import SwiftUI

struct PrimaryButton: View {
    let title: String
    var icon: String?
    var isLoading: Bool = false
    var isDisabled: Bool = false
    var gradient: LinearGradient = AppColors.gradientRed
    var height: CGFloat = 56
    var action: () -> Void

    @State private var isPressed = false
    @State private var scale: CGFloat = 1

    var body: some View {
        Button(action: {
            guard !isLoading && !isDisabled else { return }
            HapticManager.shared.buttonPress()
            withAnimation(.easeOut(duration: 0.1)) {
                isPressed = true
                scale = 0.96
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                    scale = 1
                }
                action()
            }
        }) {
            HStack(spacing: 10) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.2)
                } else if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                }

                Text(title)
                    .font(.system(size: 17, weight: .bold))
                    .tracking(1)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .background(
                ZStack {
                    gradient
                        .opacity(isDisabled ? 0.3 : 1)

                    if isPressed {
                        Color.white.opacity(0.1)
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shadow(color: AppColors.glowRed.opacity(isDisabled ? 0 : 0.4), radius: 15, x: 0, y: 0)
            .scaleEffect(scale)
        }
        .disabled(isLoading || isDisabled)
    }
}

struct SecondaryButton: View {
    let title: String
    var icon: String?
    var gradient: LinearGradient = LinearGradient(colors: [AppColors.cardSecondary, AppColors.cardSecondary], startPoint: .leading, endPoint: .trailing)
    var height: CGFloat = 50
    var action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: {
            HapticManager.shared.light()
            withAnimation(.easeOut(duration: 0.1)) { isPressed = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) { isPressed = false }
                action()
            }
        }) {
            HStack(spacing: 10) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                }
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .tracking(0.5)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .background(
                ZStack {
                    gradient
                    if isPressed {
                        Color.white.opacity(0.05)
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppColors.glassBorder, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .scaleEffect(isPressed ? 0.97 : 1)
    }
}
