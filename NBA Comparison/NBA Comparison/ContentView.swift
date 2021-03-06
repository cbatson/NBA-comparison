//
//  ContentView.swift
//  NBA Comparison
//
//  Created by chuck on 7/24/20.
//  Copyright © 2020 AlexZ. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        UIKitTabView {
            ComparePlayersView().tab(title: "Compare", image: "person.2.fill")
            AboutView().tab(title: "About", image: "info.circle")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
