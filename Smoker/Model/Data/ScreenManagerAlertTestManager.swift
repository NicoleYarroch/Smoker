//
//  ScreenManagerAlertTestManager.swift
//  Smoker
//
//  Created by Nicole on 12/14/20.
//

import Foundation
import SmartDeviceLink
import SmartDeviceLinkSwift

class ScreenManagerAlertTestManager {
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
            Test(header: "modify alert view and resend", performTask: modifyAlertAndResend),
            Test(header: "send alert with multiple-state soft buttons", performTask: sendBrokenAlertMultipleSoftButtonStates),
            Test(header: "send alert with neither text, secondaryText, or audio set", performTask: sendBrokenAlertWithWrongFieldSet)
        ]
    }

    private func sendAlertTextField1Only(successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        let alert = SDLAlertView()
        alert.text = "alertText1"

        ProxyManager.shared.sendScreenManagerAlert(alert, successHandler: successHandler)
    }

    private func sendAlertTextField2Only(successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        let alert = SDLAlertView()
        alert.secondaryText = "alertText2"

        ProxyManager.shared.sendScreenManagerAlert(alert, successHandler: successHandler)
    }

    private func sendAlertTTSOnly(successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        let alert = SDLAlertView()
        alert.audio = SDLAlertAudioData(speechSynthesizerString: "text to speech")

        ProxyManager.shared.sendScreenManagerAlert(alert, successHandler: successHandler)
    }

    private func sendAlertAudioFileOnly(successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        let soundFile = SDLFile(fileURL: Audio.soundFileURL, name: Audio.audioFileName, persistent: false)

        let alert = SDLAlertView()
        let alertAudio = SDLAlertAudioData(audioFile: soundFile)
        alertAudio.playTone = true
        alert.audio = alertAudio

        ProxyManager.shared.sendScreenManagerAlert(alert, successHandler: successHandler)
    }

    private func sendAlertAllPropertiesSet(successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        let alert = SDLAlertView(text: "alertText1", secondaryText: "alertText2", tertiaryText: "alertText3", timeout: 8, showWaitIndicator: true, audioIndication: SDLAlertAudioData(speechSynthesizerString: "hello"), buttons: [ScreenManagerAlertTestManager.defaultOkButtonObject], icon: Artworks.randomSolidColor)

        ProxyManager.shared.sendScreenManagerAlert(alert, successHandler: successHandler)
    }

    private func sendAlertStaticIcons(successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        let alert = SDLAlertView(text: "alertText1", secondaryText: "alertText2", tertiaryText: "alertText3", timeout: 8, showWaitIndicator: true, audioIndication: SDLAlertAudioData(speechSynthesizerString: "hello"), buttons: [ScreenManagerAlertTestManager.staticIconButtonObject], icon: SDLArtwork(staticIcon: .audioMute))

        ProxyManager.shared.sendScreenManagerAlert(alert, successHandler: successHandler)
    }

    private func cancelUIOnlyAlert(successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        let alert = SDLAlertView()
        alert.text = "alertText1"
        alert.softButtons = [ScreenManagerAlertTestManager.defaultOkButtonObject]
        ProxyManager.shared.sendScreenManagerAlert(alert, successHandler: successHandler)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            alert.cancel()
        }
    }

    private func cancelVROnlyAlert(successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        let alert = SDLAlertView()
        alert.audio = SDLAlertAudioData(speechSynthesizerString: "text to speech")
        ProxyManager.shared.sendScreenManagerAlert(alert, successHandler: successHandler)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            alert.cancel()
        }
    }

    private func cancelUIAndVRAlert(successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        let alert = SDLAlertView(text: "alertText1", secondaryText: "alertText2", tertiaryText: "alertText3", timeout: 8, showWaitIndicator: true, audioIndication: SDLAlertAudioData(speechSynthesizerString: "hello"), buttons: [ScreenManagerAlertTestManager.defaultOkButtonObject], icon: Artworks.randomSolidColor)
        ProxyManager.shared.sendScreenManagerAlert(alert, successHandler: successHandler)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            alert.cancel()
        }
    }

    private func modifyAlertAndResend(successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        let alert = SDLAlertView(text: "first alert", secondaryText: "line 2", tertiaryText: "line 2", timeout: 8, showWaitIndicator: true, audioIndication: SDLAlertAudioData(speechSynthesizerString: "hello"), buttons: [ScreenManagerAlertTestManager.defaultOkButtonObject, ScreenManagerAlertTestManager.defaultCancelButtonObject], icon: Artworks.randomSolidColor)

        ProxyManager.shared.sendScreenManagerAlert(alert, successHandler: successHandler)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            alert.text = "second alert"
            alert.icon = Artworks.randomSolidColor
            ProxyManager.shared.sendScreenManagerAlert(alert, successHandler: successHandler)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            alert.text = "third alert"
            alert.icon = Artworks.randomSolidColor
            ProxyManager.shared.sendScreenManagerAlert(alert, successHandler: successHandler)
        }
    }

    private func sendBrokenAlertMultipleSoftButtonStates(successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        let alert = SDLAlertView(text: "alertText1", secondaryText: "alertText2", tertiaryText: "alertText3", timeout: 8, showWaitIndicator: true, audioIndication: SDLAlertAudioData(speechSynthesizerString: "hello"), buttons: [ScreenManagerAlertTestManager.brokenButtonObject], icon: Artworks.randomSolidColor)
        alert.softButtons = [ScreenManagerAlertTestManager.brokenButtonObject]

        ProxyManager.shared.sendScreenManagerAlert(alert, successHandler: successHandler)
    }

    private func sendBrokenAlertWithWrongFieldSet(successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        let alert = SDLAlertView()
        alert.tertiaryText = "alertText3"

        ProxyManager.shared.sendScreenManagerAlert(alert, successHandler: successHandler)
    }
}

