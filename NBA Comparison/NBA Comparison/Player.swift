//
//  Player.swift
//  NBA Comparison
//
//  Created by chuck on 7/24/20.
//  Copyright © 2020 AlexZ. All rights reserved.
//

import Foundation

class Player : RemoteEntity {
    let firstName: String
    let lastName: String
    let displayName: String
    let sortName: String
    weak var _team: Team?
    
    var team: Team {
        self._team!
    }

    init(remoteId: Int, firstName: String, lastName: String, displayName: String? = nil, sortName: String? = nil, team: Team) {
        self.firstName = firstName
        self.lastName = lastName
        self.displayName = displayName ?? firstName + " " + lastName
        self.sortName = sortName ?? lastName + ", " + firstName
        self._team = team
        super.init(remoteId: remoteId)
    }
}
