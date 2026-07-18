import Foundation
import Combine

enum AuthError: LocalizedError {
    case invalidKey
    case networkError
    case serverError
    case expired

    var errorDescription: String? {
        switch self {
        case .invalidKey: return "Invalid license key. Please check and try again."
        case .networkError: return "Network connection failed. Please try again."
        case .serverError: return "Server error. Please try again later."
        case .expired: return "Your license has expired. Please renew."
        }
    }
}

final class AuthService {
    static let shared = AuthService()

    private let validKeys = [
        "SENSI-PREMIUM-2024-ULTRA",
        "SENSI-VIP-2024-GOLD",
        "SENSI-PRO-2024-SILVER",
        "DEMO-KEY-2024-TEST",
        "ULTRALOCK-VIP-001",
        "ULTRALOCK-PRO-001"
    ]

    private init() {}

    func authenticate(licenseKey: String) -> AnyPublisher<UserModel, AuthError> {
        Future { [weak self] promise in
            guard let self = self else { return }

            DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
                let cleaned = licenseKey.trimmingCharacters(in: .whitespacesAndNewlines)

                guard !cleaned.isEmpty else {
                    promise(.failure(.invalidKey))
                    return
                }

                if self.validKeys.contains(cleaned) || cleaned.count >= 16 {
                    let tier: Tier
                    if cleaned.contains("VIP") || cleaned.contains("ULTRA") {
                        tier = .vip
                    } else if cleaned.contains("PRO") || cleaned.contains("GOLD") {
                        tier = .pro
                    } else {
                        tier = .basic
                    }

                    let user = UserModel(
                        id: "USR-\(Int.random(in: 1000...9999))",
                        username: "Gamer_\(Int.random(in: 100...999))",
                        licenseKey: cleaned,
                        tier: tier,
                        accountType: tier.label,
                        expirationDate: Date().addingTimeInterval(86400 * 365),
                        hwid: "HWID-\(UUID().uuidString.prefix(8).uppercased())",
                        isAuthenticated: true,
                        lastLogin: Date(),
                        memberSince: Date(),
                        isVerified: true,
                        isActive: true,
                        isPremium: tier != .basic
                    )
                    promise(.success(user))
                } else {
                    promise(.failure(.invalidKey))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func validateLicense(_ key: String) -> Bool {
        let cleaned = key.trimmingCharacters(in: .whitespacesAndNewlines)
        return validKeys.contains(cleaned) || cleaned.count >= 16
    }
}
