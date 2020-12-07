//
//  TestStates.swift
//  Smoker
//
//  Created by Nicole on 12/7/20.
//

import SwiftUI

enum TestResult {
    case untested
    case success
    case fail
}

class Tests: Identifiable, Hashable, ObservableObject {
    let id = UUID().uuidString
    var header: String
    @Published var tests: [Test]

    init(header: String, tests: [Test]) {
        self.header = header
        self.tests = tests
    }

    static func == (lhs: Tests, rhs: Tests) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

class Test: Identifiable, Hashable, SelectableRow, ObservableObject {
    let id = UUID().uuidString
    var header: String
    @Published var subheader: String
    @Published var isSelected: Bool
    @Published var testResult: TestResult {
        didSet {
            switch testResult {
            case .untested: testResultColor = .gray
            case .success: testResultColor = .green
            case .fail: testResultColor = .red
            }
        }
    }
    @Published var testResultColor: Color

    init(header: String) {
        self.header = header
        self.subheader = "not tested"
        self.isSelected = false
        self.testResultColor = .black
        self.testResult = .untested
    }

    func performTask(_ handler: @escaping (TestResult) -> ()) {
        return handler(.fail)
    }

    static func == (lhs: Test, rhs: Test) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

