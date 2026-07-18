import Foundation

struct UserModel: Codable {
    var id: String
    var username: String
    var licenseKey: String
    var tier: Tier
    var accountType: String
    var expirationDate: Date
    var hwid: String
    var isAuthenticated: Bool
    var lastLogin: Date
    var memberSince: Date
    var isVerified: Bool
    var isActive: Bool
    var isPremium: Bool

    static let placeholder = UserModel(
        id: "USR-001",
        username: "Gamer",
        licenseKey: "XXXX-XXXX-XXXX-XXXX",
        tier: .basic,
        accountType: "Standard",
        expirationDate: Date().addingTimeInterval(86400 * 30),
        hwid: "HWID-XXXXXXXX-XXXX-XXXX",
        isAuthenticated: true,
        lastLogin: Date(),
        memberSince: Date(),
        isVerified: true,
        isActive: true,
        isPremium: false
    )
}

enum Tier: String, Codable, CaseIterable {
    case basic = "Basic"
    case pro = "Pro"
    case vip = "VIP"

    var label: String { rawValue }

    var color: String {
        switch self {
        case .basic: return "#A9A9A9"
        case .pro: return "#00BFFF"
        case .vip: return "#FFD700"
        }
    }

    var icon: String {
        switch self {
        case .basic: return "shield"
        case .pro: return "bolt.shield"
        case .vip: return "crown"
        }
    }
}
