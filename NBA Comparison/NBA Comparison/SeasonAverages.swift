//
//  SeasonAverages.swift
//  NBA Comparison
//
//  Created by chuck on 7/31/20.
//  Copyright © 2020 AlexZ. All rights reserved.
//

import Foundation

class SeasonAverages : RemoteEntity {
    func getSeasonYears() -> [Int] {
        return Array(stats.keys).sorted()
    }
    
    func loadAll(ballDontLie: BallDontLie) {
        // The API does not give a convenient way to determine which
        // seasons have season averages. So to load all season averages,
        // we start with the current year, and search backwards from there.
        if loadPhase == .idle {
            loadPhase = .searching
            loadSeason = max(Calendar.current.component(.year, from: Date()), 2020)
            load(ballDontLie: ballDontLie)
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
            if loadPhase == .searching && loadSeason > oldestYear {
                loadSeason -= 1
                load(ballDontLie: ballDontLie)
                return
            }
            loadPhase = .done
            return
        }
        let statsEntry = stats[0]
        
        guard let seasonValue = statsEntry[.SEASON] else {
            // No season value.
            loadPhase = .done
            return
        }

        let seasonYear = seasonValue.value as! Int
        loadPhase = .collecting
        print("seasonYear is \(seasonYear)")
        self.stats[seasonYear] = statsEntry
        loadSeason -= 1
        load(ballDontLie: ballDontLie)
    }
    
    private func load(ballDontLie: BallDontLie) {
        ballDontLie.loadSeasonAverages(season: loadSeason, playerIds: [remoteId]) { (stats, error) in
            self.onStats(ballDontLie: ballDontLie, stats: stats, error: error)
        }
    }

    private var stats: [Int: Dictionary<Stats, StatValue>] = [:]
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
