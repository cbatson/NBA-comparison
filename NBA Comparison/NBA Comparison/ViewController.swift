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
    var urlString = "https://www.balldontlie.io/api/v1/players"
    //let baseURL = "https://www.balldontlie.io/api/v1/players"
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getData()
    }
    
    func searchPlayer(playerName: String) {
        //print(metadata.currentPage)
        //if (metadata.nextPage != TID_NULL) {
        urlString = "https://www.balldontlie.io/api/v1/players?search=\(playerName)"
        getData()
        //}
    }
    /*
    func changePage() {
        if (metadata.nextPage != nil) {
            if (urlString == ) {
                urlString = urlString + "?page=\(String(describing: metadata.nextPage))"
            }
            else {
                urlString = urlString + "&page="
            }
        }
    }
    */
    @IBOutlet weak var playerOneSearchBar: UISearchBar!
    @IBOutlet weak var playerOneTableView: UITableView!

   func getData() {
    let url = URL(string: urlString)!
    URLSession.shared.dataTask(with: url) { data,response,error in
                    if error==nil {
                        do {
                            let downloadedPlayers = try JSONDecoder().decode(Response.self, from: data!)
                            self.players = downloadedPlayers.data
                            self.metadata = downloadedPlayers.meta
                            //self.playerOneSearches = self.players
                            DispatchQueue.main.async {
                                self.playerOneTableView.reloadData()
                                //self.changePage(url: url)
                            }
                            } catch{
                                print("Json Error : \(error)")
                            }
                    }
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
    /*
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath, url:URL) {
        if (indexPath.row == players.count-1) {
            changePage()
        }
    }
        */
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            //playerOneSearches = []
            
            //if searchText == "" {
                //playerOneSearches = players
                //getData(url: url!)
            //}
            //else {
                //searchPlayer(playerName: searchText)
            //}
            
            let search = searchText.replacingOccurrences(of: " ", with: "%20")
            searchPlayer(playerName: search)
    
            self.playerOneTableView.reloadData()
        }
}
