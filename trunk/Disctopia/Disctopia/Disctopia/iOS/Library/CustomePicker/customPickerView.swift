//
//  selectedIndexPickerView.swift
//  Disctopia
//
//  Created by Mitesh on 23/06/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
class customPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource
{
    
    //let selectedIndexs = ["INDIA", "USA", "UK", "JAPAN", "Canada", "France", "Germany"]
    var customArray = []
    var customekey = ""
    var selectedIndex: Int = 0 {
        didSet {
            selectRow(selectedIndex-1, inComponent: 0, animated: false)
        }
    }
    
    var onDateSelected: ((selectedIndex: [String:String]) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonSetup()
    }
    
    func commonSetup()
    { 
        self.delegate = self
        self.dataSource = self
        
        // Date picker Change Text color
        self.setValue(UIColor.whiteColor(), forKeyPath: "textColor")
        self.tintColor = UIColor.whiteColor()
       
        self.performSelector(Selector("_setHighlightColor:"), withObject:UIColor.blueColor())
        //self.backgroundColor = UIColor.clearColor().colorWithAlphaComponent(0.3)
        self.reloadAllComponents()
       
    }

    // Mark: UIPicker Delegate / Data Source
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var dataStr = ""
        
        let customDict = customArray[row] 
        if let customName = customDict[customekey] as? String
        {
            dataStr = customName
        }
        else
        {
            dataStr = ""
        }
        
        let attributedString = NSAttributedString(string: dataStr, attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        return attributedString
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return customArray.count
         default:
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        let selectedIndex = self.selectedRowInComponent(0)+1
        
        if let block = onDateSelected where row < customArray.count
        {
            let customDict = customArray[row]

            block(selectedIndex: customDict as! [String : String])
        }
        self.selectedIndex = selectedIndex
    }
}
