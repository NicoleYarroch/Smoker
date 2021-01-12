//
//  SoftButtons.swift
//  Smoker
//
//  Created by Nicole on 1/4/21.
//

import Foundation
import SmartDeviceLink
import SmartDeviceLinkSwift

class SoftButtons {
    class var softButtonIconSize: SDLImageResolution {
        let buttonImageField: SDLImageField? = ProxyManager.shared.sdlManager.systemCapabilityManager.defaultMainWindowCapability?.imageFields?.first(where: { imageField -> Bool in
            imageField.name == .softButtonImage
        })
        return buttonImageField?.imageResolution ?? SDLImageResolution(width: 100, height: 100)
    }

    class func defaultOkButton() -> (artwork: SDLArtwork, button: SDLSoftButton) {
        let buttonName = "Ok"
        let buttonArtwork = Artworks.randomSolidColor(width: softButtonIconSize.resolutionWidth.intValue, height: softButtonIconSize.resolutionHeight.intValue)
        return (buttonArtwork, SDLSoftButton(type: .both, text: buttonName, image: SDLImage(name: buttonArtwork.name, isTemplate: false), highlighted: false, buttonId: 10, systemAction: .defaultAction) { (press, event) in
            SDLLog.d("\(buttonName) button selected")
        })
    }

    class func defaultCancelButton() -> (artwork: SDLArtwork, button: SDLSoftButton) {
        let buttonName = "Cancel"
        let buttonArtwork = Artworks.randomSolidColor(width: softButtonIconSize.resolutionWidth.intValue, height: softButtonIconSize.resolutionHeight.intValue)
        return (buttonArtwork, SDLSoftButton(type: .both, text: buttonName, image: SDLImage(name: buttonArtwork.name, isTemplate: false), highlighted: false, buttonId: 11, systemAction: .defaultAction) { (press, event) in
            SDLLog.d("\(buttonName) button selected")
        })
    }

    class var staticIconButton: SDLSoftButton {
        let buttonName = "Static Icon"
        return SDLSoftButton(type: .image, text: nil, image: SDLImage(staticIconName: .key), highlighted: false, buttonId: 11, systemAction: .defaultAction) { (press, event) in
            SDLLog.d("\(buttonName) button selected")
        }
    }
}


