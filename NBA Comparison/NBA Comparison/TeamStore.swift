//
//  TeamStore.swift
//  NBA Comparison
//
//  Created by chuck on 7/24/20.
//  Copyright © 2020 AlexZ. All rights reserved.
//

import SwiftUI

class TeamStore : ObservableObject {
    @Published var teams: [Team] = []
    var teamsIndex: [Int: Team] = [:]

    init(initTeams : [Team] = []) {
        teams = initTeams
        indexTeams(teams: teams)
    }
    
    func reset() {
        teams.removeAll()
        teamsIndex.removeAll()
    }
    
    func appendWithSort(teams: [Team]) {
        indexTeams(teams: teams)
        DispatchQueue.main.async {
            // Publishing needs to happen on the main thread.
            self.teams = (self.teams + teams).sorted(by: { $0.sortName < $1.sortName })
        }
    }
    
    private func indexTeams(teams: [Team]) {
        for team in teams {
            // TODO: Check for existing entry with this id.
            teamsIndex[team.remoteId] = team
        }
    }
    
    func findOrCreateTeamFromJson(teamDict: Dictionary<String, AnyObject>, deserializer: (Dictionary<String, AnyObject>) -> Team) -> Team
    {
        let teamId = teamDict["id"] as! Int
        if let foundTeam = teamsIndex[teamId] {
            return foundTeam
        }
        let createdTeam = deserializer(teamDict)
        appendWithSort(teams: [createdTeam])
        return createdTeam
    }
}
