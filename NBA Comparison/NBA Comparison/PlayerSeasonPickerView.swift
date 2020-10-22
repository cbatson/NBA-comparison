//
//  PlayerSeasonPickerView.swift
//  NBA Comparison
//
//  Created by chuck on 7/31/20.
//  Copyright © 2020 AlexZ. All rights reserved.
//

import SwiftUI

struct PlayerSeasonPickerView: View {
    var player: Player
    var headshot: AnyView
    var seasonYear: Binding<Int>

    @ObservedObject var seasonAverages: SeasonAverages

    @Environment(\.presentationMode) var presentation

    init(player: Player, headshot: AnyView, seasonYear: Binding<Int>) {
        self.player = player
        self.headshot = headshot
        self.seasonYear = seasonYear
        self.seasonAverages = player.seasonAverages
    }
    
    var body: some View {
        VStack {
            Button("X") {
                self.presentation.wrappedValue.dismiss()
            }.frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
            Spacer()
            Text("Select Season").font(.title)
            self.headshot.modifier(HeadshotModifier())
            Text(self.player.displayName).modifier(BioDataModifier())
            Text(self.player.team.displayName).modifier(BioDataModifier())
            Picker("Season", selection: seasonYear) {
                ForEach(seasonAverages.seasonYears, id: \.self) { year in
                    Text(SeasonYear.getDisplayString(year: year))
                }
            }.labelsHidden()
            Spacer()
        }.padding()
    }
}

struct PlayerSeasonPickerView_Previews: PreviewProvider {
    static let testTeam = Team(remoteId: -1, simpleName: "Test", fullName: "Test Team", abbreviatedName: "TT", city: "Test City", conference: "Test Conference", division: "Test Division")
    static var testPlayer = Player(remoteId: 14, firstName: "Lebron", lastName: "James", team: testTeam)
    static var testHeadshot = PlayerHeadshotMap.getHeadshotFromId(id: testPlayer.remoteId)
    @State static var year = 2020
    static var previews: some View {
        PlayerSeasonPickerView(player: testPlayer, headshot: testHeadshot, seasonYear: $year)
    }
}
