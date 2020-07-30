//
//  PlayerStore.swift
//  NBA Comparison
//
//  Created by chuck on 7/24/20.
//  Copyright © 2020 AlexZ. All rights reserved.
//

import SwiftUI

class PlayerStore : ObservableObject {
    @Published var players: [Player] = []

    init(initPlayers : [Player] = []) {
        players = initPlayers
    }
    
    func reset() {
        players = []
    }
    
    func appendWithSort(players: [Player]) {
        DispatchQueue.main.async {
            // Publishing needs to happen on the main thread.
            self.players = (self.players + players).sorted(by: { $0.sortName < $1.sortName })
        }
    }
}
