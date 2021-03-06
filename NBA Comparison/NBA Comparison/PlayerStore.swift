//
//  PlayerStore.swift
//  NBA Comparison
//
//  Created by chuck on 7/24/20.
//  Copyright © 2020 AlexZ. All rights reserved.
//

import SwiftUI

class PlayerStore : ObservableObject {
    var players: [Player] = []
    private var playerIds = Set<Int>()

    init(initPlayers : [Player] = []) {
        players = initPlayers
    }
    
    func reset() {
        players = []
    }
    
    func appendWithSort(playersToAppend: [Player]) -> Int {
        // Include only those players who are new to the playerIds set.
        let filteredPlayers = playersToAppend.filter { !playerIds.contains($0.remoteId) }
        // Update the playerIds set to include the new players.
        playerIds.formUnion(Set(playersToAppend.map { $0.remoteId }))
        // Combine the existing player with the new players and sort them.
        players = (players + filteredPlayers).sorted(by: { $0.sortName < $1.sortName })
        DispatchQueue.main.async {
            // Publishing needs to happen on the main thread.
            self.objectWillChange.send()
        }
        return players.count
    }
}
