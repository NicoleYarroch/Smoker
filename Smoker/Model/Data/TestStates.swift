//
//  TestStates.swift
//  Smoker
//
//  Created by Nicole on 12/7/20.
//

import SwiftUI

enum TestType: String, CaseIterable {
    case alert = "alert"
    case menu = "menu"
    case screenManagerAlert = "screen manager alert"
    case media = "media"
}

enum TestResult {
    case testing
    case untested
    case success
    case fail
}

class Test: Identifiable, Hashable, SelectableRow, ObservableObject {
    let id = UUID().uuidString
    var header: String
    @Published var subheader: String
    @Published var isSelected: Bool
    @Published var testResult: TestResult {
        didSet {
            switch testResult {
            case .untested, .testing: testResultColor = .gray
            case .success: testResultColor = .green
            case .fail: testResultColor = .red
            }
        }
    }
    @Published var testResultColor: Color
    var performTask: (@escaping ((TestResult, _ errorString: String?) -> Void)) -> ()

    init(header: String, performTask: @escaping (@escaping ((TestResult, _ errorString: String?) -> Void)) -> ()) {
        self.header = header
        self.subheader = "not tested"
        self.isSelected = false
        self.testResultColor = .black
        self.testResult = .untested
        self.performTask = performTask
    }

    static func == (lhs: Test, rhs: Test) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
