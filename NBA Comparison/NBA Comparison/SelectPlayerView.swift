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

    @ObservedObject var playerStore = (UIApplication.shared.delegate as! AppDelegate).playerStore

    var body: some View {
        VStack {
            SearchBar(text: $searchText, placeholder: "Search players")

            List {
                ForEach(self.playerStore.players.filter {
                    self.searchText.isEmpty ? true : $0.display_name.lowercased().contains(self.searchText.lowercased())
                }, id: \.self) { player in
                    NavigationLink(destination: self.getDestination(player:  player)) {
                        Text(player.display_name)
                    }
                }
            }
            .id(UUID())     // See https://www.hackingwithswift.com/articles/210/how-to-fix-slow-list-updates-in-swiftui
            .navigationBarTitle(Text("Select Player #\(playerNumber)"))
        }
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
    static var testPlayers = [
        Player(display_name: "Lebron James"),
        Player(display_name: "Michael Jordan")
    ]
    static var previews: some View {
        Group {
            SelectPlayerView()
            SelectPlayerView(playerNumber: 2)
        }
    }
}
