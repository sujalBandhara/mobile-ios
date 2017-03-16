//
//  ReportAlbumViewController.swift
//  Disctopia
//
//  Created by Dhaval on 03/08/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ReportAlbumViewController: BaseVC, UITextViewDelegate
{
    
    // MARK: - Outlets

    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var btnSend: UIButton!
    
    @IBOutlet weak var btnCancel: UIButton!
    
    
    // MARK: - Methods

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        btnCancel.layer.borderColor = UIColor.whiteColor().CGColor
        btnCancel.layer.borderWidth = 1
        
        btnSend.layer.borderColor = UIColor.whiteColor().CGColor
        btnSend.layer.borderWidth = 1
        
        textView.delegate = self
        textView.text = "Enter report:"
        textView.textColor = UIColor.lightGrayColor()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.navigationController?.navigationBarHidden = true
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnSendReport(sender: AnyObject){
        
        if textView.text.characters.count > 0
        {
            if appDelegate.selectedAlbumId.characters.count > 0
            {
                let reason = textView.text
                var param = Dictionary<String, String>()
                param["albumId"] = appDelegate.selectedAlbumId
                param["reason"] = reason
                DLog("param = \(param)")
                API.reportAlbum(param, aViewController: self) { (result: JSON) in
                    if ( result != nil )
                    {
                        self.DAlert(ALERT_TITLE, message: "Successfully added", action: ALERT_OK, sender: self)
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                }
            }
        }
        else
        {
            self.DAlert(ALERT_TITLE, message: "Please enter report", action: ALERT_OK, sender: self)
        }
    }
    
    // MARK: - Actions

    @IBAction func btnCancel(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - Functions

    func textViewDidEndEditing(textView: UITextView)
    {
        if textView.text.isEmpty
        {
            textView.text = "Enter report:"
            textView.textColor = UIColor.lightGrayColor()
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView)
    {
        if textView.textColor == UIColor.lightGrayColor()
        {
            textView.text = nil
            textView.textColor = UIColor.whiteColor()
        }
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
