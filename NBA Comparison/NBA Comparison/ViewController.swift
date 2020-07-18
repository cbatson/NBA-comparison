//
//  ViewController.swift
//  NBA Comparison
//
//  Created by Owner on 4/10/20.
//  Copyright © 2020 AlexZhou. All rights reserved.
//
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var players = [Datum]()
    var metadata = Meta(totalPages: 0, currentPage: 0, perPage: 0, nextPage: 0, totalCount: 0)
    //var playerOneSearches = [Datum]()
    var currentUrl = String()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //getData()
    }
    
    func searchPlayer(playerName: String) {
        //print(metadata.currentPage)
        //if (metadata.nextPage != TID_NULL) {
        let urlString = "https://www.balldontlie.io/api/v1/players?search=\(playerName)"
        getData(urlString: urlString)
        //}
    }
    
    
    func getAllPlayers() {
        if (metadata.nextPage != nil) {
            if (currentUrl.contains("page")) {
                let regex = try! NSRegularExpression(pattern: "[0-9]+", options: NSRegularExpression.Options.caseInsensitive)
                let range = NSMakeRange(0, currentUrl.count)
                let urlString = regex.stringByReplacingMatches(in: currentUrl, options: [], range: range, withTemplate: "\(metadata.nextPage!)")
                getData(urlString: urlString)
            }
            else {
                let urlString = currentUrl + "&page=\(metadata.nextPage!)"
                getData(urlString: urlString)
            }
        }
    }
    
    @IBOutlet weak var playerOneSearchBar: UISearchBar!
    @IBOutlet weak var playerOneTableView: UITableView!

    func getData(urlString: String) {
        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url) { data,response,error in
                    if error==nil {
                        do {
                            let downloadedPlayers = try JSONDecoder().decode(Response.self, from: data!)
                            if urlString.contains("page"){
                                self.players += downloadedPlayers.data
                            }
                            self.players = downloadedPlayers.data
                            self.metadata = downloadedPlayers.meta
                            //self.playerOneSearches = self.players
                            DispatchQueue.main.async {
                                self.playerOneTableView.reloadData()
                                //self.getAllPlayers()
                            }
                            } catch{
                                print("Json Error : \(error)")
                            }
                    }
            self.currentUrl = urlString
            print (self.currentUrl)
            }.resume()
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            //return playerOneSearches.count
            return players.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = playerOneTableView.dequeueReusableCell(withIdentifier: "playerOneCell")!
            //cell.textLabel?.text = playerOneSearches[indexPath.row].firstName.capitalized + " " + playerOneSearches[indexPath.row].lastName.capitalized
            cell.textLabel?.text = players[indexPath.row].firstName.capitalized + " " + players[indexPath.row].lastName.capitalized
            return cell
        }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row == players.count-1) {
            getAllPlayers()
        }
    }

    
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            //playerOneSearches = []
            
            //if searchText == "" {
                //playerOneSearches = players
                //getData(url: url!)
            //}
            //else {
                //searchPlayer(playerName: searchText)
            //}
            if (searchText != ""){
                let search = searchText.replacingOccurrences(of: " ", with: "%20")
                print (search)
                searchPlayer(playerName: search)
            }
    
            //self.playerOneTableView.reloadData()
        }
}
