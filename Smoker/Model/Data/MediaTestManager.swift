//
//  MediaTestManager.swift
//  Smoker
//
//  Created by Nicole on 1/5/21.
//

import Foundation
import SmartDeviceLink
import SmartDeviceLinkSwift

class MediaTestManager {
    private(set) var tests = [Test]()

    init() {
        tests = [
            Test(header: "switch to media template", performTask: switchToMediaTemplate),
            Test(header: "send square media image", performTask: sendMediaImageSquare),
            Test(header: "send non-square media image", performTask: sendMediaImageNonSquare),
        ]
    }

    func switchToMediaTemplate(successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        let setDisplayLayout = SDLSetDisplayLayout(predefinedLayout: .media)
        ProxyManager.shared.sendRequest(setDisplayLayout, successHandler: successHandler)
    }

    func sendMediaImageSquare(successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        let mediaImage = Artworks.randomSolidColor(width: MediaTestManager.mediaIconSize.resolutionWidth.intValue, height: MediaTestManager.mediaIconSize.resolutionHeight.intValue)

        ProxyManager.shared.sendFiles([mediaImage]) { (testResult, error) in
            guard testResult == .success else {
                return successHandler(testResult, error)
            }

            let show = SDLShow()
            show.mainField1 = "square image"
            show.mainField1 = "image width: \(MediaTestManager.mediaIconSize.resolutionWidth.intValue)"
            show.mainField2 = "image height: \(MediaTestManager.mediaIconSize.resolutionHeight.intValue)"
            show.graphic = SDLImage(name: mediaImage.name, isTemplate: false)

            ProxyManager.shared.sendRequest(show, successHandler: successHandler)
        }
    }

    func sendMediaImageNonSquare(successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        let mediaImage = Artworks.randomSolidColor(width: MediaTestManager.mediaIconSize.resolutionWidth.intValue, height: (MediaTestManager.mediaIconSize.resolutionHeight.intValue / 2))

        ProxyManager.shared.sendFiles([mediaImage]) { (testResult, error) in
            guard testResult == .success else {
                return successHandler(testResult, error)
            }

            let show = SDLShow()
            show.mainField1 = "square image"
            show.mainField1 = "image width: \(MediaTestManager.mediaIconSize.resolutionWidth.intValue)"
            show.mainField2 = "image height: \(MediaTestManager.mediaIconSize.resolutionHeight.intValue / 2)"
            show.graphic = SDLImage(name: mediaImage.name, isTemplate: false)

            ProxyManager.shared.sendRequest(show, successHandler: successHandler)
        }
    }
}

extension MediaTestManager {
    class var mediaIconSize: SDLImageResolution {
        let mediaImageField: SDLImageField? = ProxyManager.shared.sdlManager.systemCapabilityManager.defaultMainWindowCapability?.imageFields?.first(where: { imageField -> Bool in
            imageField.name == .graphic
        })
        return mediaImageField?.imageResolution ?? SDLImageResolution(width: 100, height: 100)
    }
}
