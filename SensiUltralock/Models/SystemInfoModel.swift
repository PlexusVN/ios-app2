import Foundation
import UIKit

struct SystemInfoModel {
    var deviceName: String
    var deviceModel: String
    var systemVersion: String
    var cpuName: String
    var cpuCores: Int
    var ramTotal: String
    var ramUsed: String
    var storageTotal: String
    var storageUsed: String
    var batteryLevel: Float
    var batteryHealth: String
    var isCharging: Bool
    var refreshRate: Int
    var screenResolution: String
    var brightness: CGFloat
    var language: String
    var region: String
    var networkType: String
    var wifiName: String
    var ipAddress: String
    var uuid: String
    var appVersion: String
    var buildNumber: String

    static var current: SystemInfoModel {
        let device = UIDevice.current
        let screen = UIScreen.main
        let fileManager = FileManager.default
        let app = Bundle.main

        let totalDisk: Int64 = {
            if let attrs = try? fileManager.attributesOfFileSystem(forPath: NSHomeDirectory()) {
                return (attrs[.systemSize] as? NSNumber)?.int64Value ?? 0
            }
            return 0
        }()

        let freeDisk: Int64 = {
            if let attrs = try? fileManager.attributesOfFileSystem(forPath: NSHomeDirectory()) {
                return (attrs[.systemFreeSize] as? NSNumber)?.int64Value ?? 0
            }
            return 0
        }()

        let usedDisk = totalDisk - freeDisk
        let totalRAM = ProcessInfo.processInfo.physicalMemory

        return SystemInfoModel(
            deviceName: device.name,
            deviceModel: Self.modelName,
            systemVersion: "\(device.systemName) \(device.systemVersion)",
            cpuName: Self.cpuName,
            cpuCores: ProcessInfo.processInfo.processorCount,
            ramTotal: ByteCountFormatter.string(fromByteCount: Int64(totalRAM), countStyle: .binary),
            ramUsed: "—",
            storageTotal: ByteCountFormatter.string(fromByteCount: totalDisk, countStyle: .binary),
            storageUsed: ByteCountFormatter.string(fromByteCount: usedDisk, countStyle: .binary),
            batteryLevel: device.batteryLevel >= 0 ? device.batteryLevel : 0,
            batteryHealth: "Good",
            isCharging: device.batteryState == .charging || device.batteryState == .full,
            refreshRate: Int(screen.maximumFramesPerSecond),
            screenResolution: "\(Int(screen.bounds.width * screen.scale)) × \(Int(screen.bounds.height * screen.scale))",
            brightness: screen.brightness,
            language: Locale.current.language.languageCode?.identifier ?? "Unknown",
            region: Locale.current.region?.identifier ?? "Unknown",
            networkType: "WiFi",
            wifiName: "—",
            ipAddress: "—",
            uuid: device.identifierForVendor?.uuidString ?? "—",
            appVersion: app.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0",
            buildNumber: app.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        )
    }

    private static var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let mirror = Mirror(reflecting: systemInfo.machine)
        let identifier = mirror.children.compactMap { child -> String? in
            guard let value = child.value as? Int8, value != 0 else { return nil }
            return String(UnicodeScalar(UInt8(value)))
        }.joined()

        let modelMap: [String: String] = [
            "iPhone14,2": "iPhone 13 Pro", "iPhone14,3": "iPhone 13 Pro Max",
            "iPhone14,4": "iPhone 13 mini", "iPhone14,5": "iPhone 13",
            "iPhone14,6": "iPhone SE (3rd gen)",
            "iPhone14,7": "iPhone 14", "iPhone14,8": "iPhone 14 Plus",
            "iPhone15,2": "iPhone 14 Pro", "iPhone15,3": "iPhone 14 Pro Max",
            "iPhone15,4": "iPhone 15", "iPhone15,5": "iPhone 15 Plus",
            "iPhone16,1": "iPhone 15 Pro", "iPhone16,2": "iPhone 15 Pro Max",
            "iPhone17,1": "iPhone 16 Pro", "iPhone17,2": "iPhone 16 Pro Max",
            "iPhone17,3": "iPhone 16", "iPhone17,4": "iPhone 16 Plus",
            "iPhone12,1": "iPhone 11", "iPhone12,3": "iPhone 11 Pro",
            "iPhone12,5": "iPhone 11 Pro Max", "iPhone12,8": "iPhone SE (2nd gen)",
            "iPhone13,1": "iPhone 12 mini", "iPhone13,2": "iPhone 12",
            "iPhone13,3": "iPhone 12 Pro", "iPhone13,4": "iPhone 12 Pro Max"
        ]

        return modelMap[identifier] ?? identifier
    }

    private static var cpuName: String {
        let device = UIDevice.current
        if device.userInterfaceIdiom == .phone {
            let model = modelName
            if model.contains("Pro Max") || model.contains("Pro") {
                return "Apple Axx Pro"
            }
            return "Apple Axx"
        }
        return "Apple Silicon"
    }
}
