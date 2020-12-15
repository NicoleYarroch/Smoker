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
            Test(header: "cancel UI-only alert", performTask: cancelUIOnlyAlert),
            Test(header: "cancel VR-only alert", performTask: cancelVROnlyAlert),
            Test(header: "cancel UI-&-VR alert", performTask: cancelUIAndVRAlert),
            Test(header: "modify alert view and resend", performTask: modifyAlertAndResend),
//            Test(header: "send alert with multiple-state soft buttons", performTask: cancelUIOnlyAlert),
//            Test(header: "send alert with neither text, secondaryText, or audio set", performTask: cancelUIOnlyAlert)
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
        let soundFile = SDLFile(fileURL: ScreenManagerAlertTestManager.soundFileURL, name: ScreenManagerAlertTestManager.audioFileName, persistent: false)

        let alert = SDLAlertView()
        let alertAudio = SDLAlertAudioData(audioFile: soundFile)
        alertAudio.playTone = true
        alert.audio = alertAudio

        ProxyManager.shared.sendScreenManagerAlert(alert, successHandler: successHandler)
    }

    private func sendAlertAllPropertiesSet(successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        let alert = SDLAlertView(text: "alertText1", secondaryText: "alertText2", tertiaryText: "alertText3", timeout: 8, showWaitIndicator: true, audioIndication: SDLAlertAudioData(speechSynthesizerString: "hello"), buttons: [ScreenManagerAlertTestManager.defaultOkButton], icon: Artworks.solidColor)

        ProxyManager.shared.sendScreenManagerAlert(alert, successHandler: successHandler)
    }

    private func cancelUIOnlyAlert(successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        let alert = SDLAlertView()
        alert.text = "alertText1"
        alert.softButtons = [ScreenManagerAlertTestManager.defaultOkButton]
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
        let alert = SDLAlertView(text: "alertText1", secondaryText: "alertText2", tertiaryText: "alertText3", timeout: 8, showWaitIndicator: true, audioIndication: SDLAlertAudioData(speechSynthesizerString: "hello"), buttons: [ScreenManagerAlertTestManager.defaultOkButton], icon: Artworks.solidColor)
        ProxyManager.shared.sendScreenManagerAlert(alert, successHandler: successHandler)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            alert.cancel()
        }
    }

    private func modifyAlertAndResend(successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        let alert = SDLAlertView(text: "first alert", secondaryText: "line 2", tertiaryText: "line 2", timeout: 8, showWaitIndicator: true, audioIndication: SDLAlertAudioData(speechSynthesizerString: "hello"), buttons: [ScreenManagerAlertTestManager.defaultOkButton, ScreenManagerAlertTestManager.defaultCancelButton], icon: Artworks.solidColor)

        ProxyManager.shared.sendScreenManagerAlert(alert, successHandler: successHandler)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            alert.text = "second alert"
            alert.icon = Artworks.solidColor
            ProxyManager.shared.sendScreenManagerAlert(alert, successHandler: successHandler)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            alert.text = "third alert"
            alert.icon = Artworks.solidColor
            ProxyManager.shared.sendScreenManagerAlert(alert, successHandler: successHandler)
        }
    }
}

extension ScreenManagerAlertTestManager {
    private class var audioFileName: String {
        return "fox_dog"
    }

    private class var soundFileURL: URL {
        let soundFileName = audioFileName
        let soundFileFormat = "mp3"
        let filePath = Bundle.main.path(forResource: soundFileName, ofType: soundFileFormat)
        return URL(fileURLWithPath: filePath ??  "")
    }

    private class var defaultOkButton: SDLSoftButtonObject {
        let buttonName = "Ok"
        return SDLSoftButtonObject(name: buttonName, text: buttonName, artwork: Artworks.solidColor) { (press, event) in
            SDLLog.d("\(buttonName) button selected")
        }
    }

    private class var defaultCancelButton: SDLSoftButtonObject {
        let buttonName = "Cancel"
        return SDLSoftButtonObject(name: buttonName, text: buttonName, artwork: Artworks.solidColor) { (press, event) in
            SDLLog.d("\(buttonName) button selected")
        }
    }

    private class var brokenButton: SDLSoftButtonObject {
        let buttonState1Name = "Button 1"
        let buttonState2Name = "Button 2"
        let state1 = SDLSoftButtonState(stateName: buttonState1Name, text: buttonState1Name, artwork: Artworks.solidColor)
        let state2 = SDLSoftButtonState(stateName: buttonState2Name, text: buttonState2Name, artwork: Artworks.solidColor)
        return SDLSoftButtonObject(name: "Broken Button", states: [state1, state2], initialStateName: state1.name) { (press, events) in
            SDLLog.d("Broken button selected?")
        }
    }
}
