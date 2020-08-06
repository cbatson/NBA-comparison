//
//  AboutView.swift
//  NBA Comparison
//
//  Created by chuck on 8/5/20.
//  Copyright © 2020 AlexZ. All rights reserved.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack {
            Text("NBA Comparison")
                .font(.largeTitle)
            Text("by Alex Zhou")
                .font(.headline)
            Text("")
            Text("Copyright © 2020 Alex Zhou")
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
