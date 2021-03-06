//
//  TypesAbilitiesMovesVC.swift
//  PokemonApp
//
//  Created by Dara on 3/12/17.
//  Copyright © 2017 iDara09. All rights reserved.
//

import UIKit

class TypesAbilitiesMovesVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var moveSort: UISegmentedControl!
    
    var selectedMenu: HomeMenu! //must be passed when perform segue
    var types = [String]()
    var abilities = [Ability]()
    var moves = [Move]()
    var inSearchMode = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        moveSort.isHidden = true
        searchBar.returnKeyType = .search
        searchBar.enablesReturnKeyAutomatically = true
        
        prepareData()
    }

    
    /*-- Protocol Functions --*/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let selelctedMenu = self.selectedMenu!
        
        switch  selelctedMenu {
            
        case .Types:
            return types.count
            
        case .Abilities:
            return abilities.count
            
        case .Moves:
            return moves.count
            
        default: ()
        }
        
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let selelctedMenu = self.selectedMenu!
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TypesAbilitiesMovesCell") as? TypesAbilitiesMovesCell {
        
            switch selelctedMenu {
                
            case .Types:
                cell.configureTypeCell(type: types[indexPath.row])
                return cell
                
            case .Abilities:
                cell.configureAbilityCell(ability: abilities[indexPath.row])
                return cell
                
            case .Moves:
                cell.configureMoveCell(move: moves[indexPath.row])
                return cell
                
            default: ()
                
            }
        }
        
        return TypesAbilitiesMovesCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchBar.setShowsCancelButton(true, animated: true)
        
        let selectedMenu = self.selectedMenu!
        
        switch selectedMenu {
            
        case .Types:
            searchBar.placeholder = "Search pokemon type"
            
        case .Abilities:
            searchBar.placeholder = "Search ability name"
            
        case .Moves:
            searchBar.placeholder = "Search move name"
            
        default: ()
            
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        searchBar.placeholder = ""
        resignSearchBar()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        let selectedMenu = self.selectedMenu!
        
        switch selectedMenu {
        case .Types:
            types = ALL_TYPE
            
        case .Abilities:
            abilities = ALL_ABILITY
            
        case .Moves:
            moves = ALL_MOVE
            
        default:()
        }
        
        resignSearchBar()
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        resignSearchBar()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let selectedMenu = self.selectedMenu!
        
        switch selectedMenu {
        case .Types:
            if searchText == "" {
                inSearchMode = false
                types = ALL_TYPE
            } else {
                inSearchMode = true
                types = ALL_TYPE.filter({$0.range(of: searchText, options: .caseInsensitive) != nil})
            }
            
        case .Abilities:
            if searchText == "" {
                inSearchMode = false
                abilities = ALL_ABILITY
            } else {
                inSearchMode = true
                abilities = ALL_ABILITY.filter({$0.name.range(of: searchText) != nil})
            }
            
        case .Moves:
            if searchText == "" {
                inSearchMode = false
                moves = ALL_MOVE
            } else {
                inSearchMode = true
                moves = ALL_MOVE.filter({$0.name.range(of: searchText) != nil})
            }
            
        default: ()
        }
        
        tableView.reloadData()
    }
    
    /*-- Functions --*/
    func prepareData() {
        
        let selelctedMenu = self.selectedMenu!
        
        navigationItem.title = "\(selelctedMenu)"
        
        switch selelctedMenu {
            
        case .Types:
            types = ALL_TYPE
            
        case .Abilities:
            abilities = ALL_ABILITY
            
        case .Moves:
            moves = ALL_MOVE
            moveSort.isHidden = false
            
        default: ()
        }
    }
    
    func resignSearchBar() {
        
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }
    
    
    /*-- IBActions --*/
    @IBAction func sortSCSwitched(_ sender: Any) {
        
        switch moveSort.selectedSegmentIndex {
        case 0: moves = ALL_MOVE
        case 1: moves = ALL_MOVE.filter({$0.category == "Physical"})
        case 2: moves = ALL_MOVE.filter({$0.category == "Special"})
        case 3: moves = ALL_MOVE.filter({$0.category == "Status"})
        case 4: moves = ALL_MOVE.filter({$0.category == ""})
        default:()
        }
        
        tableView.reloadData()
    }
}
