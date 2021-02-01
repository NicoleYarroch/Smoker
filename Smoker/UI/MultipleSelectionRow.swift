//
//  MultipleSelectionRow.swift
//  Smoker
//
//  Created by Nicole on 12/7/20.
//

import SwiftUI

struct MultipleSelectionRow<RowContent: SelectableRow>: View {
    @Binding var content: RowContent
    // Using `@Environment(\.isEnabled) private var isEnabled: Bool` crashes the app with an index out of range error... Not sure if I need to make a customm button?
//    @Environment(\.isEnabled) private var isEnabled: Bool

    var body: some View {
        Button(action: {
            content.isSelected = false
            content.testResult = .testing
            content.subheader = "waiting for response..."
            content.performTask { (testResult, error) in
                DispatchQueue.main.async {
                    if testResult == .success || testResult == .fail {
                        content.isSelected = true
                    } else {
                        content.isSelected = false
                    }

                    content.testResult = testResult
                    content.subheader = error ?? ""
                }
            }
        }) {
            HStack {
                VStack(alignment: .leading) {
                    Text(content.header).font(.system(.title3)).foregroundColor(Color(UIColor.label))
                    Text(content.subheader).font(.system(.caption)).foregroundColor(Color(UIColor.tertiaryLabel))
                }
                Spacer()
                Image(systemName: content.isSelected ? "checkmark.circle.fill" : "circle").foregroundColor(content.testResultColor)
                //(isEnabled ? content.testResultColor : Color(.systemGray))
            }
        }
    }
}
