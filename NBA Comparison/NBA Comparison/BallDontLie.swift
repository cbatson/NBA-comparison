//
//  BallDontLie.swift
//  NBA Comparison
//
//  Created by chuck on 7/24/20.
//  Copyright © 2020 AlexZ. All rights reserved.
//

import Foundation
import UIKit

class BallDontLie {
    let baseUrl = "https://www.balldontlie.io/api/v1/"
    
    func populateAllPlayers(playerStore: PlayerStore, teamStore: TeamStore) {
        playerStore.reset()
        var pageNumber = 0
        var completionHandler : (([Dictionary<String, AnyObject>]?, Dictionary<String, AnyObject>?, Error?) -> Void)!
        completionHandler = {(playerDicts, meta, error) in
            guard let playerDicts = playerDicts, let meta = meta, error == nil else {
                // TODO: Report an error to the user
                return
            }
            //print(playerDicts)
            let players = playerDicts.map() { (playerDict) in
                self.processJsonPlayer(playerDict: playerDict, teamStore: teamStore)
            }
            playerStore.appendWithSort(players: players)
            pageNumber += 1
            let total_pages = meta["total_pages"] as! Int
            if (pageNumber <= total_pages) {
                // Commented out for testing
                //self.loadPlayerPage(pageNumber: pageNumber, completionHandler: completionHandler)
            }
        }
        loadPlayerPage(pageNumber: 0, completionHandler: completionHandler)
    }
    
    func processJsonPlayer(playerDict: Dictionary<String, AnyObject>, teamStore: TeamStore) -> Player {
        // First find/create team
        let teamDict = playerDict["team"] as! Dictionary<String, AnyObject>
        let team = teamStore.findOrCreateTeamFromJson(teamDict: teamDict) { (teamDict) in
            return Team(
                remoteId: teamDict["id"] as! Int,
                simpleName: teamDict["name"] as! String,
                fullName: teamDict["full_name"] as! String,
                abbreviatedName: teamDict["abbreviation"] as! String,
                city: teamDict["city"] as! String,
                conference: teamDict["conference"] as! String,
                division: teamDict["division"] as! String)
        }

        // Instantiate Player object
        let first_name = playerDict["first_name"] as! String
        let last_name = playerDict["last_name"] as! String
        let player = Player(
            remoteId: playerDict["id"] as! Int,
            firstName: first_name,
            lastName: last_name,
            team: team)
        return player
    }
    
    func loadPlayerPage(pageNumber: Int, completionHandler: @escaping ([Dictionary<String, AnyObject>]?, Dictionary<String, AnyObject>?, Error?) -> Void) {
        print("DEBUG: Loading page number \(pageNumber)")
        let urlString = baseUrl + "players?per_page=100&page=\(pageNumber)"
        jsonFromUrl(urlString: urlString, jsonCompletionHandler: {(data, error) in
            guard let data = data, error == nil else {
                completionHandler(nil, nil, error)
                return
            }
            //print(data)
            do {
                let json = try JSONSerialization.jsonObject(with: data) as! Dictionary<String, AnyObject>
                let playerDict = json["data"] as! [Dictionary<String, AnyObject>]
                let metaDict = json["meta"] as! Dictionary<String, AnyObject>
                completionHandler(playerDict, metaDict, nil)
            }
            catch {
                completionHandler(nil, nil, error)
            }
        })
    }
    
    static let seasonAverageStats = [
        "games_played": Stats.GAMES_PLAYED,
        "min": Stats.MINUTES,
        "fgm": Stats.FIELD_GOALS_MADE,
        "fga": Stats.FIELD_GOAL_ATTEMPTS,
        "fg3m": Stats.THREE_POINTERS_MADE,
        "fg3a": Stats.THREE_POINT_ATTEMPTS,
        "ftm": Stats.FREE_THROWS_MADE,
        "fta": Stats.FREE_THROW_ATTEMPTS,
        "oreb": Stats.OFFENSIVE_REBOUNDS,
        "dreb": Stats.DEFENSIVE_REBOUNDS,
        "reb": Stats.REBOUNDS,
        "ast": Stats.ASSISTS,
        "stl": Stats.STEALS,
        "blk": Stats.BLOCKS,
        "turnover": Stats.TURNOVERS,
        "pf": Stats.PERSONAL_FOULS,
        "pts": Stats.POINTS,
        "fg_pct": Stats.FIELD_GOAL_PERCENTAGE,
        "fg3_pct": Stats.THREE_POINT_PERCENTAGE,
        "ft_pct": Stats.FREE_THROW_PERCENTAGE,
    ]
    
    func loadSeasonAverages(season: Int, playerIds : [Int], completionHandler: @escaping ([Dictionary<Stats, StatValue>]?, Error?) -> Void) {
        let urlArgs = playerIds.map { "player_ids[]=\($0)" }
        let urlString = baseUrl + "season_averages?season=\(season)&\(urlArgs.joined(separator: "&"))"
        jsonFromUrl(urlString: urlString, jsonCompletionHandler: {(data, error) in
            guard let data = data, error == nil else {
                completionHandler(nil, error)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data) as! Dictionary<String, AnyObject>
                let dataDict = json["data"] as! [Dictionary<String, AnyObject>]

                var result : [Dictionary<Stats, StatValue>] = []
                for playerEntry in dataDict {
                    var outDict = Dictionary<Stats, StatValue>()
                    for statEntry in playerEntry {
                        if let statEnum = Self.seasonAverageStats[statEntry.key] {
                            // It's a recognized stat
                            let statInfo = StatMap.getStatInfo(stat: statEnum)
                            let statValue = StatValue(stat: statEnum, info: statInfo, value: statEntry.value)
                            outDict[statEnum] = statValue
                        }
                    }
                    result.append(outDict)
                }
                completionHandler(result, nil)
            }
            catch {
                completionHandler(nil, error)
            }
        })
    }
    
    func jsonFromUrl(urlString: String, jsonCompletionHandler: @escaping (Data?, Error?) -> Void) {
        print("DEBUG: Fetching from \(urlString)")
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else {
                print("ERROR: \(error!.localizedDescription)")
                jsonCompletionHandler(nil, error)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("ERROR: invalid HTTP response")
                jsonCompletionHandler(nil, error)
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("ERROR: HTTP response code \(httpResponse.statusCode)")
                jsonCompletionHandler(nil, error)
                return
            }
            
            //print("DEBUG: Response was: \(data)")
            jsonCompletionHandler(data, nil)
        }).resume()
    }
}
