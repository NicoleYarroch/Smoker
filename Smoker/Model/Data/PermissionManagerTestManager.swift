//
//  PermissionManagerTestManager.swift
//  Smoker
//
//  Created by Nicole on 2/1/21.
//

import Foundation
import SmartDeviceLink
import SmartDeviceLinkSwift

class PermissionManagerTestManager {
    private(set) var tests = [Test]()
    private let addCommandPermissionElement = SDLPermissionElement(rpcName: .addCommand, parameterPermissions: nil)
    private let addSubmenuPermissionElement = SDLPermissionElement(rpcName: .addSubMenu, parameterPermissions: nil)

    init() {
        tests = [
            Test(header: "is AddCommand currently allowed", performTask: isRPCAllowed),
            Test(header: "are the AddCommand and AddSubmenu RPCs currently allowed", performTask: areRPCsAllowed),
            Test(header: "is getting odometer data with the GetVehicleData RPC allowed", performTask: isPermissionParameterAllowed),
            Test(header: "subscribe to AddCommand and AddSubmenu RPCs with a group status of all-allowed", performTask: subscribeToRPCsWithGroupTypeAllAllowed),
            Test(header: "subscribe to AddCommand and AddSubmenu RPCs with a group status of all-allowed", performTask: subscribeToRPCsWithGroupTypeAny),
        ]
    }

    func isRPCAllowed(successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        ProxyManager.shared.checkPermissions(rpcName: .addCommand, successHandler: successHandler)
    }

    func areRPCsAllowed(successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        ProxyManager.shared.checkGroupPermissions(permissionElements: [addCommandPermissionElement, addSubmenuPermissionElement], successHandler: successHandler)
    }

    func isPermissionParameterAllowed(successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        let parameter = "odometer"
        ProxyManager.shared.checkPermissionParameter(parameter, for: .getVehicleData, successHandler: successHandler)
    }

    func subscribeToRPCsWithGroupTypeAllAllowed(successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        let rpcs = [SDLPermissionElement(rpcName: .addCommand, parameterPermissions: nil), SDLPermissionElement(rpcName: .addSubMenu, parameterPermissions: nil)]
        ProxyManager.shared.subscribePermissions(permissionElements: rpcs, groupType: .allAllowed, successHandler: successHandler)
    }

    func subscribeToRPCsWithGroupTypeAny(successHandler: @escaping ((TestResult, _ errorString: String?) -> Void)) {
        let rpcs = [SDLPermissionElement(rpcName: .addCommand, parameterPermissions: nil), SDLPermissionElement(rpcName: .addSubMenu, parameterPermissions: nil)]
        ProxyManager.shared.subscribePermissions(permissionElements: rpcs, groupType: .any, successHandler: successHandler)
    }
}
