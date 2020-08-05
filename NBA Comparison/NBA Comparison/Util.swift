//
//  Util.swift
//  NBA Comparison
//
//  Created by chuck on 8/3/20.
//  Copyright © 2020 AlexZ. All rights reserved.
//

import Foundation

class Util {
    static func getCurrentSeasonYear() -> Int {
        return max(Calendar.current.component(.year, from: Date()), 2020)
    }
}
