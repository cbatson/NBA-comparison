//
//  PlayerComparisonView.swift
//  NBA Comparison
//
//  Created by chuck on 7/25/20.
//  Copyright © 2020 AlexZ. All rights reserved.
//

import SwiftUI

struct PlayerComparisonView: View {
    var player1: Player
    var player2: Player
    
    @State private var playerSeasonSheetDisplay = false
    @State private var playerSeasonSheetWhich = 0

    @ObservedObject var player1SeasonAverages: SeasonAverages
    @ObservedObject var player2SeasonAverages: SeasonAverages
    @ObservedObject var player1Season: SeasonYear
    @ObservedObject var player2Season: SeasonYear
    
    init(player1: Player, player2: Player) {
        self.player1 = player1
        self.player2 = player2
        self.player1SeasonAverages = player1.seasonAverages
        self.player2SeasonAverages = player2.seasonAverages
        self.player1Season = SeasonYear(seasonAverages: player1.seasonAverages)
        self.player2Season = SeasonYear(seasonAverages: player2.seasonAverages)
    }
    
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
                    Text(SeasonYear.getDisplayString(year: player1Season.year))
                }).modifier(BioDataModifier())

                Button(action: {
                    self.playerSeasonSheetWhich = 2
                    self.playerSeasonSheetDisplay = true
                }, label: {
                    Text(SeasonYear.getDisplayString(year: player2Season.year))
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
                        Text(statRow.player1DisplayValue).modifier(StatValueModifier())
                        Text(statRow.displayName).modifier(StatNameModifier())
                        Text(statRow.player2DisplayValue).modifier(StatValueModifier())
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
        let year = self.playerSeasonSheetWhich == 1 ? self.$player1Season.year : self.$player2Season.year
        return PlayerSeasonPickerView(player: player, headshot: headshot, seasonYear: year)
    }
    
    struct StatRow : Identifiable {
        var id = UUID()
        var player1Value: StatValue?
        var player2Value: StatValue?
        
        var displayName: String {
            get {
                if player1Value != nil {
                    return player1Value!.displayName
                }
                if player2Value != nil {
                    return player2Value!.displayName
                }
                return "<unknown>"
            }
        }
        
        var player1DisplayValue: String {
            player1Value == nil ? "n/a" : player1Value!.displayValue
        }
        
        var player2DisplayValue: String {
            player2Value == nil ? "n/a" : player2Value!.displayValue
        }
    }
    
    func commonStats() -> [StatRow] {
        let player1Stats = player1SeasonAverages.stats[player1Season.year]
        let player1Set = player1Stats == nil ? Set() : Set(player1Stats!.keys)
        let player2Stats = player2SeasonAverages.stats[player2Season.year]
        let player2Set = player2Stats == nil ? Set() : Set(player2Stats!.keys)
        let commonStats = Array(player1Set.union(player2Set))
        let sortedStates = commonStats.sorted() { $0.rawValue < $1.rawValue }
        return sortedStates.map({
            let player1Value = player1Stats == nil ? nil : player1Stats![$0]
            let player2Value = player2Stats == nil ? nil : player2Stats![$0]
            return StatRow(player1Value: player1Value, player2Value: player2Value)
        })
    }
    
    func loadSeasonAverages() {
        player1.loadSeasonAverages(ballDontLie: AppData.instance.ballDontLie)
        player2.loadSeasonAverages(ballDontLie: AppData.instance.ballDontLie)
    }
}

struct PlayerComparisonView_Previews: PreviewProvider {
    static var previews: some View {
        //PlayerComparisonView()
        Text("hi")
    }
}
