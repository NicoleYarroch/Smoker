//
//  MenuTestManager.swift
//  Smoker
//
//  Created by Nicole on 12/7/20.
//

import Foundation
import SmartDeviceLink
import SmartDeviceLinkSwift

class MenuTestManager {
    private var sdlManager: SDLManager?
    private(set) var tests: Tests

    init() {
        tests = Tests(testType: .alert, tests: [])
        tests.tests = [
            Test(header: "send add-command menu-only", performTask: sendAddCommandMenuOnly),
            Test(header: "delete add-command menu-only", performTask: deleteAddCommandMenuOnly)
        ]
    }

    func start(with manager: SDLManager) {
        sdlManager = manager
    }

    func sendAddCommandMenuOnly(successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        let addCommand = SDLAddCommand(id: 56, vrCommands: nil, menuName: "Add Command") { onCommand in
            SDLLog.d("Add command selected with: \(onCommand.triggerSource)")
        }
        
        TestManager.sendRequest(addCommand, with: sdlManager, successHandler: successHandler)
    }
    
    func deleteAddCommandMenuOnly(successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        let deleteCommand = SDLDeleteCommand(id: 56)

        TestManager.sendRequest(deleteCommand, with: sdlManager, successHandler: successHandler)
    }
}
