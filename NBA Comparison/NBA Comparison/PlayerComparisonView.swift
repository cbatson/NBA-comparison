//
//  PlayerComparisonView.swift
//  NBA Comparison
//
//  Created by chuck on 7/25/20.
//  Copyright © 2020 AlexZ. All rights reserved.
//

import SwiftUI

struct PlayerComparisonView: View {
    var player1 : Player
    var player2 : Player
    
    @State private var player1SeasonAverages = Dictionary<Stats, StatValue>()
    @State private var player2SeasonAverages = Dictionary<Stats, StatValue>()

    @State private var player1Season = 2018
    @State private var player2Season = 2018
    
    @State private var playerSeasonSheetDisplay = false
    @State private var playerSeasonSheetWhich = 0

    //@Environment(\.presentationMode) var presentation
    
    struct StatValueModifier: ViewModifier {
        func body(content: Content) -> some View {
            content
                .frame(width: 100, alignment: .center)
                .multilineTextAlignment(.center)
        }
    }
    
    struct StatNameModifier: ViewModifier {
        func body(content: Content) -> some View {
            content
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
        }
    }
    
    var headshot1 : AnyView {
        PlayerHeadshotMap.getHeadshotFromId(id: player1.remoteId)
            
    }
    var headshot2 : AnyView {
        PlayerHeadshotMap.getHeadshotFromId(id: player2.remoteId)
    }
    
    // Static Player View
    var playerHeader : some View {
        Group {
            // Static Player View
            HStack {
                headshot1.modifier(HeadshotModifier())
                //Text("").modifier(StatNameModifier())
                headshot2.modifier(HeadshotModifier())
            }.frame(alignment: .bottom)
            HStack {
                Text(player1.displayName).modifier(BioDataModifier())
                //Text("").modifier(StatNameModifier())
                Text(player2.displayName).modifier(BioDataModifier())
            }
            HStack {
                Text(player1.team.displayName).modifier(BioDataModifier())
                Text(player2.team.displayName).modifier(BioDataModifier())
            }
            HStack {
                Button(action: {
                    self.playerSeasonSheetWhich = 1
                    self.playerSeasonSheetDisplay = true
                }, label: {
                    Text(String(player1Season))
                }).modifier(BioDataModifier())

                Button(action: {
                    self.playerSeasonSheetWhich = 2
                    self.playerSeasonSheetDisplay = true
                }, label: {
                    Text(String(player2Season))
                }).modifier(BioDataModifier())
            }
        }
    }
    
    var body: some View {
        VStack {
            playerHeader

            // Stats Table
            List {
                ForEach(commonStats()) { statRow in
                    HStack {
                        Text(statRow.player1Value.displayValue).modifier(StatValueModifier())
                        Text(statRow.displayName).modifier(StatNameModifier())
                        Text(statRow.player2Value.displayValue).modifier(StatValueModifier())
                    }
                }
            }
        }
        .onAppear {
            self.loadSeasonAverages()
        }
        .navigationBarTitle("", displayMode: .inline)
        //.navigationBarHidden(true)
        .sheet(isPresented: $playerSeasonSheetDisplay) {
            self.getSeasonSelectSheet()
        }
    }
    
    func getSeasonSelectSheet() -> PlayerSeasonPickerView {
        let player = self.playerSeasonSheetWhich == 1 ? self.player1 : self.player2
        let headshot = self.playerSeasonSheetWhich == 1 ? self.headshot1 : self.headshot2
        let year = self.playerSeasonSheetWhich == 1 ? self.$player1Season : self.$player2Season
        return PlayerSeasonPickerView(player: player, headshot: headshot, seasonYear: year)
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
        let commonStats = Array(Set(player1SeasonAverages.keys).intersection(player2SeasonAverages.keys))
        let sortedStates = commonStats.sorted() { $0.rawValue < $1.rawValue }
        return sortedStates.map({
            let player1Value = player1SeasonAverages[$0]!
            let player2Value = player2SeasonAverages[$0]!
            return StatRow(player1Value: player1Value, player2Value: player2Value)
        })
    }
    
    func loadSeasonAverages() {
        if false {
            player1.loadSeasonAverages(ballDontLie: AppData.instance.ballDontLie)
            player2.loadSeasonAverages(ballDontLie: AppData.instance.ballDontLie)
        }
        else {
            let playerIds = [player1.remoteId, player2.remoteId]
            // TODO: convert to use generic data retrieval mechanism
            AppData.instance.ballDontLie.loadSeasonAverages(season: 2018, playerIds: playerIds, completionHandler: { (stats, error) in
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
}

struct PlayerComparisonView_Previews: PreviewProvider {
    static var previews: some View {
        //PlayerComparisonView()
        Text("hi")
    }
}
