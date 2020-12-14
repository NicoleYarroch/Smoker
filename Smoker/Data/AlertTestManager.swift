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
    private var sdlManager: SDLManager?
    private(set) var tests: Tests

    init() {
        tests = Tests(testType: .alert, tests: [])
        tests.tests = [
            Test(header: "send alert text-field-1 only", performTask: sendAlertTextField1Only),
            Test(header: "send alert text-field-2 only", performTask: sendAlertTextField2Only),
            Test(header: "send alert text-to-speech only", performTask: sendAlertTTSOnly)
        ]
    }

    func start(with manager: SDLManager) {
        sdlManager = manager
    }

    private func sendAlertTextField1Only(successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        let alert: SDLAlert = SDLAlert()
        alert.alertText1 = "alertText1"

        TestManager.sendRequest(alert, with: sdlManager, successHandler: successHandler)
    }

    private func sendAlertTextField2Only(successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        let alert: SDLAlert = SDLAlert()
        alert.alertText2 = "alertText2"

        TestManager.sendRequest(alert, with: sdlManager, successHandler: successHandler)
    }

    private func sendAlertTTSOnly(successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        let alert: SDLAlert = SDLAlert()
        alert.ttsChunks = [SDLTTSChunk(text: "text to speech only", type: .text)]

        TestManager.sendRequest(alert, with: sdlManager, successHandler: successHandler)
    }
}
