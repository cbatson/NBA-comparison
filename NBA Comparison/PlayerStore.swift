//
//  PlayerStore.swift
//  NBA Comparison
//
//  Created by chuck on 7/24/20.
//  Copyright © 2020 AlexZ. All rights reserved.
//

import SwiftUI
import Combine

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
            self.players = (self.players + players).sorted(by: { $0.sort_name < $1.sort_name })
        }
    }
}

struct PlayerStore_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
