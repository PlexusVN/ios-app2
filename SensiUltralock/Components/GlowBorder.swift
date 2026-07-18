import SwiftUI

struct GlowBorder: ViewModifier {
    let color: Color
    let radius: CGFloat
    let lineWidth: CGFloat
    @State private var animating = false

    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: radius)
                    .stroke(color, lineWidth: lineWidth)
                    .shadow(color: color.opacity(animating ? 0.8 : 0.2), radius: AppTheme.glowRadius, x: 0, y: 0)
                    .shadow(color: color.opacity(animating ? 0.4 : 0.1), radius: AppTheme.glowRadiusIntense, x: 0, y: 0)
            )
            .onAppear {
                withAnimation(AppAnimations.glowPulse) {
                    animating = true
                }
            }
    }
}

extension View {
    func glowBorder(color: Color = AppColors.glowRed, radius: CGFloat = AppTheme.cornerRadius, lineWidth: CGFloat = 1) -> some View {
        modifier(GlowBorder(color: color, radius: radius, lineWidth: lineWidth))
    }
}
