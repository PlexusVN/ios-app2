import SwiftUI

@MainActor
final class MemberViewModel: ObservableObject {
    @Published var user: UserModel
    @Published var showCopiedToast: Bool = false
    @Published var copiedMessage: String = ""
    @Published var serverVersion: String = "2.4.1"
    @Published var connectionStatus: ConnectionStatus = .connected

    enum ConnectionStatus: String {
        case connected = "Connected"
        case disconnected = "Disconnected"
        case reconnecting = "Reconnecting"

        var color: Color {
            switch self {
            case .connected: return AppColors.success
            case .disconnected: return AppColors.statusOffline
            case .reconnecting: return AppColors.warning
            }
        }

        var icon: String {
            switch self {
            case .connected: return "checkmark.circle.fill"
            case .disconnected: return "xmark.circle.fill"
            case .reconnecting: return "arrow.triangle.2.circlepath"
            }
        }
    }

    init(user: UserModel) {
        self.user = user
    }

    func copyToClipboard(_ text: String, label: String) {
        UIPasteboard.general.string = text
        copiedMessage = "\(label) copied"
        showCopiedToast = true
        HapticManager.shared.success()
    }

    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: date)
    }
}
