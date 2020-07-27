//
//  Player.swift
//  NBA Comparison
//
//  Created by chuck on 7/24/20.
//  Copyright © 2020 AlexZ. All rights reserved.
//

import Foundation

struct Player : Identifiable, Hashable {
    var id = UUID()
    var remoteId : Int = -1
    var first_name : String = ""
    var last_name : String = ""
    var display_name : String = ""
    var sort_name : String = ""
}
