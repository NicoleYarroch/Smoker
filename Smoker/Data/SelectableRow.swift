//
//  SelectableRow.swift
//  Smoker
//
//  Created by Nicole on 12/7/20.
//

import SwiftUI

protocol SelectableRow {
    var header: String { get }
    var subheader: String { get set }
    var isSelected: Bool { get set }
    var testResult: TestResult { get set }
    var testResultColor: Color { get set }
    func performTask(_ handler: @escaping (TestResult) -> ())
}
