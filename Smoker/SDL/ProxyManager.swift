//
//  ProxyManager.swift
//  Smoker
//
//  Created by Nicole on 12/7/20.
//

import Foundation
import SwiftUI
import SmartDeviceLink
import SmartDeviceLinkSwift

enum SDLConnectionType {
    case TCP
    case iAP
}

class ProxyManager: NSObject {
    public private(set) var sdlManager: SDLManager!
    private var sdlManagerStarted: Bool = false
    var hmiStateChangedHandler: ((_ oldLevel: SDLHMILevel, _ newLevel: SDLHMILevel) -> Void)?

    static let shared = ProxyManager()
    private override init() {
        super.init()
    }

    func start(with connectionType: SDLConnectionType, successHandler: @escaping ((_ success: Bool) -> Void)) {
        sdlManager = SDLManager(configuration: connectionType == .iAP ? ProxyManager.connectIAP() : ProxyManager.connectTCP(), delegate: self)

        sdlManager.start { [unowned self] (success, error) in
            if success {
                let vehicleType = self.sdlManager.registerResponse?.vehicleType
                SDLLog.d("Successfully connected to a SDL accessory ✌️. Vehicle: \(vehicleType?.make ?? "unknown make") \(vehicleType?.model ?? "unknown model") \(vehicleType?.modelYear ?? "unknown year")")
            } else {
                SDLLog.d("Could not connect with a SDL accessory 👎. Error: \(error != nil ? error!.localizedDescription : "No error returned")")
            }

            sdlManagerStarted = success
            return successHandler(success)
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

        return SDLConfiguration(lifecycle: lifecycleConfig, lockScreen: customizedLockScreenConfiguration(), logging: logConfiguration(), streamingMedia: nil, fileManager: fileManagerConfiguration(), encryption: .default())
    }

    class func logConfiguration() -> SDLLogConfiguration {
        let logConfig = SDLLogConfiguration.debug()
        let exampleLogFileModule = SDLLogFileModule(name: "SDL Example App", files: ["ProxyManager"])
        logConfig.modules.insert(exampleLogFileModule)
        logConfig.globalLogLevel = SDLAppConstants.sdlLogLevel
        return logConfig
    }

    class func customizedLockScreenConfiguration() -> SDLLockScreenConfiguration {
        let swiftUIController = UIHostingController(rootView: SDLLockscreenView())
        swiftUIController.modalPresentationStyle = .fullScreen
        return SDLLockScreenConfiguration.enabledConfiguration(with: swiftUIController)
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
        sdlManagerStarted = false
    }

    func hmiLevel(_ oldLevel: SDLHMILevel, didChangeToLevel newLevel: SDLHMILevel) {
        if (newLevel == .full) {
            guard let hmiStateChangedHandler = hmiStateChangedHandler else { return }
            hmiStateChangedHandler(oldLevel, newLevel)
        }
    }
}

// MARK: - Sending Requests

extension ProxyManager {
    static let defaultNoErrorString = "no error"
    static let defaultNoConnectionString = "no connection to module"

    func sendRequest(_ request: SDLRPCRequest, successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        guard let sdlManager = sdlManager, sdlManagerStarted == true else { return successHandler(.fail, ProxyManager.defaultNoConnectionString) }
        sdlManager.send(request: request) { (request: SDLRPCRequest?, response: SDLRPCResponse?, error: Error?) in
            var responseSuccess = response?.success.boolValue ?? false
            if let cancelInteractionResponse = response as? SDLCancelInteractionResponse, responseSuccess == false {
                if cancelInteractionResponse.resultCode == .ignored {
                    responseSuccess = true
                }
            }

            var responseError = ProxyManager.defaultNoErrorString
            if let error = error as NSError? {
                responseError = error.localizedDescription
            }

            successHandler(responseSuccess ? .success : .fail, responseError)
        }
    }

    func sendFile(_ file: SDLFile, successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        sendFiles([file], successHandler: successHandler)
    }

    func sendFiles(_ files: [SDLFile], successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        guard let sdlManager = sdlManager, sdlManagerStarted == true else {
            return successHandler(.fail, ProxyManager.defaultNoConnectionString)
        }

        var filesToUpload = files
        filesToUpload.removeAll { file -> Bool in
            !sdlManager.fileManager.hasUploadedFile(file)
        }

        if filesToUpload.count == 0 {
            return successHandler(.success, nil)
        }

        sdlManager.fileManager.upload(files: filesToUpload) { (error) in
            let returnedError = error as NSError?
            return successHandler(returnedError == nil ? .success : .fail, returnedError?.localizedDescription)
        }
    }
}

// MARK: - Permission Manager Requests

extension ProxyManager {
    enum permissionStatus: String {
        case allowed = "ALLOWED"
        case disallowed = "DISALLOWED"
        case mixed = "MIXED"
    }

    func checkPermissions(rpcName: SDLRPCFunctionName, successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        guard let sdlManager = sdlManager, sdlManagerStarted == true else {
            return successHandler(.fail, ProxyManager.defaultNoConnectionString)
        }

        let isAllowed = sdlManager.permissionManager.isRPCNameAllowed(rpcName)
        return successHandler(isAllowed ? .success : .fail, isAllowed ? permissionStatus.allowed.rawValue : permissionStatus.disallowed.rawValue)
    }

    func checkGroupPermissions(permissionElements: [SDLPermissionElement], successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        guard let sdlManager = sdlManager, sdlManagerStarted == true else {
            return successHandler(.fail, ProxyManager.defaultNoConnectionString)
        }

        let groupStatus = sdlManager.permissionManager.groupStatus(ofRPCPermissions: permissionElements)
        var returnMessage: permissionStatus
        switch groupStatus {
        case .allowed: returnMessage = .allowed
        case .disallowed: returnMessage = .disallowed
        case .mixed: returnMessage = .mixed
        default: returnMessage = .disallowed
        }
        return successHandler(groupStatus == SDLPermissionGroupStatus.allowed ? .success : .fail, returnMessage.rawValue)
    }

    func checkPermissionParameter(_ parameter: String, for rpcName: SDLRPCFunctionName, successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        guard let sdlManager = sdlManager, sdlManagerStarted == true else {
            return successHandler(.fail, ProxyManager.defaultNoConnectionString)
        }

        let isAllowed = sdlManager.permissionManager.isPermissionParameterAllowed(rpcName, parameter: parameter)
        return successHandler(isAllowed ? .success : .fail, isAllowed ? permissionStatus.allowed.rawValue : permissionStatus.disallowed.rawValue)
    }

    func subscribePermissions(permissionElements: [SDLPermissionElement], groupType: SDLPermissionGroupType, successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        guard let sdlManager = sdlManager, sdlManagerStarted == true else {
            return successHandler(.fail, ProxyManager.defaultNoConnectionString)
        }

        sdlManager.permissionManager.subscribe(toRPCPermissions: permissionElements, groupType: groupType) { (individualStatues, groupStatus) in
            let disallowedRPCs = permissionElements.filter {
                let isRPCAllowed = individualStatues[$0.rpcName]?.isRPCAllowed ?? false
                return !isRPCAllowed
            }

            return successHandler(groupStatus == SDLPermissionGroupStatus.allowed ? .success : .fail, disallowedRPCs.count == 0 ? permissionStatus.allowed.rawValue : "Disallowed RPCs: \(disallowedRPCs.map { $0.rpcName.rawValue.rawValue }))")
        }
    }
}
