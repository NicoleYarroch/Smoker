//
//  ProxyManager.swift
//  Smoker
//
//  Created by Nicole on 12/7/20.
//

import Foundation
import SmartDeviceLink
import SmartDeviceLinkSwift

enum SDLConnectionType {
    case TCP
    case iAP
}

class ProxyManager: NSObject {
    public private(set) var sdlManager: SDLManager!
    var hmiStateChangedHandler: ((_ oldLevel: SDLHMILevel, _ newLevel: SDLHMILevel) -> Void)?

    static let shared = ProxyManager()
    private override init() {
        super.init()
    }

    func start(with connectionType: SDLConnectionType, successHandler: @escaping ((_ success: Bool, _ manager: SDLManager) -> Void)) {
        sdlManager = SDLManager(configuration: connectionType == .iAP ? ProxyManager.connectIAP() : ProxyManager.connectTCP(), delegate: self)

        sdlManager.start { [unowned self] (success, error) in
            if success {
                let vehicleType = self.sdlManager.registerResponse?.vehicleType
                SDLLog.d("Successfully connected to a SDL accessory ✌️. Vehicle: \(vehicleType?.make ?? "unknown make") \(vehicleType?.model ?? "unknown model") \(vehicleType?.modelYear ?? "unknown year")")
                return successHandler(true, self.sdlManager)
            } else {
                SDLLog.d("Could not connect with a SDL accessory 👎. Error: \(error != nil ? error!.localizedDescription : "No error returned")")
                return successHandler(false, self.sdlManager)
            }
        }
    }
}

// MARK: - Setup

private extension ProxyManager {
    class func connectIAP() -> SDLConfiguration {
        let lifecycleConfiguration =
            SDLLifecycleConfiguration(appName: SDLAppConstants.appName, fullAppId: SDLAppConstants.fullAppId)
        return setupConfiguration(with: lifecycleConfiguration)
    }

    class func connectTCP() -> SDLConfiguration {
        let lifecycleConfiguration = SDLLifecycleConfiguration(appName: SDLAppConstants.appName, fullAppId: SDLAppConstants.fullAppId, ipAddress: SDLAppConstants.iPAddress, port: SDLAppConstants.port)
        return setupConfiguration(with: lifecycleConfiguration)
    }

    class func setupConfiguration(with lifecycleConfig: SDLLifecycleConfiguration) -> SDLConfiguration  {
        lifecycleConfig.shortAppName = SDLAppConstants.shortAppName
        lifecycleConfig.appIcon = SDLArtwork(image: SDLAppConstants.appLogo, name: SDLAppConstants.appLogoName, persistent: true, as: .JPG)
        lifecycleConfig.appType = SDLAppConstants.appType
        lifecycleConfig.additionalAppTypes = SDLAppConstants.additionalAppTypes
        lifecycleConfig.language = SDLAppConstants.language
        lifecycleConfig.languagesSupported = SDLAppConstants.supportedLanguages

        return SDLConfiguration(lifecycle: lifecycleConfig, lockScreen: .enabled(), logging: logConfiguration(), streamingMedia: nil, fileManager: fileManagerConfiguration(), encryption: .default())
    }

    class func logConfiguration() -> SDLLogConfiguration {
        let logConfig = SDLLogConfiguration.debug()
        let exampleLogFileModule = SDLLogFileModule(name: "SDL Example App", files: ["ProxyManager"])
        logConfig.modules.insert(exampleLogFileModule)
        logConfig.globalLogLevel = SDLAppConstants.sdlLogLevel
        return logConfig
    }

    class func customizedLockScreenConfiguration() -> SDLLockScreenConfiguration {
        return SDLLockScreenConfiguration.enabledConfiguration(withAppIcon: #imageLiteral(resourceName: "Smokey_Logo"), backgroundColor: UIColor.blue)
    }

    class func customLockScreenConfiguration() -> SDLLockScreenConfiguration {
        let customLockScreenViewController = UIViewController()
        customLockScreenViewController.view.backgroundColor = UIColor.blue
        customLockScreenViewController.view.frame = UIScreen.main.bounds
        return SDLLockScreenConfiguration.enabledConfiguration(with: customLockScreenViewController)
    }

    class func streamingMediaConfiguration() -> SDLStreamingMediaConfiguration {
        return SDLStreamingMediaConfiguration()
    }

    class func fileManagerConfiguration() -> SDLFileManagerConfiguration {
        return SDLFileManagerConfiguration(artworkRetryCount: 1, fileRetryCount: 1)
    }
}

// MARK: - SDLManagerDelegate

extension ProxyManager: SDLManagerDelegate {
    func managerDidDisconnect() {
        print("Disconnected from the SDL accessory")
    }

    func hmiLevel(_ oldLevel: SDLHMILevel, didChangeToLevel newLevel: SDLHMILevel) {
        if (newLevel == .full) {
            guard let hmiStateChangedHandler = hmiStateChangedHandler else { return }
            hmiStateChangedHandler(oldLevel, newLevel)
        }

        switch newLevel {
        case .full: break           // The SDL app is in the foreground
        case .limited: break        // The SDL app's menu is open
        case .background: break     // The SDL app is not in the foreground
        case .none: break           // The SDL app is not yet running
        default: break
        }
    }
}
