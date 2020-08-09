//
//  SeasonAverages.swift
//  NBA Comparison
//
//  Created by chuck on 7/31/20.
//  Copyright © 2020 AlexZ. All rights reserved.
//

import Foundation

class SeasonAverages : RemoteEntity, ObservableObject {
    @Published var seasonYears: [Int] = []
    var stats: [Int: Dictionary<Stats, StatValue>] = [:]

    func loadAll(ballDontLie: BallDontLie) {
        // The API does not give a convenient way to determine which
        // seasons have season averages. So to load all season averages,
        // we start with the current year, and search backwards from there.
        if loadPhase == .idle {
            loadPhase = .searching
            loadSeason = Util.getCurrentSeasonYear()
            load(ballDontLie: ballDontLie)
        }
        else {
            // Note: By telling listeners that the season years have "changed,"
            // the comparison view knows to update its season year selection
            // from a year in the season year list.
            // Another approach to this issue could be to have the player
            // comparison check for any available season years and choose an
            // initial season year selection based on that.
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
    
    private func onStats(ballDontLie: BallDontLie, stats: [Dictionary<Stats, StatValue>]?, error: Error?) {
        guard let stats = stats, error == nil else {
            // TODO: Display error to user
            print("ERROR: could not load season average stats")
            return
        }
        
        guard stats.count > 0 else {
            // No stats returned.
            //print("DEBUG: player \(remoteId) no stats for year \(loadSeason)")
            if loadPhase == .searching && loadSeason > oldestYear {
                loadSeason -= 1
                load(ballDontLie: ballDontLie)
                return
            }
            loadPhase = .done
            return
        }
        var statsEntry = stats[0]
        
        guard let seasonValue = statsEntry[.SEASON] else {
            // No season value.
            print("DEBUG: player \(remoteId) no season value for year \(loadSeason)")
            loadPhase = .done
            return
        }

        let seasonYear = seasonValue.value as! Int
        loadPhase = .collecting
        statsEntry.removeValue(forKey: .SEASON)
        addStats(seasonYear: seasonYear, statDict: statsEntry)
        loadSeason -= 1     // continue and try the prior year
        load(ballDontLie: ballDontLie)
    }
    
    private func addStats(seasonYear: Int, statDict: Dictionary<Stats, StatValue>) {
        stats[seasonYear] = statDict
        let years = Array(Array(stats.keys).sorted().reversed())
        DispatchQueue.main.async {
            self.seasonYears = years
        }
    }
    
    private func load(ballDontLie: BallDontLie) {
        ballDontLie.loadSeasonAverages(season: loadSeason, playerIds: [remoteId]) { (stats, error) in
            self.onStats(ballDontLie: ballDontLie, stats: stats, error: error)
        }
    }

    private var loadSeason = 0
    private let oldestYear = 1990
    
    enum LoadPhase {
        case idle
        case searching
        case collecting
        case done
    }
    private var loadPhase = LoadPhase.idle
}
