//
//  TestManager.swift
//  Smoker
//
//  Created by Nicole on 12/7/20.
//

import Foundation
import SmartDeviceLink
import SmartDeviceLinkSwift

class TestManager: ObservableObject {
    @Published var tests: Tests
    var currentTestType: TestType = .alert {
        didSet {
            switch currentTestType {
            case.alert:
                tests = alertTestManager.tests
            case .menu:
                tests = menuTestManager.tests
            }
        }
    }
    @Published var sdlManagerStarted: Bool = false
    private var sdlManager: SDLManager?
    private let alertTestManager = AlertTestManager()
    private let menuTestManager = MenuTestManager()

    init(tests: Tests? = nil, currentTestType: TestType = .alert) {
        if let tests = tests {
            self.currentTestType = currentTestType
            self.tests = tests
        } else {
            self.currentTestType = currentTestType
            self.tests = alertTestManager.tests
        }

        ProxyManager.shared.start(with: SDLAppConstants.connectionType) { [weak self] (success, sdlManager) in
            if !success {
                self?.sdlManagerStarted = false
                self?.sdlManager = nil
                return
            }

            DispatchQueue.main.async {
                self?.sdlManagerStarted = true
                self?.startTestManagers(with: sdlManager)
            }
        }
    }

    func startTestManagers(with sdlManager: SDLManager) {
        self.sdlManager = sdlManager
        alertTestManager.start(with: sdlManager)
        menuTestManager.start(with: sdlManager)
    }
}

extension TestManager {
    class func sendRequest(_ request: SDLRPCRequest, with sdlManager: SDLManager?, successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        guard let sdlManager = sdlManager else { return successHandler(.fail, "no connection to module") }
        sdlManager.send(request: request) { (_: SDLRPCRequest?, response: SDLRPCResponse?, error: Error?) in
            let responseSuccess = response?.success.boolValue ?? false
            var responseError = "no error"
            if let error = error as NSError? {
                responseError = error.localizedDescription
            }
            successHandler(responseSuccess ? .success : .fail, responseError)
        }
    }
}

