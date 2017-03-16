//
//  StringExtension.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/22/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//

import Foundation

extension NSDate {
    var age:Int {
        return NSCalendar.currentCalendar().components(.Year, fromDate: self, toDate: NSDate(), options: []).year
    }
    
    func isGreaterThanDate(dateToCompare: NSDate) -> Bool {
        
        return self.compare(dateToCompare) == NSComparisonResult.OrderedDescending
    }
    
    func isLessThanDate(dateToCompare: NSDate) -> Bool {
        
        return self.compare(dateToCompare) == NSComparisonResult.OrderedAscending
    }
    
    func equalToDate(dateToCompare: NSDate) -> Bool {
        
        return self.compare(dateToCompare) == NSComparisonResult.OrderedSame
    }

    func dblog() -> String {
        return Constants.Formatters.debugConsoleDateFormatter.stringFromDate(self)
    }

}