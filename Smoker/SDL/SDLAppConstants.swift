//
//  SDLAppConstants.swift
//  Smoker
//
//  Created by Nicole on 12/7/20.
//

import Foundation
import SmartDeviceLink

struct SDLAppConstants {
    static let connectionType = SDLConnectionType.TCP
    static let appType: SDLAppHMIType = .information
    static let additionalAppTypes: [SDLAppHMIType] = []
    static let appName = "Smoker"
    static let shortAppName = "S"
    static let fullAppId = "Smoker123456789"
    static let iPAddress = "10.211.55.4" // "10.211.55.4"  // "m.sdl.tools"
    static let port: UInt16 = 12345
    static let appLogoName = "AppIcon60x60"
    static let appLogo = UIImage(named: SDLAppConstants.appLogoName)!
    static let sdlLogLevel: SDLLogLevel = .verbose
    static let language: SDLLanguage = .enUs
    static let supportedLanguages: [SDLLanguage] = [.enUs]
}
