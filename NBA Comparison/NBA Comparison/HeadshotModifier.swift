//
//  HeadshotModifier.swift
//  NBA Comparison
//
//  Created by chuck on 7/31/20.
//  Copyright © 2020 AlexZ. All rights reserved.
//

import SwiftUI

struct HeadshotModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 200, height: 150, alignment: .bottom)
            .scaledToFit()
            //.border(Color.red)
            .shadow(color: .gray, radius: 4, x: 3, y: 3)
    }
}
