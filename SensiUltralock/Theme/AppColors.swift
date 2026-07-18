import SwiftUI

enum AppColors {
    static let background = Color(hex: "#090909")
    static let card = Color(hex: "#121212")
    static let cardSecondary = Color(hex: "#1B1B1B")
    static let primaryRed = Color(hex: "#D50000")
    static let secondaryRed = Color(hex: "#FF3030")
    static let glowRed = Color(hex: "#FF3B30")
    static let textPrimary = Color.white
    static let textSecondary = Color(hex: "#A9A9A9")
    static let border = Color(hex: "#8B0000")
    static let borderDim = Color(hex: "#4A0000")
    static let glass = Color.white.opacity(0.05)
    static let glassLight = Color.white.opacity(0.08)
    static let glassBorder = Color.white.opacity(0.1)
    static let shadow = Color.black.opacity(0.5)
    static let glow = Color.red.opacity(0.3)
    static let glowIntense = Color.red.opacity(0.6)
    static let gradientRed = LinearGradient(
        colors: [primaryRed, secondaryRed],
        startPoint: .leading,
        endPoint: .trailing
    )
    static let gradientDark = LinearGradient(
        colors: [Color(hex: "#0A0A0A"), Color(hex: "#1A0000")],
        startPoint: .top,
        endPoint: .bottom
    )
    static let gradientGlow = LinearGradient(
        colors: [primaryRed.opacity(0), glowRed, primaryRed.opacity(0)],
        startPoint: .leading,
        endPoint: .trailing
    )
    static let tabBarBg = Color(hex: "#0D0D0D").opacity(0.95)
    static let success = Color(hex: "#00C853")
    static let warning = Color(hex: "#FFD600")
    static let premium = Color(hex: "#FFD700")
    static let pro = Color(hex: "#00BFFF")
    static let basic = Color(hex: "#A9A9A9")
    static let vip = Color(hex: "#9B30FF")
    static let tierBasic = basic
    static let tierPro = LinearGradient(
        colors: [Color(hex: "#00BFFF"), Color(hex: "#1E90FF")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    static let tierVIP = LinearGradient(
        colors: [Color(hex: "#FFD700"), Color(hex: "#FFA500")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    static let statusOnline = Color(hex: "#00E676")
    static let statusOffline = Color(hex: "#FF5252")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = ((int >> 24) & 0xFF, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
