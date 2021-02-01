//
//  TestView.swift
//  Smoker
//
//  Created by Nicole on 12/7/20.
//

import SwiftUI

struct TestView: View {
    @ObservedObject var testManager: TestManager
    @State private var showMenuView = false

    init(testManager: TestManager) {
        self.testManager = testManager
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(testManager.tests.indices, id: \.self) { index in
                    MultipleSelectionRow(content: self.$testManager.tests[index])
                }
            }.disabled(!testManager.sdlManagerStarted)
            .navigationBarTitle("\(testManager.currentTestType.rawValue.localizedCapitalized) Tests", displayMode: .large)
            .navigationBarItems(trailing: Button(action: {
                showMenuView.toggle()
            }) {
                Image(systemName: "line.horizontal.3")
                    .font(Font.system(.title)).foregroundColor(Color(UIColor.systemYellow))
            })
        }.sheet(isPresented: $showMenuView) {
            MenuView(isPresented: $showMenuView, selectedTestType: $testManager.currentTestType)
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var tests = [
        Test(header: "test 1") { result in
            print("test 1 result")
        },
        Test(header: "test 2") { result in
            print("test 2 result")
        },
        Test(header: "test 3") { result in
            print("test 3 result")
        }
    ]

    static var testManager = TestManager()
    static var previews: some View {
        TestView(testManager: testManager)
    }
}
