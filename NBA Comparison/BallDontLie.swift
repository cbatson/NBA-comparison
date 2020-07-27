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
    
    func populateAllPlayers(playerStore: PlayerStore) {
        playerStore.reset()
        var pageNumber = 0
        var completionHandler : (([Player]?, Dictionary<String, AnyObject>?, Error?) -> Void)!
        completionHandler = {(players, meta, error) in
            guard let players = players, let meta = meta, error == nil else {
                // TODO: Report an error to the user
                return
            }
            //print(players)
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
    
    func loadPlayerPage(pageNumber: Int, completionHandler: @escaping ([Player]?, Dictionary<String, AnyObject>?, Error?) -> Void) {
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
                
                var players: [Player] = []
                for playerEntry in playerDict {
                    let first_name = playerEntry["first_name"] as! String
                    let last_name = playerEntry["last_name"] as! String
                    let player = Player(
                        remoteId: playerEntry["id"] as! Int,
                        first_name: first_name,
                        last_name: last_name,
                        display_name: first_name + " " + last_name,
                        sort_name: last_name + ", " + first_name)
                    players.append(player)
                }
                completionHandler(players, metaDict, nil)
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
