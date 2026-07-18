import SwiftUI

struct GlassCard<Content: View>: View {
    var radius: CGFloat = AppTheme.cornerRadius
    var color: Color = AppColors.card
    var glowColor: Color?
    @ViewBuilder let content: Content

    @State private var animateGlow = false

    var body: some View {
        content
            .padding(AppTheme.padding)
            .frame(maxWidth: .infinity)
            .background(color)
            .overlay(
                RoundedRectangle(cornerRadius: radius)
                    .stroke(AppColors.glassBorder, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: radius))
            .shadow(color: AppColors.shadow, radius: AppTheme.shadowRadius, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: radius)
                    .stroke(
                        glowColor?.opacity(animateGlow ? 0.6 : 0) ?? Color.clear,
                        lineWidth: 1.5
                    )
                    .shadow(
                        color: (glowColor ?? AppColors.glowRed).opacity(animateGlow ? 0.5 : 0),
                        radius: AppTheme.glowRadius,
                        x: 0, y: 0
                    )
            )
            .onAppear {
                withAnimation(AppAnimations.glowPulse) {
                    animateGlow = true
                }
            }
    }
}

struct GlassCardModifier: ViewModifier {
    var radius: CGFloat = AppTheme.cornerRadius

    func body(content: Content) -> some View {
        content
            .padding(AppTheme.padding)
            .frame(maxWidth: .infinity)
            .background(AppColors.card)
            .overlay(
                RoundedRectangle(cornerRadius: radius)
                    .stroke(AppColors.glassBorder, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: radius))
            .shadow(color: AppColors.shadow, radius: AppTheme.shadowRadius, x: 0, y: 4)
    }
}
