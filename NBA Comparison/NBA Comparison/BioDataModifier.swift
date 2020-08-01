//
//  BioDataModifier.swift
//  NBA Comparison
//
//  Created by chuck on 7/31/20.
//  Copyright © 2020 AlexZ. All rights reserved.
//

import SwiftUI

struct BioDataModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 180, alignment: .center)
            .multilineTextAlignment(.center)
            .lineLimit(1)
            .truncationMode(.tail)
            //.border(Color.red)
    }
}
