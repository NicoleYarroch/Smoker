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
    private var storedAlerts = [SDLAlertView(text: "stored alert!", secondaryText: nil, tertiaryText: nil, timeout: nil, showWaitIndicator: NSNumber(false), audioIndication: SDLAlertAudioData(speechSynthesizerString: "stored alert"), buttons: nil, icon: SDLArtwork(staticIcon: .clock))]

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
            Test(header: "cancel stored alert", performTask: cancelStoredAlert),
            Test(header: "modify alert view and resend", performTask: modifyAlertAndResend),
            Test(header: "send alerts in quick succession", performTask: sendAlertsInQuickSuccession),
            Test(header: "send alert with more than 4 buttons", performTask: sendAlertWithMoreThan4SoftButtons),
            Test(header: "send alert with soft buttons with same name", performTask: sendBrokenAlertWithWrongImage),
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
        let alert = SDLAlertView(text: "alertText1", secondaryText: "alertText2", tertiaryText: "alertText3", timeout: NSNumber(8), showWaitIndicator: NSNumber(true), audioIndication: SDLAlertAudioData(speechSynthesizerString: "hello"), buttons: [ScreenManagerAlertTestManager.defaultOkButtonObject], icon: Artworks.randomSolidColor)

        ProxyManager.shared.sendScreenManagerAlert(alert, successHandler: successHandler)
    }

    private func sendAlertStaticIcons(successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        let alert = SDLAlertView(text: "alertText1", secondaryText: "alertText2", tertiaryText: "alertText3", timeout: NSNumber(8), showWaitIndicator: NSNumber(true), audioIndication: SDLAlertAudioData(speechSynthesizerString: "hello"), buttons: [ScreenManagerAlertTestManager.staticIconButtonObject], icon: SDLArtwork(staticIcon: .audioMute))

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

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            alert.cancel()
        }
    }

    private func cancelUIAndVRAlert(successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        let alert = SDLAlertView(text: "alertText1", secondaryText: "alertText2", tertiaryText: "alertText3", timeout: NSNumber(8), showWaitIndicator: NSNumber(true), audioIndication: SDLAlertAudioData(speechSynthesizerString: "hello"), buttons: [ScreenManagerAlertTestManager.defaultOkButtonObject], icon: Artworks.randomSolidColor)
        ProxyManager.shared.sendScreenManagerAlert(alert, successHandler: successHandler)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            alert.cancel()
        }
    }

    private func cancelStoredAlert(successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        ProxyManager.shared.sendScreenManagerAlert(storedAlerts[0], successHandler: successHandler)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.storedAlerts[0].cancel()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            guard let self = self else { return }
            self.storedAlerts[0].text = "alert 2!"
            self.storedAlerts[0].softButtons = [ScreenManagerAlertTestManager.defaultOkButtonObject]
            ProxyManager.shared.sendScreenManagerAlert(self.storedAlerts[0] , successHandler: successHandler)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
            guard let self = self else { return }
            self.storedAlerts[0].cancel()
        }
    }
    
    private func modifyAlertAndResend(successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        let alert = SDLAlertView(text: "first alert", secondaryText: "line 2", tertiaryText: "line 2", timeout: NSNumber(8), showWaitIndicator: NSNumber(true), audioIndication: SDLAlertAudioData(speechSynthesizerString: "hello"), buttons: [ScreenManagerAlertTestManager.defaultOkButtonObject, ScreenManagerAlertTestManager.defaultCancelButtonObject], icon: Artworks.randomSolidColor)

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

    private func sendAlertWithMoreThan4SoftButtons(successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        let button1 = SDLSoftButtonObject(name: "button1", text: "button1", artwork: Artworks.randomSolidColor(width: 100, height: 100)) { (press, event) in
            guard press != nil else { return }
            SDLLog.d("button1 selected")
        }
        let button2 = SDLSoftButtonObject(name: "button2", text: "button2", artwork: Artworks.randomSolidColor(width: 100, height: 100)) { (press, event) in
            guard press != nil else { return }
            SDLLog.d("button2 selected")
        }
        let button3 = SDLSoftButtonObject(name: "button3", text: "button3", artwork: Artworks.randomSolidColor(width: 100, height: 100)) { (press, event) in
            guard press != nil else { return }
            SDLLog.d("button3 selected")
        }
        let button4 = SDLSoftButtonObject(name: "button4", text: "button4", artwork: Artworks.randomSolidColor(width: 100, height: 100)) { (press, event) in
            guard press != nil else { return }
            SDLLog.d("button4 selected")
        }
        let button5 = SDLSoftButtonObject(name: "button5", text: "button5", artwork: Artworks.randomSolidColor(width: 100, height: 100)) { (press, event) in
            guard press != nil else { return }
            SDLLog.d("button5 selected")
        }

        let alert1 = SDLAlertView(text: "first alert", secondaryText: "line 2", tertiaryText: "line 2", timeout: NSNumber(8), showWaitIndicator: NSNumber(true), audioIndication: SDLAlertAudioData(speechSynthesizerString: "bee"), buttons: [button1, button2, button3, button4, button5], icon: Artworks.randomSolidColor)
        ProxyManager.shared.sendScreenManagerAlert(alert1, successHandler: successHandler)

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            alert1.text = "second alert"
            ProxyManager.shared.sendScreenManagerAlert(alert1, successHandler: successHandler)
        }
    }

    private func sendAlertsInQuickSuccession(successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        let alert1 = SDLAlertView(text: "first alert", secondaryText: "line 2", tertiaryText: "line 2", timeout: NSNumber(8), showWaitIndicator: NSNumber(true), audioIndication: SDLAlertAudioData(speechSynthesizerString: "bee"), buttons: [ScreenManagerAlertTestManager.defaultOkButtonObject, ScreenManagerAlertTestManager.defaultCancelButtonObject], icon: Artworks.randomSolidColor)
        let alert2 = SDLAlertView(text: "second alert", secondaryText: "line 2", tertiaryText: "line 2", timeout: NSNumber(8), showWaitIndicator: NSNumber(true), audioIndication: SDLAlertAudioData(speechSynthesizerString: "cow in the shoe"), buttons: [], icon: Artworks.randomSolidColor)
        let alert3 = SDLAlertView(text: "third alert", secondaryText: "line 2", tertiaryText: "line 2", timeout: NSNumber(8), showWaitIndicator: NSNumber(true), audioIndication: SDLAlertAudioData(speechSynthesizerString: "fox in the box"), buttons: [], icon: nil)

        ProxyManager.shared.sendScreenManagerAlert(alert1, successHandler: successHandler)

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(5)) {
            ProxyManager.shared.sendScreenManagerAlert(alert2, successHandler: successHandler)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(5)) {
            ProxyManager.shared.sendScreenManagerAlert(alert3, successHandler: successHandler)
        }
    }

    private func sendBrokenAlertWithWrongImage(successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        let alert = SDLAlertView()
        alert.text = "Testing Images"
        alert.softButtons = [ScreenManagerAlertTestManager.defaultOkButtonObject, ScreenManagerAlertTestManager.defaultOk2ButtonObject, ScreenManagerAlertTestManager.defaultCancelButtonObject]

        ProxyManager.shared.sendScreenManagerAlert(alert, successHandler: successHandler)
    }

    private func sendBrokenAlertMultipleSoftButtonStates(successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        let alert = SDLAlertView(text: "alertText1", secondaryText: "alertText2", tertiaryText: "alertText3", timeout: NSNumber(8), showWaitIndicator: NSNumber(true), audioIndication: SDLAlertAudioData(speechSynthesizerString: "hello"), buttons: [ScreenManagerAlertTestManager.brokenButtonObject], icon: Artworks.randomSolidColor)
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
//        let iconSize = SoftButtons.softButtonIconSize
        return SDLSoftButtonObject(name: buttonName, text: buttonName, artwork: SDLArtwork(staticIcon: .keepLeft)) { (press, event) in
            SDLLog.d("Ok 1 button selected")
        }
    }

    private class var defaultOk2ButtonObject: SDLSoftButtonObject {
        let buttonName = "Ok"
//        let iconSize = SoftButtons.softButtonIconSize
        return SDLSoftButtonObject(name: buttonName, text: buttonName, artwork: SDLArtwork(staticIcon: .keepLeft)) { (press, event) in
            SDLLog.d("Ok 2 button selected")
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
