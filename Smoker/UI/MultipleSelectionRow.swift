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
            content.performTask { testResult in
                if testResult == .success || testResult == .fail {
                    content.isSelected = true
                } else  {
                    content.isSelected = false
                }

                content.testResult = testResult
            }
        }) {
            HStack {
                Text(content.header)
                Spacer()
                Image(systemName: content.isSelected ? "checkmark.circle.fill" : "circle").foregroundColor(content.testResultColor)
            }
        }
    }
}

//struct MultipleSelectionRow_Previews: PreviewProvider {
//    static var previews: some View {
//        MultipleSelectionRow()
//    }
//}
