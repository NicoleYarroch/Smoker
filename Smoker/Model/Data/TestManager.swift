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
    @Published var tests: [Test] = []
    var testType: TestType = .alert {
        didSet {
            switch testType {
            case.alert:
                tests = alertTestManager.tests
            case .menu:
                tests = menuTestManager.tests
            case .screenManagerAlert:
                tests = screenManagerAlertTestManager.tests
            case .media:
                tests = mediaTestManager.tests
            case .permissionManager:
                tests = permissionManager.tests
            }
        }
    }
    @Published var sdlManagerStarted: Bool = false
    private let alertTestManager = AlertTestManager()
    private let menuTestManager = MenuTestManager()
    private let screenManagerAlertTestManager = ScreenManagerAlertTestManager()
    private let mediaTestManager = MediaTestManager()
    private let permissionManager = PermissionManagerTestManager()

    init(currentTestType: TestType? = nil) {
        defer {
            self.testType = currentTestType ?? .permissionManager
        }

        ProxyManager.shared.start(with: SDLAppConstants.connectionType) { [weak self] (success) in
            DispatchQueue.main.async {
                self?.sdlManagerStarted = success
            }
        }
    }
}
