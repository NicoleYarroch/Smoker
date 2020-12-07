//
//  SmokerApp.swift
//  Smoker
//
//  Created by Nicole on 12/7/20.
//

import SwiftUI

@main
struct SmokerApp: App {
    private let testManager: TestManager = TestManager()

    var body: some Scene {
        WindowGroup {
            TestView(testManager: testManager)
        }
    }
}
