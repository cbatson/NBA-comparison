//
//  SplashView.swift
//  NBA Comparison
//
//  Created by chuck on 10/21/20.
//  Copyright © 2020 AlexZ. All rights reserved.
//

import SwiftUI

struct SplashView: View {
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        VStack {
            Button("X") {
                self.presentation.wrappedValue.dismiss()
            }.frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
            Spacer()
            Image("WelcomePage")
            .resizable()
            .scaledToFit()
            Button(action: {
                self.presentation.wrappedValue.dismiss()
            }, label: {
                Text("Next")
            })
        }.padding()
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
