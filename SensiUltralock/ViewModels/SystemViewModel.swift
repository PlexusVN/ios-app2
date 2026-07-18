import SwiftUI
import Combine

@MainActor
final class SystemViewModel: ObservableObject {
    @Published var systemInfo: SystemInfoModel
    @Published var batteryLevel: Float = 0

    private let systemService = SystemService.shared
    private var cancellables = Set<AnyCancellable>()

    init() {
        systemInfo = systemService.fetchSystemInfo()
        batteryLevel = systemInfo.batteryLevel
        systemService.startBatteryMonitoring()
        setupBatteryMonitoring()
    }

    deinit {
        systemService.stopBatteryMonitoring()
    }

    private func setupBatteryMonitoring() {
        systemService.batteryLevelPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] level in
                self?.batteryLevel = level
                self?.systemInfo.batteryLevel = level
            }
            .store(in: &cancellables)
    }

    func refresh() {
        systemInfo = systemService.fetchSystemInfo()
    }
}
