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
    private(set) var sdlManager: SDLManager?
    private let alertTestManager = AlertTestManager()
    private let menuTestManager = MenuTestManager()

    init(tests: Tests? = nil) {
        if let tests = tests {
            self.tests = tests
        } else {
            self.tests = Tests(header: "Default Tests", tests: [
                Test(header: "default test 1") { testResult in
                    print("1 ran something")
                }
            ])
        }

        ProxyManager.shared.start(with: SDLAppConstants.connectionType) { (success, sdlManager) in
            DispatchQueue.main.async {
                self.start(with: sdlManager)
            }
        }
    }

    func start(with sdlManager: SDLManager) {
        self.sdlManager = sdlManager
        alertTestManager.start(with: sdlManager)
        menuTestManager.start(with: sdlManager)

        self.tests = alertTestManager.tests
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

