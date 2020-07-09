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
    var metadata = Meta(totalPages: 0, currentPage: 0, nextPage: 0, perPage: 0, totalCount: 0)
    var playerOneSearches = [Datum]()
    var url = URL(string: "https://www.balldontlie.io/api/v1/players?page=60")
    //var pageNumber = 2

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getData(url: url!)
    }
    
    func changePage() {
        print(metadata.currentPage)
        if (metadata.nextPage != TID_NULL) {
            let url = URL(string: "https://www.balldontlie.io/api/v1/players?page=\(metadata.nextPage)")
            getData(url: url!)
        }
    }
    
    @IBOutlet weak var playerOneSearchBar: UISearchBar!
    @IBOutlet weak var playerOneTableView: UITableView!

    func getData(url:URL) {
        URLSession.shared.dataTask(with: url) { data,reponse,error in
                if error==nil {
                    do {
                        let downloadedPlayers = try JSONDecoder().decode(Response.self, from: data!)
                        self.players += downloadedPlayers.data
                        self.metadata = downloadedPlayers.meta
                        self.playerOneSearches = self.players
                        DispatchQueue.main.async {
                            self.playerOneTableView.reloadData()
                            self.changePage()
                        }
                        } catch{
                            print("Json Error : \(error)")
                        }
                    }
        }.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerOneSearches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = playerOneTableView.dequeueReusableCell(withIdentifier: "playerOneCell")!
        cell.textLabel?.text = playerOneSearches[indexPath.row].lastName.capitalized
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        playerOneSearches = []
        
        if searchText == "" {
            playerOneSearches = players
        }
        else {
            for player in players {
                if player.lastName.lowercased().contains(searchText.lowercased()) {
                    playerOneSearches.append(player)
                }
            }
        }
        self.playerOneTableView.reloadData()
    }
}
