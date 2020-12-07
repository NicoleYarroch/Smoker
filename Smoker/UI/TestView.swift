//
//  TestView.swift
//  Smoker
//
//  Created by Nicole on 12/7/20.
//

import SwiftUI

struct TestView: View {
    @ObservedObject var testManager: TestManager
    @State private var backgroundColor: Color = .blue

    init(testManager: TestManager) {
        self.testManager = testManager
    }

    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(testManager.tests.tests.indices, id: \.self) { index in
                        MultipleSelectionRow(content: $testManager.tests.tests[index])
                    }
                }
            }
            .navigationBarTitle(testManager.tests.header, displayMode: .large)
            .navigationBarItems(trailing: Button(action: {
                // TODO
            }) {
                Text("Menu")
            })
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var tests = Tests(header: "Preview Provider Testing 1, 2, 3...", tests: [
        Test(header: "test 1") { result in
            print("test 1 result")
        },
        Test(header: "test 2") { result in
            print("test 2 result")
        },
        Test(header: "test 3") { result in
            print("test 3 result")
        }
    ])
    static var testManager = TestManager(tests: tests)

    static var previews: some View {
        TestView(testManager: testManager)
    }
}
