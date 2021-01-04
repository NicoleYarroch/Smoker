//
//  AlertTestManager.swift
//  Smoker
//
//  Created by Nicole on 12/7/20.
//

import Foundation
import SmartDeviceLink
import SmartDeviceLinkSwift

class AlertTestManager {
    private(set) var tests = [Test]()

    init() {
        tests = [
            Test(header: "send alert text-field-1 only", performTask: sendAlertTextField1Only),
            Test(header: "send alert text-field-2 only", performTask: sendAlertTextField2Only),
            Test(header: "send alert text-to-speech only", performTask: sendAlertTTSOnly),
            Test(header: "send alert audio file only", performTask: sendAlertAudioFileOnly),
            Test(header: "send UI-&-VR alert", performTask: sendAlertAllPropertiesSet),
            Test(header: "send alert static icons only", performTask: sendAlertStaticIcons),
            Test(header: "cancel UI-only alert", performTask: cancelUIOnlyAlert),
            Test(header: "cancel VR-only alert", performTask: cancelVROnlyAlert),
            Test(header: "cancel UI-&-VR alert", performTask: cancelUIAndVRAlert),
        ]
    }

    private func sendAlertTextField1Only(successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        let alert = SDLAlert()
        alert.alertText1 = "alertText1"

        ProxyManager.shared.sendRequest(alert, successHandler: successHandler)
    }

    private func sendAlertTextField2Only(successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        let alert = SDLAlert()
        alert.alertText2 = "alertText2"

        ProxyManager.shared.sendRequest(alert, successHandler: successHandler)
    }

    private func sendAlertTTSOnly(successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        let alert = SDLAlert()
        alert.ttsChunks = [SDLTTSChunk(text: "text to speech only", type: .text)]

        ProxyManager.shared.sendRequest(alert, successHandler: successHandler)
    }

    private func sendAlertAudioFileOnly(successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        let soundFile = SDLFile(fileURL: Audio.soundFileURL, name: Audio.audioFileName, persistent: false)
        ProxyManager.shared.sendFile(soundFile) { (testResult, error) in
            guard testResult == .success else {
                return successHandler(testResult, error)
            }

            let alert = SDLAlert()
            alert.ttsChunks = SDLTTSChunk.fileChunks(withName: soundFile.name)
            ProxyManager.shared.sendRequest(alert, successHandler: successHandler)
        }
    }

    private func sendAlertAllPropertiesSet(successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        let alertIcon = Artworks.randomSolidColor
        let okSoftButton = SoftButtons.defaultOkButton()
        ProxyManager.shared.sendFiles([alertIcon, okSoftButton.artwork]) { (testResult, error) in
            guard testResult == .success else {
                return successHandler(testResult, error)
            }

            let alert = SDLAlert()
            alert.alertText1 = "alertText1"
            alert.alertText2 = "alertText2"
            alert.alertText3 = "alertText3"
            alert.duration = NSNumber(8000)
            alert.progressIndicator = NSNumber(true)
            alert.ttsChunks = [SDLTTSChunk(text: "hello", type: .text)]
            alert.softButtons = [okSoftButton.button]
            alert.alertIcon = SDLImage(name: alertIcon.name, isTemplate: false)

            ProxyManager.shared.sendRequest(alert, successHandler: successHandler)
        }
    }

    private func sendAlertStaticIcons(successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        let alert = SDLAlert()
        alert.alertText1 = "alertText1"
        alert.alertText2 = "alertText2"
        alert.alertText3 = "alertText3"
        alert.duration = NSNumber(8000)
        alert.progressIndicator = NSNumber(true)
        alert.ttsChunks = [SDLTTSChunk(text: "hello", type: .text)]
        alert.softButtons = [SoftButtons.staticIconButton]
        alert.alertIcon = SDLImage(staticIconName: .audioMute)
        ProxyManager.shared.sendRequest(alert, successHandler: successHandler)
    }

    private func cancelUIOnlyAlert(successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        let okSoftButton = SoftButtons.defaultOkButton()
        let cancelID = 100
        ProxyManager.shared.sendFiles([okSoftButton.artwork]) { (testResult, error) in
            guard testResult == .success else {
                return successHandler(testResult, error)
            }

            let alert = SDLAlert()
            alert.alertText1 = "alertText1"
            alert.softButtons = [okSoftButton.button]
            alert.cancelID = NSNumber(value: cancelID)

            ProxyManager.shared.sendRequest(alert, successHandler: successHandler)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let cancelInteraction = SDLCancelInteraction(alertCancelID: UInt32(cancelID))
            ProxyManager.shared.sendRequest(cancelInteraction, successHandler: successHandler)
        }
    }

    private func cancelVROnlyAlert(successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        let cancelID = 100
        let alert = SDLAlert()
        alert.ttsChunks =  [SDLTTSChunk(text: "text to speech", type: .text)]
        alert.cancelID = NSNumber(value: cancelID)

        ProxyManager.shared.sendRequest(alert, successHandler: successHandler)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let cancelInteraction = SDLCancelInteraction(alertCancelID: UInt32(cancelID))
            ProxyManager.shared.sendRequest(cancelInteraction, successHandler: successHandler)
        }
    }
    
    private func cancelUIAndVRAlert(successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        let alertIcon = Artworks.randomSolidColor
        let okSoftButton = SoftButtons.defaultOkButton()
        let cancelID = 100

        ProxyManager.shared.sendFiles([alertIcon, okSoftButton.artwork]) { (testResult, error) in
            guard testResult == .success else {
                return successHandler(testResult, error)
            }

            let alert = SDLAlert()
            alert.alertText1 = "alertText1"
            alert.alertText2 = "alertText2"
            alert.alertText3 = "alertText3"
            alert.duration = NSNumber(8000)
            alert.progressIndicator = NSNumber(true)
            alert.ttsChunks = [SDLTTSChunk(text: "hello", type: .text)]
            alert.softButtons = [okSoftButton.button]
            alert.alertIcon = SDLImage(name: alertIcon.name, isTemplate: false)
            alert.cancelID = NSNumber(value: cancelID)

            ProxyManager.shared.sendRequest(alert, successHandler: successHandler)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let cancelInteraction = SDLCancelInteraction(alertCancelID: UInt32(cancelID))
            ProxyManager.shared.sendRequest(cancelInteraction, successHandler: successHandler)
        }
    }
}
