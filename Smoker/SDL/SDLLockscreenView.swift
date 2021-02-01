//
//  SDLLockscreenView.swift
//  Smoker
//
//  Created by Nicole on 2/1/21.
//

import SwiftUI

struct SDLLockscreenView: View {
    var body: some View {
        ZStack {
            Color(UIColor.systemIndigo).ignoresSafeArea()
            Text("Smokers")
                .font(.largeTitle).bold()
                .foregroundColor(Color(UIColor.systemYellow))

        }
    }
}

struct LockscreenView_Previews: PreviewProvider {
    static var previews: some View {
        SDLLockscreenView()
    }
}