extension ScreenManagerAlertTestManager {
    private class var defaultOkButtonObject: SDLSoftButtonObject {
        let buttonName = "Ok"
        let iconSize = SoftButtons.softButtonIconSize
        return SDLSoftButtonObject(name: buttonName, text: buttonName, artwork: Artworks.randomSolidColor(width: iconSize.resolutionWidth.intValue, height: iconSize.resolutionHeight.intValue)) { (press, event) in
            SDLLog.d("\(buttonName) button selected")
        }
    }

    private class var defaultCancelButtonObject: SDLSoftButtonObject {
        let buttonName = "Cancel"
        let iconSize = SDLImageResolution(width: 500, height: 500)
        return SDLSoftButtonObject(name: buttonName, text: buttonName, artwork: Artworks.randomSolidColor(width: iconSize.resolutionWidth.intValue, height: iconSize.resolutionHeight.intValue)) { (press, event) in
            SDLLog.d("\(buttonName) button selected")
        }
    }

    private class var staticIconButtonObject: SDLSoftButtonObject {
        let buttonName = "Static Icon"
        return SDLSoftButtonObject(name: buttonName, text: nil, artwork: SDLArtwork(staticIcon: .key)) { (press, event) in
            SDLLog.d("\(buttonName) button selected")
        }
    }

    private class var brokenButtonObject: SDLSoftButtonObject {
        let buttonState1Name = "Button 1"
        let buttonState2Name = "Button 2"
        let state1 = SDLSoftButtonState(stateName: buttonState1Name, text: buttonState1Name, artwork: Artworks.randomSolidColor)
        let state2 = SDLSoftButtonState(stateName: buttonState2Name, text: buttonState2Name, artwork: Artworks.randomSolidColor)
        return SDLSoftButtonObject(name: "Broken Button", states: [state1, state2], initialStateName: state1.name) { (press, events) in
            SDLLog.d("Broken button selected?")
        }
    }
}
