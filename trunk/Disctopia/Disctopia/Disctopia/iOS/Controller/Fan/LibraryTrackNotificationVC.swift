//
//  LibraryTrackNotificationVC.swift
//  Disctopia
//
//  Created by Brijesh shiroya on 9/29/16.
//  Copyright © 2016 'byPeople Technologies'. All rights reserved.
//

import UIKit

class LibraryTrackNotificationVC: BaseVC {

    @IBOutlet weak var trackFavAddNotificatioView: UIView!
    @IBOutlet weak var trackAddRemoveLabel: UILabel!
    var lbl:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        if(lbl != nil)
        {
            trackAddRemoveLabel.text = lbl
        }
        //appDelegate.isLoderRequired = false
        BaseVC.sharedInstance.hideLoader()
        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(animated: Bool)
    {
         NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(LibraryTrackNotificationVC.onCloseSaveChangeView(_:)), userInfo: nil, repeats: false)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCloseSaveChangeView(sender: UIButton)
        {
            self.dismissViewControllerAnimated(true, completion: nil)
            
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
