//
//  BagRangeTableViewController.swift
//  b-mon-yoyaku
//
//  Created by akinov on 2018/03/05.
//  Copyright © 2018年 akinov. All rights reserved.
//

import UIKit
import os.log

class BagRangeTableViewController: UITableViewController {
    //MARK: Properties
    var bagRanges = [BagRange]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedBagRanges = loadBagRanges() {
            bagRanges += savedBagRanges
        }
        else {
            // Load the sample data.
            loadDefaultBagRanges()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return bagRanges.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "BagRangeTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? BagRangeTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let bagRange = bagRanges[indexPath.row]
        
        cell.startLabel.text = bagRange.start.description
        cell.endLabel.text = bagRange.end.description
        
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            bagRanges.remove(at: indexPath.row)
            saveBagRanges()
            tableView.deleteRows(at: [indexPath], with: .fade)
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

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "AddItem":
            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let bagRangeViewController = segue.destination as? BagRangeViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedCell = sender as? BagRangeTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedBagRange = bagRanges[indexPath.row]
            bagRangeViewController.bagRange = selectedBagRange
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    @IBAction func done(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: Actions
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? BagRangeViewController, let bagRange = sourceViewController.bagRange {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing bagRange.
                bagRanges[selectedIndexPath.row] = bagRange
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new meal.
                let newIndexPath = IndexPath(row: bagRanges.count, section: 0)
                
                bagRanges.append(bagRange)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            // Save the meals.
            saveBagRanges()
        }
    }
    @IBAction func resetClicked(_ sender: Any) {
        let alertController = UIAlertController(title: "リセットしますか？", message: "登録済のバッグ番号を取り消して初期設定に戻します。", preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) -> Void in
            self.loadDefaultBagRanges()
            self.saveBagRanges()
            self.tableView.reloadData()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))

        self.present(alertController, animated: true, completion: nil)
    }
    
    
    //MARK: Private Methods
    
    private func loadDefaultBagRanges() {
        guard let range1 = BagRange(start: 21, end: 27) else {
            fatalError("Unable to instantiate meal1")
        }
        
        guard let range2 = BagRange(start: 35, end: 41) else {
            fatalError("Unable to instantiate meal2")
        }
        
        guard let range3 = BagRange(start: 48, end: 52) else {
            fatalError("Unable to instantiate meal2")
        }
        
        guard let range4 = BagRange(start: 60, end: 66) else {
            fatalError("Unable to instantiate meal2")
        }
        
        guard let range5 = BagRange(start: 74, end: 80) else {
            fatalError("Unable to instantiate meal2")
        }
        
        bagRanges = [range1, range2, range3, range4, range5]
    }
    
    private func saveBagRanges() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(bagRanges, toFile: BagRange.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("BagRanges successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadBagRanges() -> [BagRange]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: BagRange.ArchiveURL.path) as? [BagRange]
    }
}
