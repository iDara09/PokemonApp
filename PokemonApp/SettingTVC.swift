//
//  SettingTVC.swift
//  PokemonApp
//
//  Created by Dara on 3/12/17.
//  Copyright © 2017 iDara09. All rights reserved.
//

import UIKit

private enum SettingMenu: String { //String = "\(indexPath.section)\(indexPath.row)"
    case Disclaimer = "10"
    case SendFeedback = "11"
    case GitHub = "12"
    
    case ShareOnTwitter = "20"
    case ShareOnFacebook = "21"
}

private enum SettingSection: Int {
    case Display
    case Developer
    case Share
}


class SettingTVC: UITableViewController {
    
    @IBOutlet weak var measurementSC: SortSC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !UserDefaults.standard.measurementDidSetToSIUnit {
            measurementSC.selectedSegmentIndex = 1
        }
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let section = SettingSection(rawValue: section) {
            switch section {
            case .Display: return 1
            case .Developer: return 3
            case .Share: return 2
            }
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func measuremntUnitSwitched(_ sender: Any) {
        
        if UserDefaults.standard.measurementDidSetToSIUnit {
            UserDefaults.standard.setMeasurementUnitToSIUnit(false)
        } else {
            UserDefaults.standard.setMeasurementUnitToSIUnit(true)
        }
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
