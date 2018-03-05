//
//  BagRangeViewController.swift
//  b-mon-yoyaku
//
//  Created by akinov on 2018/03/05.
//  Copyright © 2018年 akinov. All rights reserved.
//

import UIKit
import os.log

class BagRangeViewController: UIViewController, UINavigationControllerDelegate {
    //MARK: Properties
    @IBOutlet weak var startField: UITextField!
    @IBOutlet weak var endField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var bagRange: BagRange?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let bagRange = bagRange {
            startField.text   = bagRange.start.description
            endField.text = bagRange.end.description
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let start = Int(startField.text!)
        let end = Int(endField.text!)
        
        // Set the bagRange to be passed to BagRangeTableViewController after the unwind segue.
        bagRange = BagRange(start: start!, end: end!)
    }
}
