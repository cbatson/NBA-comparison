//
//  SelectPlayerView.swift
//  NBA Comparison
//
//  Created by chuck on 7/24/20.
//  Copyright © 2020 AlexZ. All rights reserved.
//

import SwiftUI

struct SelectPlayerView: View {
    var playerNumber = 1
    var playersOfInterest : [Player] = []

    @State private var searchText : String = ""

    @State private var splashDisplay = false

    @ObservedObject var playerStore = AppData.instance.playerStore

    var body: some View {
        VStack {
            SearchBar(text: $searchText, placeholder: "Search players")

            List {
                ForEach(self.playerStore.players.filter {
                    self.searchText.isEmpty ? true : $0.displayName.lowercased().contains(self.searchText.lowercased())
                }, id: \.self) { player in
                    NavigationLink(destination: self.getDestination(player:  player)) {
                        PlayerListRow(player: player)
                    }
                }
            }
            .id(UUID())     // See https://www.hackingwithswift.com/articles/210/how-to-fix-slow-list-updates-in-swiftui
            .navigationBarTitle(Text("Select Player #\(playerNumber)"))
        }
        .onAppear {
            // Only show the splash screen over the first player selection.
            // Also make sure to only show it once.
            if (self.playerNumber == 1 && AppData.instance.shouldDisplaySplash) {
                AppData.instance.shouldDisplaySplash = false
                self.splashDisplay = true
            }
        }
        .sheet(isPresented: $splashDisplay) {
            self.getSplashSheet()
        }
    }
    
    func getSplashSheet() -> SplashView {
        return SplashView()
    }
    
    func getDestination(player : Player) -> AnyView {
        if (playerNumber < 2) {
            // Next page is a player selection
            return AnyView(SelectPlayerView(playerNumber: self.playerNumber + 1, playersOfInterest: self.playersOfInterest + [player]))
        }
        else {
            // Next page is the player comparison
            return AnyView(PlayerComparisonView(player1: self.playersOfInterest[0], player2: player))
        }
    }
 }

struct SelectPlayerView_Previews: PreviewProvider {
    static let testTeam = Team(remoteId: -1, simpleName: "Test", fullName: "Test Team", abbreviatedName: "TT", city: "Test City", conference: "Test Conference", division: "Test Division")
    static var testPlayers = [
        Player(remoteId: -1, firstName: "Lebron", lastName: "James", team: testTeam),
        Player(remoteId: -1, firstName: "Michael", lastName: "Jordan", team: testTeam)
    ]
    static var previews: some View {
        Group {
            SelectPlayerView()
            SelectPlayerView(playerNumber: 2)
        }
    }
}
