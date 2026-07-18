import SwiftUI
import Combine

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var licenseKey: String = ""
    @Published var isLoading: Bool = false
    @Published var isAuthenticated: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var showSuccess: Bool = false
    @Published var user: UserModel?
    @Published var keyFieldFocused: Bool = false

    private let authService = AuthService.shared
    private var cancellables = Set<AnyCancellable>()

    var isKeyValid: Bool {
        !licenseKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func login() {
        guard !isLoading else { return }
        guard isKeyValid else {
            errorMessage = "Please enter a license key."
            showError = true
            return
        }

        isLoading = true
        HapticManager.shared.buttonPress()

        authService.authenticate(licenseKey: licenseKey)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                    self?.showError = true
                    HapticManager.shared.loginFailure()
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.3)) {
                        self?.showSuccess = false
                    }
                }
            } receiveValue: { [weak self] user in
                self?.user = user
                self?.isLoading = false
                self?.showSuccess = true
                HapticManager.shared.loginSuccess()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                        self?.isAuthenticated = true
                    }
                }
            }
            .store(in: &cancellables)
    }

    func logout() {
        withAnimation(.easeInOut(duration: 0.5)) {
            isAuthenticated = false
            user = nil
            licenseKey = ""
            showSuccess = false
        }
    }
}
