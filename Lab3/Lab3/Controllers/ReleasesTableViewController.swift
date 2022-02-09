//
//  ReleasesTableViewController.swift
//  Lab3
//
//  Created by Ashlyn Duy on 2/8/22.
//

import UIKit

class ReleasesTableViewController: UITableViewController {
    
    var gameList = [String]()
    var selectedCategory = 0
    var loader = Loader()
    var searchController = UISearchController()
    let resultsController = SearchGamesTableViewController()
    
    @IBAction func unwindSegue (_ segue: UIStoryboardSegue) {
        if segue.identifier == "done" {
            if let source = segue.source as? AddGameViewController {
                if !source.addGame.isEmpty {
                    let newRelease = Release(title: source.addGame, releaseDate: source.addDate)
                    loader.addGame(selectedCategory, newRelease)
                    resultsController.allGames = gameList
                    gameList.append(source.addGame)
                    tableView.reloadData()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source
    override func viewWillAppear(_ animated: Bool) {
        gameList = loader.getGamesForCategory(selectedCategory)
        
        resultsController.category = selectedCategory
        resultsController.loader = self.loader
        searchController = UISearchController(searchResultsController: resultsController)
        
        searchController.searchBar.placeholder = "Enter a game title"
        searchController.searchBar.sizeToFit()
        
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.searchResultsUpdater = resultsController
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gameList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "releaseCell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = gameList[indexPath.row]
        cell.contentConfiguration = config

        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            gameList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            loader.deleteGame(selectedCategory, indexPath.row)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
