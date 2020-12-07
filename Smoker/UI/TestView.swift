//
//  TestView.swift
//  Smoker
//
//  Created by Nicole on 12/7/20.
//

import SwiftUI

struct TestView: View {
    @ObservedObject var tests: Tests
    @State private var backgroundColor: Color = .blue

    init(test: Tests) {
        self.tests = test
    }

    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(tests.tests.indices, id: \.self) { index in
                        MultipleSelectionRow(content: $tests.tests[index])
                    }
                }.background(Color.red)
            }
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var tests = Tests(header: "Testing 1, 2, 3", tests: [
        Test(header: "test 1"),
        Test(header: "test 2"),
        Test(header: "test 3")
    ])

    static var previews: some View {
        TestView(test: tests)
    }
}
