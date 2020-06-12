//
//  ViewController.swift
//  NBA Comparison
//
//  Created by Owner on 4/10/20.
//  Copyright © 2020 AlexZhou. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let url = "https://www.balldontlie.io/api/v1/players"
        getData(from: url)
        print(playerArray)
    }
    
    @IBOutlet weak var playerOneSearchBar: UISearchBar!
    @IBOutlet weak var playerOneTableView: UITableView!
    
    var searchPlayerOne = [String]()
    var searchingPlayerOne = false
    
    func getData(from url:String){
            
        //Get Raw Data
            let task = URLSession.shared.dataTask(with: URL(string: url)!,completionHandler:
                {data,reponse,error in
                guard let data = data, error == nil else{
                    print("something went wrong")
                    return
                }
                    
        //Get Decoded Data (extract data)
                var result:Response?
                do {
                    result = try JSONDecoder().decode(Response.self, from:data)
                }
                 catch {
                    print("failed to convert")
                }
                
                guard let json = result else{
                    return
                }
                
        //Print Out Data
                    var playerArray = [String]()
                    for name in json.data {
                        playerArray.append(name.lastName)
                    }
                    print(playerArray)
            })
            task.resume()
        }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchingPlayerOne{
            return searchPlayerOne.count
        } else{
            return playerArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerOneCell")
        if searchingPlayerOne{
            cell?.textLabel?.text = searchPlayerOne[indexPath.row]
        }
        else{
            cell?.textLabel?.text = playerArray[indexPath.row]
        }
        return cell!
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchPlayerOne = playerArray.filter({$0.prefix(searchText.count)==searchText})
        searchingPlayerOne = true
        playerOneTableView.reloadData()
    }
    
}


        //define data format so that json can match
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
