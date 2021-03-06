//
//  MenuView.swift
//  Smoker
//
//  Created by Nicole on 12/7/20.
//

import SwiftUI

struct MenuView: View {
    @Binding var isPresented: Bool
    @Binding var selectedTestType: TestType

    var body: some View {
        NavigationView {
            ZStack {
                Text("Menu")
                MenuList(isPresented: $isPresented, selectedTestType: $selectedTestType)
            }
            .navigationBarTitle(Text("Test Menu"), displayMode: .inline)
        }
    }
}

struct MenuList: View {
    @Binding var isPresented: Bool
    @Binding var selectedTestType: TestType
    @State private var testTypes: [TestType] = TestType.allCases

    var body: some View {
        List {
            ForEach(testTypes, id: \.self) { testType in
                Button(action: {
                    print("selected test type: \(testType)")
                    isPresented = false
                    selectedTestType = testType
                }) {
                    HStack {
                        Text(testType.rawValue.localizedCapitalized)
                        Spacer()
                        Image(systemName: "checkmark").foregroundColor(testType == selectedTestType ? Color(UIColor.systemGreen) : Color(UIColor.clear))
                    }
                }
            }
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(isPresented: .constant(true), selectedTestType: .constant(.alert))
    }
}

