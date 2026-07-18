import SwiftUI

struct AppTheme {
    static let cornerRadius: CGFloat = 16
    static let cornerRadiusSmall: CGFloat = 10
    static let cornerRadiusLarge: CGFloat = 24
    static let padding: CGFloat = 16
    static let paddingSmall: CGFloat = 10
    static let paddingLarge: CGFloat = 24
    static let spacing: CGFloat = 16
    static let spacingSmall: CGFloat = 8
    static let spacingLarge: CGFloat = 24
    static let blurRadius: CGFloat = 20
    static let blurRadiusLight: CGFloat = 10
    static let glowRadius: CGFloat = 20
    static let glowRadiusIntense: CGFloat = 40
    static let shadowRadius: CGFloat = 10
    static let iconSize: CGFloat = 44
    static let iconSizeSmall: CGFloat = 28
    static let iconSizeLarge: CGFloat = 60
    static let avatarSize: CGFloat = 100
    static let avatarSizeSmall: CGFloat = 60
    static let toggleSize: CGFloat = 52
    static let cardHeight: CGFloat = 80
    static let cardHeightLarge: CGFloat = 200
    static let tabBarHeight: CGFloat = 70
    static let topBarHeight: CGFloat = 60

    static let springAnimation = Animation.spring(response: 0.6, dampingFraction: 0.7)
    static let smoothAnimation = Animation.easeInOut(duration: 0.3)
    static let fastAnimation = Animation.easeOut(duration: 0.15)
    static let glowAnimation = Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)

    struct GlassModifier: ViewModifier {
        func body(content: Content) -> some View {
            content
                .background(.ultraThinMaterial)
                .background(AppColors.glass)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(AppColors.glassBorder, lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
    }

    struct CardStyle: ViewModifier {
        var color: Color = AppColors.card
        var radius: CGFloat = cornerRadius

        func body(content: Content) -> some View {
            content
                .background(color)
                .overlay(
                    RoundedRectangle(cornerRadius: radius)
                        .stroke(AppColors.borderDim, lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: radius))
                .shadow(color: AppColors.shadow, radius: shadowRadius, x: 0, y: 4)
        }
    }
}

extension View {
    func glassCard(radius: CGFloat = AppTheme.cornerRadius) -> some View {
        modifier(AppTheme.GlassModifier())
    }

    func appCard(color: Color = AppColors.card, radius: CGFloat = AppTheme.cornerRadius) -> some View {
        modifier(AppTheme.CardStyle(color: color, radius: radius))
    }

    func neonGlow(color: Color = AppColors.glowRed) -> some View {
        shadow(color: color.opacity(0.6), radius: AppTheme.glowRadius, x: 0, y: 0)
            .shadow(color: color.opacity(0.3), radius: AppTheme.glowRadiusIntense, x: 0, y: 0)
    }
}
