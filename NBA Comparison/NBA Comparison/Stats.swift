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
        return  String(describing: type(of: value))
    }
}

enum Stats {
    case GAMES_PLAYED
    case MIN
    case FGM
    case FGA
    case FG3M
    case FG3A
    case FTM
    case FTA
    case OREB
    case DREB
    case REB
    case AST
    case STL
    case BLK
    case TURNOVER
    case PF
    case PTS
    case FG_PCT
    case FG3_PCT
    case FT_PCT
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
        case .MIN: return StringStat(displayName: "Minutes Played")
        case .FGM: return FloatStat(displayName: "FGM")
        case .FGA: return FloatStat(displayName: "FGA")
        case .FG3M: return FloatStat(displayName: "FG3M")
        case .FG3A: return FloatStat(displayName: "FG3A")
        case .FTM: return FloatStat(displayName: "FTM")
        case .FTA: return FloatStat(displayName: "FTA")
        case .OREB: return FloatStat(displayName: "OREB")
        case .DREB: return FloatStat(displayName: "DREB")
        case .REB: return FloatStat(displayName: "REB")
        case .AST: return FloatStat(displayName: "AST")
        case .STL: return FloatStat(displayName: "STL")
        case .BLK: return FloatStat(displayName: "BLK")
        case .TURNOVER: return FloatStat(displayName: "TURNOVER")
        case .PF: return FloatStat(displayName: "PF")
        case .PTS: return FloatStat(displayName: "PTS")
        case .FG_PCT: return PercentStat(displayName: "FG_PCT")
        case .FG3_PCT: return PercentStat(displayName: "FG3_PCT")
        case .FT_PCT: return PercentStat(displayName: "FT_PCT")
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
