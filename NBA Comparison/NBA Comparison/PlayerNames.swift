//
//  PlayerNames.swift
//  NBA Comparison
//
//  Created by Owner on 6/27/20.
//  Copyright © 2020 AlexZhou. All rights reserved.
//

import Foundation

// MARK: - Response
struct Response: Codable {
    let data: [Datum]
    let meta: Meta
}

// MARK: - Datum
struct Datum: Codable {
    let id: Int
    let firstName: String
    let heightFeet, heightInches: Int?
    let lastName, position: String
    let team: Team
    let weightPounds: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case heightFeet = "height_feet"
        case heightInches = "height_inches"
        case lastName = "last_name"
        case position, team
        case weightPounds = "weight_pounds"
    }
}

// MARK: - Team
struct Team: Codable {
    let id: Int
    let abbreviation, city: String
    let conference: Conference
    let division, fullName, name: String

    enum CodingKeys: String, CodingKey {
        case id, abbreviation, city, conference, division
        case fullName = "full_name"
        case name
    }
}

enum Conference: String, Codable {
    case east = "East"
    case west = "West"
}

// MARK: - Meta
struct Meta: Codable {
    let totalPages, currentPage, nextPage, perPage: Int
    let totalCount: Int

    enum CodingKeys: String, CodingKey {
        case totalPages = "total_pages"
        case currentPage = "current_page"
        case nextPage = "next_page"
        case perPage = "per_page"
        case totalCount = "total_count"
    }
}
/*struct Response: Codable{
    var response: Data
}
struct Data: Codable{
    var data: [PlayerInfo]
    var meta: MetaInfo
}
struct PlayerInfo: Codable{
    var id: Int
    var first_name: String
    var height_feet: Int?
    var height_inches: Int?
    var last_name: String
    var position: String
    var team: TeamInfo
    var weight_pounds: Int?
}
struct TeamInfo: Codable{
    var id: Int
    var abbreviation: String
    var city: String
    var conference: String
    var division: String
    var full_name: String
    var name: String
}
struct MetaInfo: Codable{
    var total_pages: Int
    var current_page: Int
    var next_page: Int
    var per_page: Int
    var total_count: Int
}
*/

