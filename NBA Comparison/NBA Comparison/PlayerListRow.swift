//
//  PlayerListRow.swift
//  NBA Comparison
//
//  Created by chuck on 7/30/20.
//  Copyright © 2020 AlexZ. All rights reserved.
//

import SwiftUI

struct PlayerListRow: View {
    var player: Player
    var showHeadshot = true
    var headshotView: AnyView {
        PlayerHeadshotMap.getHeadshotFromId(id: player.remoteId)
    }
    
    var body: some View {
        HStack {
            if showHeadshot {
                headshotView
                    .scaledToFit()
                    .frame(width: 40, height: 40)
            }
            VStack(alignment: .leading) {
                Text(player.displayName)
                Text(player.team.displayName)
                    .font(.footnote)
            }
        }
    }
}

struct PlayerListRow_Previews: PreviewProvider {
    static let testTeam = Team(remoteId: 14, simpleName: "Test", fullName: "Test Team", abbreviatedName: "TT", city: "Test City", conference: "Test Conference", division: "Test Division")
    static var testPlayer = Player(remoteId: -1, firstName: "Lebron", lastName: "James", team: testTeam)
    static var previews: some View {
        PlayerListRow(player: testPlayer)
    }
}
