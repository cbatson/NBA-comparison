//
//  PlayerComparisonView.swift
//  NBA Comparison
//
//  Created by chuck on 7/25/20.
//  Copyright © 2020 AlexZ. All rights reserved.
//

import SwiftUI

struct IndividualStat : Identifiable {
    var id = UUID()
    var statName : String
}

struct PlayerComparisonView: View {
    var player1 : Player
    var player2 : Player
    
    @State var player1SeasonAverages = Dictionary<Stats, StatValue>()
    @State var player2SeasonAverages = Dictionary<Stats, StatValue>()

    // TODO: convert to use generic data retrieval mechanism
    let ballDontLie = (UIApplication.shared.delegate as! AppDelegate).ballDontLie

    var body: some View {
        //Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        VStack {
            // Static Player View
            HStack {
                Text(player1.display_name)
                    .frame(maxWidth: .infinity, alignment: .center)
                Text("Info")
                    .frame(maxWidth: .infinity, alignment: .center)
                Text(player2.display_name)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            
            // Stats Table
            List {
                ForEach(commonStats()) { statRow in
                    HStack {
                        Text(statRow.player1Value.displayValue).frame(maxWidth: .infinity)
                        Text(statRow.displayName).frame(maxWidth: .infinity)
                        Text(statRow.player2Value.displayValue).frame(maxWidth: .infinity)
                    }
                }
            }
        }.onAppear {
            self.loadSeasonAverages()
        }
    }
    
    struct StatRow : Identifiable {
        var id = UUID()
        var player1Value : StatValue
        var player2Value : StatValue
        
        var displayName : String {
            get {
                return player1Value.displayName
            }
        }
    }
    
    func commonStats() -> [StatRow] {
        let commonStats = Set(player1SeasonAverages.keys).intersection(player2SeasonAverages.keys)
        return Array(commonStats).map({
            let player1Value = player1SeasonAverages[$0]!
            let player2Value = player2SeasonAverages[$0]!
            return StatRow(player1Value: player1Value, player2Value: player2Value)
        })
    }
    
    func loadSeasonAverages() {
        let playerIds = [player1.remoteId, player2.remoteId]
        ballDontLie.loadSeasonAverages(season: 2018, playerIds: playerIds, completionHandler: { (stats, error) in
            guard let stats = stats, error == nil else {
                // TODO: Display error to user
                print("ERROR: could not load season average stats")
                return
            }
            DispatchQueue.main.async {
                // TODO: Handle one or both players not having stats for the season
                self.player1SeasonAverages = stats[0]
                self.player2SeasonAverages = stats[1]
            }
        })
    }
}

struct PlayerComparisonView_Previews: PreviewProvider {
    static var previews: some View {
        //PlayerComparisonView()
        Text("hi")
    }
}
