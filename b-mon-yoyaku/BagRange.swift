//
//  BagRange.swift
//  b-mon-yoyaku
//
//  Created by akinov on 2018/03/05.
//  Copyright © 2018年 akinov. All rights reserved.
//

import UIKit
import os.log

class BagRange: NSObject, NSCoding {
    
    //MARK: Properties
    var start: Int
    var end: Int
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("bagRanges")
    
    //MARK: Types
    
    struct PropertyKey {
        static let start = "start"
        static let end = "end"
    }
    
    //MARK: Initialization
    
    init?(start: Int, end: Int) {
        guard start <= end else {
            return nil
        }
        
        // Initialize stored properties.
        self.start = start
        self.end = end
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(start, forKey: PropertyKey.start)
        aCoder.encode(end, forKey: PropertyKey.end)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let start = aDecoder.decodeInteger(forKey: PropertyKey.start)
        let end = aDecoder.decodeInteger(forKey: PropertyKey.end)
        
        // Must call designated initializer.
        self.init(start: start, end: end)
    }
}
