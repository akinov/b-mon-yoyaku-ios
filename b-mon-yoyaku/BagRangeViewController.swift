//
//  BagRangeViewController
.swift
//  b-mon-yoyaku
//
//  Created by akinov on 2018/03/05.
//  Copyright © 2018年 akinov. All rights reserved.
//

import UIKit

class BagRangeViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var bagRange: BagRange?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("1")
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
