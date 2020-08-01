//
//  AppData.swift
//  NBA Comparison
//
//  Created by chuck on 7/29/20.
//  Copyright © 2020 AlexZ. All rights reserved.
//

import Foundation

class AppData : ObservableObject {
    let playerStore = PlayerStore()
    let teamStore = TeamStore()
    let ballDontLie = BallDontLie()
    
    static var _instance: AppData?
    
    static var instance: AppData {
        _instance!
    }
}
