//
//  Stats.swift
//  NBA Comparison
//
//  Created by chuck on 7/25/20.
//  Copyright © 2020 AlexZ. All rights reserved.
//

import Foundation

class StatInfo {
    var displayName : String
    
    init(displayName: String) {
        self.displayName = displayName
    }
    
    func format(value : Any) -> String {
        return "<unknown>"
    }
    
    func unformattable(value : Any) -> String {
        let typeString = String(describing: type(of: value))
        return "<unformattable \(typeString)>"
    }
}

enum Stats {
    case GAMES_PLAYED
    case MINUTES
    case FIELD_GOALS_MADE
    case FIELD_GOAL_ATTEMPTS
    case THREE_POINTERS_MADE
    case THREE_POINT_ATTEMPTS
    case FREE_THROWS_MADE
    case FREE_THROW_ATTEMPTS
    case OFFENSIVE_REBOUNDS
    case DEFENSIVE_REBOUNDS
    case REBOUNDS
    case ASSISTS
    case STEALS
    case BLOCKS
    case TURNOVERS
    case PERSONAL_FOULS
    case POINTS
    case FIELD_GOAL_PERCENTAGE
    case THREE_POINT_PERCENTAGE
    case FREE_THROW_PERCENTAGE
}

struct StatMap {
    class StringStat : StatInfo {
        override func format(value : Any) -> String {
            if let stringValue = value as? String {
                return stringValue
            }
            return unformattable(value: value)
        }
    }
    
    class IntStat : StatInfo {
        override func format(value : Any) -> String {
            if let intValue = value as? Int {
                return String(intValue)
            }
            return unformattable(value: value)
        }
    }
    
    class FloatStat : StatInfo {
        override func format(value : Any) -> String {
            if let numValue = value as? NSNumber {
                return String(format: "%.2f", numValue.floatValue)
            }
            return unformattable(value: value)
        }
    }
    
    class PercentStat : StatInfo {
        override func format(value : Any) -> String {
            if let numValue = value as? NSNumber {
                return String(format: "%.1f%%", numValue.floatValue * 100)
            }
            return unformattable(value: value)
        }
    }
    
    static func getStatInfo(stat : Stats) -> StatInfo {
        switch (stat) {
        case .GAMES_PLAYED: return IntStat(displayName: "Games Played")
        case .MINUTES: return StringStat(displayName: "Minutes Per Game")
        case .FIELD_GOALS_MADE: return FloatStat(displayName: "Field Goal Makes Per Game")
        case .FIELD_GOAL_ATTEMPTS: return FloatStat(displayName: "Field Goal Attempts Per Game")
        case .THREE_POINTERS_MADE: return FloatStat(displayName: "Three Point Makes Per Game")
        case .THREE_POINT_ATTEMPTS: return FloatStat(displayName: "Three Point Attempts Per Game")
        case .FREE_THROWS_MADE: return FloatStat(displayName: "Free Throw Makes Per Game")
        case .FREE_THROW_ATTEMPTS: return FloatStat(displayName: "Free Throw Attempts Per Game")
        case .OFFENSIVE_REBOUNDS: return FloatStat(displayName: "Offensive Rebounds Per Game")
        case .DEFENSIVE_REBOUNDS: return FloatStat(displayName: "Defensive Rebounds Per Game")
        case .REBOUNDS: return FloatStat(displayName: "Rebounds Per Game")
        case .ASSISTS: return FloatStat(displayName: "Assists Per Game")
        case .STEALS: return FloatStat(displayName: "Steals Per Game")
        case .BLOCKS: return FloatStat(displayName: "Blocks Per Game")
        case .TURNOVERS: return FloatStat(displayName: "Turnovers Per Game")
        case .PERSONAL_FOULS: return FloatStat(displayName: "Personal Fouls Per Game")
        case .POINTS: return FloatStat(displayName: "Points Per Game")
        case .FIELD_GOAL_PERCENTAGE: return PercentStat(displayName: "Field Goal Percentage")
        case .THREE_POINT_PERCENTAGE: return PercentStat(displayName: "Three Point Percentage")
        case .FREE_THROW_PERCENTAGE: return PercentStat(displayName: "Free Throw Percentage")
        }
    }
}

struct StatValue {
    var stat : Stats
    var info : StatInfo
    var value : Any

    var displayName: String {
        get {
            return info.displayName
        }
    }
    
    var displayValue : String {
        get {
            return info.format(value: value)
        }
    }
}
