//
//  Team.swift
//  NBA Comparison
//
//  Created by chuck on 7/29/20.
//  Copyright © 2020 AlexZ. All rights reserved.
//

import Foundation

class Team : RemoteEntity {
    let simpleName: String
    let fullName: String
    let abbreviatedName: String
    let city: String
    let conference: String
    let division: String
    let displayName: String
    let sortName: String
    
    init(remoteId: Int, simpleName: String, fullName: String, abbreviatedName: String, city: String, conference: String, division: String) {
        self.simpleName = simpleName
        self.fullName = fullName
        self.abbreviatedName = abbreviatedName
        self.city = city
        self.conference = conference
        self.division = division
        self.displayName = fullName
        self.sortName = fullName
        super.init(remoteId: remoteId)
    }
}
