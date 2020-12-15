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
    @Published var tests: [Test]
    var currentTestType: TestType = .alert {
        didSet {
            switch currentTestType {
            case.alert:
                tests = alertTestManager.tests
            case .menu:
                tests = menuTestManager.tests
            case .screenManagerAlert:
                tests = screenManagerTestManager.tests
            }
        }
    }
    @Published var sdlManagerStarted: Bool = false
    private let alertTestManager = AlertTestManager()
    private let menuTestManager = MenuTestManager()
    private let screenManagerTestManager = ScreenManagerAlertTestManager()

    init(tests: [Test]? = nil, currentTestType: TestType = .alert) {
        if let tests = tests {
            self.currentTestType = currentTestType
            self.tests = tests
        } else {
            self.tests = screenManagerTestManager.tests
            self.currentTestType = .screenManagerAlert
        }

        ProxyManager.shared.start(with: SDLAppConstants.connectionType) { [weak self] (success) in
            DispatchQueue.main.async {
                self?.sdlManagerStarted = success
            }
        }
    }
}
