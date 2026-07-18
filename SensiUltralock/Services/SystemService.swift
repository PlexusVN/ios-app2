import Foundation
import UIKit
import Combine

final class SystemService {
    static let shared = SystemService()

    private init() {}

    func fetchSystemInfo() -> SystemInfoModel {
        SystemInfoModel.current
    }

    func startBatteryMonitoring() {
        UIDevice.current.isBatteryMonitoringEnabled = true
    }

    func stopBatteryMonitoring() {
        UIDevice.current.isBatteryMonitoringEnabled = false
    }

    func batteryLevelPublisher() -> AnyPublisher<Float, Never> {
        Timer.publish(every: 2, on: .main, in: .common)
            .autoconnect()
            .map { _ in UIDevice.current.batteryLevel }
            .eraseToAnyPublisher()
    }
}
