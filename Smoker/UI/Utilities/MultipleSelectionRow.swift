//
//  MultipleSelectionRow.swift
//  Smoker
//
//  Created by Nicole on 12/7/20.
//

import SwiftUI

struct MultipleSelectionRow<RowContent: SelectableRow>: View {
    @Binding var content: RowContent

    var body: some View {
        Button(action: {
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
                    Text(content.header).font(.system(.title3))
                    Text(content.subheader).font(.system(.caption))
                }
                Spacer()
                Image(systemName: content.isSelected ? "checkmark.circle.fill" : "circle").foregroundColor(content.testResultColor)
            }
        }
    }
}
