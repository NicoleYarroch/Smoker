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
            Test(header: "send alert text-to-speech only", performTask: sendAlertTTSOnly)
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
}
