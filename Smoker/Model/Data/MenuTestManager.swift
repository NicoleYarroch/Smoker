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
    private(set) var tests = [Test]()

    init() {
        tests = [
            Test(header: "send add-command menu-only", performTask: sendAddCommandMenuOnly),
            Test(header: "delete add-command menu-only", performTask: deleteAddCommandMenuOnly)
        ]
    }

    func sendAddCommandMenuOnly(successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        let addCommand = SDLAddCommand(id: 56, vrCommands: nil, menuName: "Add Command") { onCommand in
            SDLLog.d("Add command selected with: \(onCommand.triggerSource)")
        }
        
        ProxyManager.shared.sendRequest(addCommand, successHandler: successHandler)
    }
    
    func deleteAddCommandMenuOnly(successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        let deleteCommand = SDLDeleteCommand(id: 56)

        ProxyManager.shared.sendRequest(deleteCommand, successHandler: successHandler)
    }
}
